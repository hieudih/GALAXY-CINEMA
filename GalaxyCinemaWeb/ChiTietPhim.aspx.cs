using System;
using System.Data;
using System.Web;

namespace GalaxyCinemaWeb
{
    public partial class ChiTietPhim : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            string maPhim = Request.QueryString["MaPhim"];
            DataTable phim = Db.Query("SELECT * FROM tblPhim WHERE MaPhim = @p", "@p", maPhim);
            if (phim.Rows.Count == 0) { Response.Redirect("~/Default.aspx"); return; }
            DataRow r = phim.Rows[0];
            litTenPhim.Text = HttpUtility.HtmlEncode((string)r["TenPhim"]);
            litThongTin.Text = HttpUtility.HtmlEncode(string.Format("{0} | {1} phút | {2} | Khởi chiếu {3:dd/MM/yyyy}",
                r["TheLoaiChinh"], r["ThoiLuong"], r["DoTuoiChoPhep"], r["NgayKhoiChieu"]));

            gvSuat.DataSource = Db.Query(
                @"SELECT sc.MaSuat, sc.NgayChieu, sc.GioBatDau, pc.TenPhong, pc.LoaiPhong,
                         (SELECT COUNT(*) FROM tblGhe g WHERE g.MaPhong = sc.MaPhong)
                       - (SELECT COUNT(*) FROM tblVe v WHERE v.MaSuat = sc.MaSuat AND v.TrangThaiVe <> N'Đã hủy') AS GheTrong
                  FROM tblSuatChieu sc JOIN tblPhongChieu pc ON sc.MaPhong = pc.MaPhong
                  WHERE sc.MaPhim = @p
                    AND CAST(sc.NgayChieu AS DATETIME) + CAST(sc.GioBatDau AS DATETIME) > GETDATE()
                  ORDER BY sc.NgayChieu, sc.GioBatDau", "@p", maPhim);
            gvSuat.DataBind();
        }
    }
}
