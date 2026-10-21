using System;
using System.Data;
using System.Web;

namespace GalaxyCinemaWeb
{
    public partial class SoatVe : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "SoatVe");
        }

        protected void btnSoat_Click(object sender, EventArgs e)
        {
            string maVe = txtMaVe.Text.Trim().ToUpper();
            DataTable dt = Db.Query(
                @"SELECT v.TrangThaiVe, v.ThoiDiemSoat, d.TrangThaiDon, sc.NgayChieu, sc.GioBatDau,
                         p.TenPhim, pc.TenPhong, g.HangGhe + CAST(g.SoGhe AS VARCHAR(3)) AS Ghe
                  FROM tblVe v JOIN tblDonDatVe d ON v.MaDon = d.MaDon
                  JOIN tblSuatChieu sc ON v.MaSuat = sc.MaSuat JOIN tblPhim p ON sc.MaPhim = p.MaPhim
                  JOIN tblPhongChieu pc ON sc.MaPhong = pc.MaPhong JOIN tblGhe g ON v.MaGhe = g.MaGhe
                  WHERE v.MaVe = @v", "@v", maVe);

            litChiTiet.Text = "";
            if (dt.Rows.Count == 0) { KetQua(false, "Không tìm thấy vé."); return; }
            DataRow r = dt.Rows[0];
            litChiTiet.Text = HttpUtility.HtmlEncode(string.Format("{0} - {1} - {2:dd/MM/yyyy} {3:hh\\:mm} - Ghế {4}",
                r["TenPhim"], r["TenPhong"], r["NgayChieu"], r["GioBatDau"], r["Ghe"]));

            string ttVe = (string)r["TrangThaiVe"];
            if ((string)r["TrangThaiDon"] != "Đã thanh toán") { KetQua(false, "Vé không hợp lệ: đơn chưa thanh toán hoặc đã hủy."); return; }
            if (ttVe == "Đã hủy") { KetQua(false, "Vé không hợp lệ: vé đã bị hủy."); return; }
            if (ttVe == "Đã soát") { KetQua(false, "Vé không hợp lệ: vé đã được soát lúc " + ((DateTime)r["ThoiDiemSoat"]).ToString("HH:mm dd/MM/yyyy") + "."); return; }
            if (((DateTime)r["NgayChieu"]).Date != DateTime.Today) { KetQua(false, "Vé không hợp lệ: không phải suất chiếu hôm nay."); return; }

            int n = Db.Execute("UPDATE tblVe SET TrangThaiVe = N'Đã soát', ThoiDiemSoat = GETDATE() WHERE MaVe = @v AND TrangThaiVe = N'Chưa soát'", "@v", maVe);
            KetQua(n == 1, n == 1 ? "Vé hợp lệ. Mời khách vào phòng." : "Vé vừa được soát ở cửa khác.");
        }

        private void KetQua(bool hopLe, string thongBao)
        {
            lblKetQua.Text = thongBao;
            lblKetQua.CssClass = hopLe ? "ok" : "loi";
        }
    }
}
