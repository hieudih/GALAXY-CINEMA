using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace GalaxyCinemaWeb
{
    public partial class VeCuaToi : System.Web.UI.Page
    {
        private const string DieuKienHuy =
            @"d.TrangThaiDon = N'Đã thanh toán'
              AND NOT EXISTS (SELECT 1 FROM tblVe v WHERE v.MaDon = d.MaDon AND v.TrangThaiVe <> N'Chưa soát')
              AND NOT EXISTS (SELECT 1 FROM tblVe v JOIN tblSuatChieu s ON v.MaSuat = s.MaSuat
                              WHERE v.MaDon = d.MaDon
                                AND CAST(s.NgayChieu AS DATETIME) + CAST(s.GioBatDau AS DATETIME) <= GETDATE())";

        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "KhachHang");
            if (!IsPostBack) NapDuLieu();
        }

        private void NapDuLieu()
        {
            gvDon.DataSource = Db.Query(
                @"SELECT d.MaDon, d.NgayDat, d.TrangThaiDon, p.TenPhim, sc.NgayChieu, sc.GioBatDau, pc.TenPhong,
                         STUFF((SELECT ', ' + v2.MaVe + ' (' + g.HangGhe + CAST(g.SoGhe AS VARCHAR(3)) + ')'
                                FROM tblVe v2 JOIN tblGhe g ON v2.MaGhe = g.MaGhe
                                WHERE v2.MaDon = d.MaDon ORDER BY v2.MaVe FOR XML PATH('')), 1, 2, '') AS DanhSachVe,
                         (SELECT SUM(bg.GiaVe) FROM tblVe v3 JOIN tblBangGia bg ON v3.MaGia = bg.MaGia WHERE v3.MaDon = d.MaDon)
                           - ISNULL(km.MucGiam, 0) AS TongTien,
                         CASE WHEN " + DieuKienHuy + @" THEN 1 ELSE 0 END AS CoTheHuy
                  FROM tblDonDatVe d
                  CROSS APPLY (SELECT TOP 1 v.MaSuat FROM tblVe v WHERE v.MaDon = d.MaDon) x
                  JOIN tblSuatChieu sc ON sc.MaSuat = x.MaSuat
                  JOIN tblPhim p ON sc.MaPhim = p.MaPhim
                  JOIN tblPhongChieu pc ON sc.MaPhong = pc.MaPhong
                  LEFT JOIN tblKhuyenMai km ON d.MaKM = km.MaKM
                  WHERE d.MaKH = @k
                  ORDER BY d.NgayDat DESC", "@k", Session["MaKH"]);
            gvDon.DataBind();
        }

        protected void gvDon_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "HuyDon") return;
            string maDon = (string)e.CommandArgument;

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                int n = Db.Cmd(cn, tr,
                    "UPDATE d SET TrangThaiDon = N'Đã hủy' FROM tblDonDatVe d WHERE d.MaDon = @d AND d.MaKH = @k AND " + DieuKienHuy,
                    "@d", maDon, "@k", Session["MaKH"]).ExecuteNonQuery();
                if (n == 0)
                {
                    tr.Rollback();
                    Bao("Đơn không đủ điều kiện hủy.", false);
                    NapDuLieu();
                    return;
                }
                Db.Cmd(cn, tr, "UPDATE tblVe SET TrangThaiVe = N'Đã hủy' WHERE MaDon = @d", "@d", maDon).ExecuteNonQuery();

                string maTT = null;
                DataTable tt = Db.Query(cn, tr,
                    @"SELECT TOP 1 PhuongThuc, SoTien FROM tblThanhToan
                      WHERE MaDon = @d AND LoaiGiaoDich = N'Thanh toán' AND TrangThai = N'Thành công'", "@d", maDon);
                if (tt.Rows.Count == 1)
                {
                    maTT = Db.NextId(cn, tr, "TT", "tblThanhToan", "MaTT");
                    Db.Cmd(cn, tr,
                        @"INSERT INTO tblThanhToan (MaTT, MaDon, PhuongThuc, LoaiGiaoDich, SoTien, TrangThai)
                          VALUES (@t, @d, @pt, N'Hoàn tiền', @tien, N'Đang xử lý')",
                        "@t", maTT, "@d", maDon, "@pt", tt.Rows[0]["PhuongThuc"], "@tien", tt.Rows[0]["SoTien"]).ExecuteNonQuery();
                }
                tr.Commit();

                if (maTT != null)
                    Db.Execute("UPDATE tblThanhToan SET TrangThai = N'Thành công', MaGiaoDichCong = @gd, ThoiDiem = GETDATE() WHERE MaTT = @t",
                               "@gd", "GD" + DateTime.Now.ToString("yyyyMMddHHmmss"), "@t", maTT);
            }
            Bao("Đã hủy đơn " + maDon + " và tạo giao dịch hoàn tiền.", true);
            NapDuLieu();
        }

        private void Bao(string s, bool ok) { lblThongBao.Text = s; lblThongBao.CssClass = ok ? "ok" : "loi"; }
    }
}
