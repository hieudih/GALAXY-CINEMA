using System;
using System.Data;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace GalaxyCinemaWeb
{
    public partial class TaiKhoan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "KhachHang");
            if (!IsPostBack) NapDuLieu();
        }

        private void NapDuLieu()
        {
            DataTable dt = Db.Query("SELECT MaKH, HoTen, Email, SoDienThoai, NgayDangKy FROM tblKhachHang WHERE MaKH = @k",
                                    "@k", Session["MaKH"]);
            if (dt.Rows.Count == 0) { Response.Redirect("~/DangXuat.aspx"); return; }
            DataRow r = dt.Rows[0];
            litMaKH.Text = Server.HtmlEncode((string)r["MaKH"]);
            litEmail.Text = Server.HtmlEncode((string)r["Email"]);
            litNgayDK.Text = ((DateTime)r["NgayDangKy"]).ToString("dd/MM/yyyy");
            txtHoTen.Text = (string)r["HoTen"];
            txtSdt.Text = (string)r["SoDienThoai"];
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            string hoTen = txtHoTen.Text.Trim(), sdt = txtSdt.Text.Trim();
            if (hoTen == "") { Bao(lblThongTin, "Vui lòng nhập họ tên.", false); return; }
            if (!Regex.IsMatch(sdt, @"^0\d{9}$")) { Bao(lblThongTin, "Số điện thoại phải gồm 10 chữ số, bắt đầu bằng 0.", false); return; }

            Db.Execute("UPDATE tblKhachHang SET HoTen = @h, SoDienThoai = @s WHERE MaKH = @k",
                       "@h", hoTen, "@s", sdt, "@k", Session["MaKH"]);
            Session["HoTen"] = hoTen;
            Bao(lblThongTin, "Đã lưu thông tin tài khoản.", true);
        }

        protected void btnDoiMk_Click(object sender, EventArgs e)
        {
            string cu = txtMkCu.Text, moi = txtMkMoi.Text, lai = txtNhapLai.Text;
            if (!Regex.IsMatch(moi, @"^\d{6}$")) { Bao(lblMatKhau, "Mật khẩu mới phải gồm đúng 6 chữ số.", false); return; }
            if (moi != lai) { Bao(lblMatKhau, "Nhập lại mật khẩu mới không khớp.", false); return; }

            int n = Db.Execute("UPDATE tblKhachHang SET MatKhau = @moi WHERE MaKH = @k AND MatKhau = @cu",
                               "@moi", moi, "@k", Session["MaKH"], "@cu", cu);
            if (n == 0) { Bao(lblMatKhau, "Mật khẩu hiện tại không đúng.", false); return; }
            Bao(lblMatKhau, "Đã đổi mật khẩu.", true);
        }

        private void Bao(Label lbl, string s, bool ok) { lbl.Text = s; lbl.CssClass = ok ? "ok" : "loi"; }
    }
}
