using System;

namespace GalaxyCinemaWeb.QuanLy
{
    public partial class TongQuan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "QuanLy");
            if (IsPostBack) return;

            DateTime dau = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1), cuoi = dau.AddMonths(1);
            litThang.Text = dau.ToString("MM/yyyy");

            litSoVe.Text = Convert.ToInt32(Db.Scalar(
                @"SELECT COUNT(*) FROM tblVe v JOIN tblDonDatVe d ON v.MaDon = d.MaDon
                  WHERE d.TrangThaiDon = N'Đã thanh toán' AND d.NgayDat >= @a AND d.NgayDat < @b", "@a", dau, "@b", cuoi)).ToString("N0");
            litDoanhThu.Text = Convert.ToDecimal(Db.Scalar(
                @"SELECT ISNULL(SUM(CASE WHEN LoaiGiaoDich = N'Thanh toán' THEN SoTien ELSE -SoTien END), 0)
                  FROM tblThanhToan WHERE TrangThai = N'Thành công' AND ThoiDiem >= @a AND ThoiDiem < @b", "@a", dau, "@b", cuoi)).ToString("N0");
            litKhach.Text = Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM tblKhachHang")).ToString("N0");
            litSuatHomNay.Text = Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM tblSuatChieu WHERE NgayChieu = CAST(GETDATE() AS DATE)")).ToString();

            gvTopPhim.DataSource = Db.Query(
                @"SELECT TOP 5 p.TenPhim, COUNT(v.MaVe) AS SoVe, SUM(bg.GiaVe) AS DoanhThuVe
                  FROM tblVe v JOIN tblDonDatVe d ON v.MaDon = d.MaDon
                  JOIN tblSuatChieu sc ON v.MaSuat = sc.MaSuat JOIN tblPhim p ON sc.MaPhim = p.MaPhim
                  JOIN tblBangGia bg ON v.MaGia = bg.MaGia
                  WHERE d.TrangThaiDon = N'Đã thanh toán' AND d.NgayDat >= @a AND d.NgayDat < @b
                  GROUP BY p.TenPhim ORDER BY SoVe DESC", "@a", dau, "@b", cuoi);
            gvTopPhim.DataBind();

            gvDonMoi.DataSource = Db.Query(
                @"SELECT TOP 8 d.MaDon, k.HoTen, d.NgayDat, d.TrangThaiDon,
                         (SELECT COUNT(*) FROM tblVe v WHERE v.MaDon = d.MaDon) AS SoVe
                  FROM tblDonDatVe d JOIN tblKhachHang k ON d.MaKH = k.MaKH ORDER BY d.NgayDat DESC");
            gvDonMoi.DataBind();
        }
    }
}
