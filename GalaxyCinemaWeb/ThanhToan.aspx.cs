using System;
using System.Data;
using System.Data.SqlClient;

namespace GalaxyCinemaWeb
{
    public partial class ThanhToan : System.Web.UI.Page
    {
        private string MaDon { get { return Request.QueryString["MaDon"]; } }
        private decimal tongTien;

        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "KhachHang");

            DataTable don = Db.Query(
                @"SELECT d.TrangThaiDon, ISNULL(km.MucGiam, 0) AS MucGiam
                  FROM tblDonDatVe d LEFT JOIN tblKhuyenMai km ON d.MaKM = km.MaKM
                  WHERE d.MaDon = @d AND d.MaKH = @k", "@d", MaDon, "@k", Session["MaKH"]);
            if (don.Rows.Count == 0) { Response.Redirect("~/VeCuaToi.aspx"); return; }

            DataTable ve = Db.Query(
                @"SELECT v.MaVe, p.TenPhim, sc.NgayChieu, sc.GioBatDau, g.HangGhe + CAST(g.SoGhe AS VARCHAR(3)) AS Ghe,
                         g.LoaiGhe, bg.GiaVe
                  FROM tblVe v JOIN tblSuatChieu sc ON v.MaSuat = sc.MaSuat
                  JOIN tblPhim p ON sc.MaPhim = p.MaPhim JOIN tblGhe g ON v.MaGhe = g.MaGhe
                  JOIN tblBangGia bg ON v.MaGia = bg.MaGia
                  WHERE v.MaDon = @d ORDER BY v.MaVe", "@d", MaDon);
            gvVe.DataSource = ve;
            gvVe.DataBind();

            decimal tienVe = 0;
            foreach (DataRow r in ve.Rows) tienVe += (decimal)r["GiaVe"];
            decimal giam = Math.Min((decimal)don.Rows[0]["MucGiam"], tienVe);
            tongTien = tienVe - giam;

            litMaDon.Text = MaDon;
            litTienVe.Text = tienVe.ToString("N0");
            litGiam.Text = giam.ToString("N0");
            litTong.Text = tongTien.ToString("N0");

            string tt = (string)don.Rows[0]["TrangThaiDon"];
            if (tt != "Chờ thanh toán")
            {
                btnThanhToan.Visible = false;
                lblThongBao.Text = "Đơn này " + tt.ToLower() + ".";
            }
        }

        protected void btnThanhToan_Click(object sender, EventArgs e)
        {
            string maTT;
            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                int conHan = Convert.ToInt32(Db.Cmd(cn, tr,
                    @"SELECT COUNT(*) FROM tblDonDatVe WITH (UPDLOCK)
                      WHERE MaDon = @d AND MaKH = @k AND TrangThaiDon = N'Chờ thanh toán'
                        AND NgayDat >= DATEADD(MINUTE, -8, GETDATE())",
                    "@d", MaDon, "@k", Session["MaKH"]).ExecuteScalar());
                if (conHan == 0)
                {
                    tr.Rollback();
                    lblThongBao.Text = "Đơn đã quá thời gian giữ ghế hoặc không còn chờ thanh toán. Vui lòng đặt lại.";
                    return;
                }
                maTT = Db.NextId(cn, tr, "TT", "tblThanhToan", "MaTT");
                Db.Cmd(cn, tr,
                    @"INSERT INTO tblThanhToan (MaTT, MaDon, PhuongThuc, LoaiGiaoDich, SoTien, TrangThai)
                      VALUES (@t, @d, @pt, N'Thanh toán', @tien, N'Đang xử lý')",
                    "@t", maTT, "@d", MaDon, "@pt", ddlPhuongThuc.SelectedValue, "@tien", tongTien).ExecuteNonQuery();
                tr.Commit();
            }

            bool thanhCong = ddlKetQua.SelectedValue == "OK";
            string maGD = "GD" + DateTime.Now.ToString("yyyyMMddHHmmss");

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                if (thanhCong)
                {
                    int n = Db.Cmd(cn, tr,
                        @"UPDATE tblDonDatVe SET TrangThaiDon = N'Đã thanh toán'
                          WHERE MaDon = @d AND TrangThaiDon = N'Chờ thanh toán'
                            AND NgayDat >= DATEADD(MINUTE, -8, GETDATE())", "@d", MaDon).ExecuteNonQuery();
                    if (n == 1)
                    {
                        Db.Cmd(cn, tr, "UPDATE tblThanhToan SET TrangThai = N'Thành công', MaGiaoDichCong = @gd, ThoiDiem = GETDATE() WHERE MaTT = @t",
                               "@gd", maGD, "@t", maTT).ExecuteNonQuery();
                        tr.Commit();
                        Response.Redirect("~/VeCuaToi.aspx", false);
                        return;
                    }
                    Db.Cmd(cn, tr, "UPDATE tblThanhToan SET TrangThai = N'Thất bại', MaGiaoDichCong = @gd WHERE MaTT = @t",
                           "@gd", maGD, "@t", maTT).ExecuteNonQuery();
                    tr.Commit();
                    lblThongBao.Text = "Đơn đã hết thời gian giữ ghế nên không thể xác nhận. Giao dịch được ghi nhận để đối chiếu và hoàn tiền.";
                    return;
                }
                Db.Cmd(cn, tr, "UPDATE tblThanhToan SET TrangThai = N'Thất bại' WHERE MaTT = @t", "@t", maTT).ExecuteNonQuery();
                tr.Commit();
            }
            lblThongBao.Text = "Thanh toán thất bại. Bạn có thể thử lại trong thời gian giữ ghế.";
        }
    }
}
