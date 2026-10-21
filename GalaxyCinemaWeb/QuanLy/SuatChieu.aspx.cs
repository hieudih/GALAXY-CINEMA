using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace GalaxyCinemaWeb.QuanLy
{
    public partial class SuatChieu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "QuanLy");
            if (IsPostBack) return;
            ddlPhim.DataSource = Db.Query("SELECT MaPhim, TenPhim + N' (' + CAST(ThoiLuong AS VARCHAR(5)) + N' phút)' AS Ten FROM tblPhim ORDER BY TenPhim");
            ddlPhim.DataTextField = "Ten"; ddlPhim.DataValueField = "MaPhim"; ddlPhim.DataBind();
            ddlPhong.DataSource = Db.Query("SELECT MaPhong, TenPhong + N' - ' + LoaiPhong AS Ten FROM tblPhongChieu ORDER BY MaPhong");
            ddlPhong.DataTextField = "Ten"; ddlPhong.DataValueField = "MaPhong"; ddlPhong.DataBind();
            NapDuLieu();
        }

        private void NapDuLieu()
        {
            gvSuat.DataSource = Db.Query(
                @"SELECT sc.MaSuat, p.TenPhim, pc.TenPhong, sc.NgayChieu, sc.GioBatDau,
                         DATEADD(MINUTE, p.ThoiLuong, CAST(sc.NgayChieu AS DATETIME) + CAST(sc.GioBatDau AS DATETIME)) AS GioKetThuc,
                         (SELECT COUNT(*) FROM tblVe v WHERE v.MaSuat = sc.MaSuat AND v.TrangThaiVe <> N'Đã hủy') AS SoVe
                  FROM tblSuatChieu sc JOIN tblPhim p ON sc.MaPhim = p.MaPhim JOIN tblPhongChieu pc ON sc.MaPhong = pc.MaPhong
                  WHERE sc.NgayChieu >= CAST(GETDATE() AS DATE)
                  ORDER BY sc.NgayChieu, sc.GioBatDau, sc.MaPhong");
            gvSuat.DataBind();
        }

        protected void btnThem_Click(object sender, EventArgs e)
        {
            DateTime? ngay = Db.DocNgay(txtNgay.Text);
            TimeSpan? gio = Db.DocGio(txtGio.Text);
            if (ngay == null || gio == null) { Bao("Vui lòng chọn ngày và giờ chiếu.", false); return; }
            DateTime batDau = ngay.Value + gio.Value;
            if (batDau <= DateTime.Now) { Bao("Giờ chiếu phải sau thời điểm hiện tại.", false); return; }

            DataRow phim = Db.Query("SELECT ThoiLuong, NgayKhoiChieu FROM tblPhim WHERE MaPhim = @p", "@p", ddlPhim.SelectedValue).Rows[0];
            if (ngay.Value < (DateTime)phim["NgayKhoiChieu"]) { Bao("Ngày chiếu phải từ ngày khởi chiếu của phim trở đi.", false); return; }
            int thoiLuong = (int)phim["ThoiLuong"];

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                int trung = Convert.ToInt32(Db.Cmd(cn, tr,
                    @"SELECT COUNT(*) FROM tblSuatChieu sc WITH (UPDLOCK, HOLDLOCK) JOIN tblPhim p ON sc.MaPhim = p.MaPhim
                      WHERE sc.MaPhong = @ph
                        AND @bd < DATEADD(MINUTE, p.ThoiLuong + 15, CAST(sc.NgayChieu AS DATETIME) + CAST(sc.GioBatDau AS DATETIME))
                        AND CAST(sc.NgayChieu AS DATETIME) + CAST(sc.GioBatDau AS DATETIME) < DATEADD(MINUTE, @tl + 15, @bd)",
                    "@ph", ddlPhong.SelectedValue, "@bd", batDau, "@tl", thoiLuong).ExecuteScalar());
                if (trung > 0) { tr.Rollback(); Bao("Phòng đã có suất chiếu trùng khung giờ này.", false); return; }

                string ma = Db.NextId(cn, tr, "SC", "tblSuatChieu", "MaSuat");
                Db.Cmd(cn, tr, "INSERT INTO tblSuatChieu (MaSuat, MaPhim, MaPhong, NgayChieu, GioBatDau) VALUES (@m, @p, @ph, @n, @g)",
                       "@m", ma, "@p", ddlPhim.SelectedValue, "@ph", ddlPhong.SelectedValue, "@n", ngay.Value.Date, "@g", gio.Value).ExecuteNonQuery();
                tr.Commit();
                Bao("Đã thêm suất chiếu " + ma + ".", true);
            }
            NapDuLieu();
        }

        protected void gvSuat_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Xoa") return;
            try
            {
                Db.Execute("DELETE FROM tblSuatChieu WHERE MaSuat = @m", "@m", (string)e.CommandArgument);
                Bao("Đã xóa suất chiếu.", true);
            }
            catch (SqlException ex) when (ex.Number == 547)
            {
                Bao("Không thể xóa: suất chiếu đã có vé.", false);
            }
            NapDuLieu();
        }

        private void Bao(string s, bool ok) { lblThongBao.Text = s; lblThongBao.CssClass = ok ? "ok" : "loi"; }
    }
}
