using System;
using System.Data;

namespace GalaxyCinemaWeb.QuanLy
{
    public partial class BaoCao : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "QuanLy");
            if (IsPostBack) return;
            DateTime dau = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            txtTu.Text = dau.ToString("yyyy-MM-dd");
            txtDen.Text = dau.AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd");
            NapBaoCao(dau, dau.AddMonths(1).AddDays(-1));
            gvPhanHoi.DataSource = Db.Query(
                @"SELECT ph.ThoiDiemGui, k.HoTen, ph.NoiDung FROM tblPhanHoi ph JOIN tblKhachHang k ON ph.MaKH = k.MaKH
                  ORDER BY ph.ThoiDiemGui DESC");
            gvPhanHoi.DataBind();
        }

        protected void btnXem_Click(object sender, EventArgs e)
        {
            DateTime? tu = Db.DocNgay(txtTu.Text), den = Db.DocNgay(txtDen.Text);
            if (tu == null || den == null || den < tu) { lblThongBao.Text = "Khoảng thời gian không hợp lệ."; return; }
            lblThongBao.Text = "";
            NapBaoCao(tu.Value, den.Value);
        }

        private void NapBaoCao(DateTime tu, DateTime den)
        {
            DateTime denSau = den.Date.AddDays(1);
            DataRow t = Db.Query(
                @"SELECT ISNULL(SUM(CASE WHEN LoaiGiaoDich = N'Thanh toán' THEN SoTien END), 0) AS Thu,
                         ISNULL(SUM(CASE WHEN LoaiGiaoDich = N'Hoàn tiền' THEN SoTien END), 0) AS Hoan
                  FROM tblThanhToan WHERE TrangThai = N'Thành công' AND ThoiDiem >= @a AND ThoiDiem < @b",
                "@a", tu.Date, "@b", denSau).Rows[0];
            decimal thu = (decimal)t["Thu"], hoan = (decimal)t["Hoan"];
            litThu.Text = thu.ToString("N0");
            litHoan.Text = hoan.ToString("N0");
            litThucThu.Text = (thu - hoan).ToString("N0");

            const string veHopLe = "FROM tblVe v JOIN tblDonDatVe d ON v.MaDon = d.MaDon AND d.TrangThaiDon = N'Đã thanh toán' ";
            litSoVe.Text = Convert.ToInt32(Db.Scalar(
                "SELECT COUNT(*) " + veHopLe + "JOIN tblSuatChieu sc ON v.MaSuat = sc.MaSuat WHERE sc.NgayChieu BETWEEN @a AND @b",
                "@a", tu.Date, "@b", den.Date)).ToString("N0");

            gvPhim.DataSource = Db.Query(
                @"SELECT p.TenPhim, COUNT(DISTINCT v.MaSuat) AS SoSuat, COUNT(v.MaVe) AS SoVe, SUM(bg.GiaVe) AS TienVe " + veHopLe +
                @"JOIN tblSuatChieu sc ON v.MaSuat = sc.MaSuat JOIN tblPhim p ON sc.MaPhim = p.MaPhim
                  JOIN tblBangGia bg ON v.MaGia = bg.MaGia
                  WHERE sc.NgayChieu BETWEEN @a AND @b
                  GROUP BY p.TenPhim ORDER BY TienVe DESC", "@a", tu.Date, "@b", den.Date);
            gvPhim.DataBind();

            gvSuat.DataSource = Db.Query(
                @"SELECT sc.MaSuat, p.TenPhim, sc.NgayChieu, sc.GioBatDau, pc.TenPhong,
                         (SELECT COUNT(*) " + veHopLe + @"WHERE v.MaSuat = sc.MaSuat) AS SoVe,
                         (SELECT COUNT(*) FROM tblGhe g WHERE g.MaPhong = sc.MaPhong) AS TongGhe
                  FROM tblSuatChieu sc JOIN tblPhim p ON sc.MaPhim = p.MaPhim JOIN tblPhongChieu pc ON sc.MaPhong = pc.MaPhong
                  WHERE sc.NgayChieu BETWEEN @a AND @b
                  ORDER BY sc.NgayChieu, sc.GioBatDau", "@a", tu.Date, "@b", den.Date);
            gvSuat.DataBind();
        }
    }
}
