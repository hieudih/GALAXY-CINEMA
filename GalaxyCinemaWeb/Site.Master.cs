using System;
using System.Text;
using System.Web;

namespace GalaxyCinemaWeb
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string vaiTro = Session["VaiTro"] as string;
            var sb = new StringBuilder();
            if (vaiTro == "QuanLy")
            {
                Link(sb, "~/QuanLy/TongQuan.aspx", "Tổng quan");
                Link(sb, "~/QuanLy/Phim.aspx", "Phim");
                Link(sb, "~/QuanLy/PhongChieu.aspx", "Phòng chiếu");
                Link(sb, "~/QuanLy/SuatChieu.aspx", "Lịch chiếu");
                Link(sb, "~/QuanLy/GiaKhuyenMai.aspx", "Giá vé & khuyến mãi");
                Link(sb, "~/QuanLy/BaoCao.aspx", "Báo cáo & phản hồi");
                Link(sb, "~/DangXuat.aspx", "Đăng xuất (quản lý)");
            }
            else if (vaiTro == "SoatVe")
            {
                Link(sb, "~/SoatVe.aspx", "Soát vé");
                Link(sb, "~/DangXuat.aspx", "Đăng xuất (soát vé)");
            }
            else
            {
                Link(sb, "~/Default.aspx", "Phim");
                if (vaiTro == "KhachHang")
                {
                    Link(sb, "~/VeCuaToi.aspx", "Vé của tôi");
                    Link(sb, "~/PhanHoi.aspx", "Phản hồi");
                    Link(sb, "~/TaiKhoan.aspx", "Tài khoản");
                    Link(sb, "~/DangXuat.aspx", "Đăng xuất (" + Session["HoTen"] + ")");
                }
                else
                {
                    Link(sb, "~/DangNhap.aspx", "Đăng nhập");
                    Link(sb, "~/DangKy.aspx", "Đăng ký");
                }
            }
            litMenu.Text = sb.ToString();
        }

        private void Link(StringBuilder sb, string url, string text)
        {
            sb.AppendFormat("<a href=\"{0}\">{1}</a>", ResolveUrl(url), HttpUtility.HtmlEncode(text));
        }
    }
}
