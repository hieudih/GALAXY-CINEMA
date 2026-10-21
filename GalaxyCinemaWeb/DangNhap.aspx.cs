using System;
using System.Configuration;
using System.Data;

namespace GalaxyCinemaWeb
{
    public partial class DangNhap : System.Web.UI.Page
    {
        protected void btnDangNhap_Click(object sender, EventArgs e)
        {
            string ten = txtTen.Text.Trim(), mk = txtMatKhau.Text;
            if (ten == "" || mk == "") { lblThongBao.Text = "Vui lòng nhập đầy đủ thông tin."; return; }

            var cfg = ConfigurationManager.AppSettings;
            if (ten == cfg["QuanLy.TenDangNhap"] && mk == cfg["QuanLy.MatKhau"]) { VaoHeThong("QuanLy", null, null, "~/QuanLy/TongQuan.aspx"); return; }
            if (ten == cfg["SoatVe.TenDangNhap"] && mk == cfg["SoatVe.MatKhau"]) { VaoHeThong("SoatVe", null, "Soát vé", "~/SoatVe.aspx"); return; }

            DataTable dt = Db.Query("SELECT MaKH, HoTen FROM tblKhachHang WHERE Email = @e AND MatKhau = @m", "@e", ten, "@m", mk);
            if (dt.Rows.Count == 1)
            {
                string url = Request.QueryString["ReturnUrl"];
                if (url == null || !url.StartsWith("/") || url.StartsWith("//")) url = "~/Default.aspx";
                VaoHeThong("KhachHang", (string)dt.Rows[0]["MaKH"], (string)dt.Rows[0]["HoTen"], url);
                return;
            }
            lblThongBao.Text = "Sai tên đăng nhập hoặc mật khẩu.";
        }

        private void VaoHeThong(string vaiTro, string maKH, string hoTen, string url)
        {
            Session["VaiTro"] = vaiTro;
            Session["MaKH"] = maKH;
            Session["HoTen"] = hoTen;
            Response.Redirect(url, false);
        }
    }
}
