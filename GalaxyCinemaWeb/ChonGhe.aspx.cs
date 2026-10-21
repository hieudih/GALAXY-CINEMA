using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

namespace GalaxyCinemaWeb
{
    public partial class ChonGhe : System.Web.UI.Page
    {
        private string MaSuat { get { return Request.QueryString["MaSuat"]; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "KhachHang");
            Db.HuyDonQuaHan();

            DataTable suat = Db.Query(
                @"SELECT p.TenPhim, pc.TenPhong, pc.LoaiPhong, sc.NgayChieu, sc.GioBatDau
                  FROM tblSuatChieu sc JOIN tblPhim p ON sc.MaPhim = p.MaPhim
                  JOIN tblPhongChieu pc ON sc.MaPhong = pc.MaPhong
                  WHERE sc.MaSuat = @s", "@s", MaSuat);
            if (suat.Rows.Count == 0) { Response.Redirect("~/Default.aspx"); return; }
            DataRow r = suat.Rows[0];
            litTenPhim.Text = HttpUtility.HtmlEncode((string)r["TenPhim"]);
            litThongTinSuat.Text = HttpUtility.HtmlEncode(string.Format("{0} ({1}) - {2:dd/MM/yyyy} lúc {3:hh\\:mm}",
                r["TenPhong"], r["LoaiPhong"], r["NgayChieu"], r["GioBatDau"]));

            VeSoDoGhe();

            if (!IsPostBack)
            {
                ddlKhuyenMai.DataSource = Db.Query(
                    @"SELECT MaKM, TenKM + N' (giảm ' + FORMAT(MucGiam, 'N0') + N' đ)' AS Ten
                      FROM tblKhuyenMai WHERE CAST(GETDATE() AS DATE) BETWEEN NgayBatDau AND NgayKetThuc");
                ddlKhuyenMai.DataTextField = "Ten";
                ddlKhuyenMai.DataValueField = "MaKM";
                ddlKhuyenMai.DataBind();
                ddlKhuyenMai.Items.Insert(0, new ListItem("Không dùng khuyến mãi", ""));
            }
        }

        private void VeSoDoGhe()
        {
            DataTable ghe = Db.Query(
                @"SELECT g.MaGhe, g.HangGhe, g.SoGhe, g.LoaiGhe,
                         CASE WHEN EXISTS (SELECT 1 FROM tblVe v WHERE v.MaSuat = sc.MaSuat
                                           AND v.MaGhe = g.MaGhe AND v.TrangThaiVe <> N'Đã hủy')
                              THEN 1 ELSE 0 END AS DaBan
                  FROM tblGhe g JOIN tblSuatChieu sc ON g.MaPhong = sc.MaPhong
                  WHERE sc.MaSuat = @s ORDER BY g.HangGhe, g.SoGhe", "@s", MaSuat);

            var sb = new StringBuilder();
            string hang = null;
            foreach (DataRow g in ghe.Rows)
            {
                if ((string)g["HangGhe"] != hang)
                {
                    if (hang != null) sb.Append("</div>");
                    hang = (string)g["HangGhe"];
                    sb.Append("<div class='hang'>");
                }
                bool daBan = Convert.ToInt32(g["DaBan"]) == 1;
                string css = "ghe" + ((string)g["LoaiGhe"] == "VIP" ? " vip" : "") + (daBan ? " da-ban" : "");
                sb.AppendFormat("<label class='{0}'>{1}{2}<input type='checkbox' name='ghe' value='{3}'{4} /></label>",
                    css, HttpUtility.HtmlEncode(hang), g["SoGhe"], HttpUtility.HtmlAttributeEncode((string)g["MaGhe"]), daBan ? " disabled" : "");
            }
            if (hang != null) sb.Append("</div>");
            litSoDoGhe.Text = sb.ToString();
        }

        protected void btnDatVe_Click(object sender, EventArgs e)
        {
            string[] dsGhe = Request.Form.GetValues("ghe");
            if (dsGhe == null || dsGhe.Length == 0) { lblThongBao.Text = "Vui lòng chọn ít nhất một ghế."; return; }
            if (dsGhe.Length > 8) { lblThongBao.Text = "Mỗi đơn đặt tối đa 8 ghế."; return; }
            string maKM = ddlKhuyenMai.SelectedValue == "" ? null : ddlKhuyenMai.SelectedValue;
            string maDon = null;

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                try
                {
                    DataTable st = Db.Query(cn, tr,
                        @"SELECT MaPhong, NgayChieu,
                                 CASE WHEN CAST(NgayChieu AS DATETIME) + CAST(GioBatDau AS DATETIME) > GETDATE() THEN 1 ELSE 0 END AS ConBan
                          FROM tblSuatChieu WHERE MaSuat = @s", "@s", MaSuat);
                    DataRow suat = st.Rows[0];
                    if (Convert.ToInt32(suat["ConBan"]) == 0) throw new InvalidOperationException("Suất chiếu đã bắt đầu, không thể đặt vé.");
                    string loaiNgay = Db.LoaiNgay((DateTime)suat["NgayChieu"]);

                    maDon = Db.NextId(cn, tr, "DV", "tblDonDatVe", "MaDon");
                    Db.Cmd(cn, tr, "INSERT INTO tblDonDatVe (MaDon, MaKH, MaKM, TrangThaiDon) VALUES (@d, @k, @km, N'Chờ thanh toán')",
                           "@d", maDon, "@k", Session["MaKH"], "@km", maKM).ExecuteNonQuery();

                    foreach (string maGhe in dsGhe)
                    {
                        DataTable gh = Db.Query(cn, tr, "SELECT LoaiGhe FROM tblGhe WHERE MaGhe = @g AND MaPhong = @p",
                                                "@g", maGhe, "@p", suat["MaPhong"]);
                        if (gh.Rows.Count == 0) throw new InvalidOperationException("Ghế không hợp lệ.");

                        object maGia = Db.Cmd(cn, tr,
                            @"SELECT TOP 1 MaGia FROM tblBangGia WHERE LoaiGhe = @lg AND LoaiNgay = @ln AND NgayApDung <= @n
                              ORDER BY NgayApDung DESC",
                            "@lg", gh.Rows[0]["LoaiGhe"], "@ln", loaiNgay, "@n", suat["NgayChieu"]).ExecuteScalar();
                        if (maGia == null) throw new InvalidOperationException("Chưa có bảng giá cho loại ghế này.");

                        string maVe = Db.NextId(cn, tr, "V", "tblVe", "MaVe");
                        Db.Cmd(cn, tr, "INSERT INTO tblVe (MaVe, MaDon, MaSuat, MaGhe, MaGia) VALUES (@v, @d, @s, @g, @gia)",
                               "@v", maVe, "@d", maDon, "@s", MaSuat, "@g", maGhe, "@gia", maGia).ExecuteNonQuery();
                    }
                    tr.Commit();
                }
                catch (SqlException ex) when (ex.Number == 2601 || ex.Number == 2627)
                {
                    tr.Rollback();
                    lblThongBao.Text = "Có ghế vừa được người khác đặt, vui lòng chọn lại.";
                    VeSoDoGhe();
                    return;
                }
                catch (InvalidOperationException ex)
                {
                    tr.Rollback();
                    lblThongBao.Text = ex.Message;
                    return;
                }
            }
            Response.Redirect("~/ThanhToan.aspx?MaDon=" + maDon, false);
        }
    }
}
