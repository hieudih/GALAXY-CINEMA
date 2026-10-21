using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace GalaxyCinemaWeb
{
    public partial class DangKy : System.Web.UI.Page
    {
        protected void btnDangKy_Click(object sender, EventArgs e)
        {
            string hoTen = txtHoTen.Text.Trim(), email = txtEmail.Text.Trim(), sdt = txtSdt.Text.Trim(), mk = txtMatKhau.Text;
            string loi = null;
            if (hoTen == "" || email == "" || sdt == "" || mk == "") loi = "Vui lòng nhập đầy đủ thông tin.";
            else if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$")) loi = "Email không đúng định dạng.";
            else if (!Regex.IsMatch(sdt, @"^0\d{9}$")) loi = "Số điện thoại phải gồm 10 chữ số, bắt đầu bằng 0.";
            else if (!Regex.IsMatch(mk, @"^\d{6}$")) loi = "Mật khẩu phải gồm đúng 6 chữ số.";
            else if (mk != txtNhapLai.Text) loi = "Mật khẩu nhập lại không khớp.";
            else if (Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM tblKhachHang WHERE Email = @e", "@e", email)) > 0) loi = "Email này đã được đăng ký.";
            if (loi != null) { Bao(loi, false); return; }

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                string ma = Db.NextId(cn, tr, "KH", "tblKhachHang", "MaKH");
                Db.Cmd(cn, tr, "INSERT INTO tblKhachHang (MaKH, HoTen, Email, SoDienThoai, MatKhau) VALUES (@m, @h, @e, @s, @k)",
                       "@m", ma, "@h", hoTen, "@e", email, "@s", sdt, "@k", mk).ExecuteNonQuery();
                tr.Commit();
            }
            Bao("Đăng ký thành công. Bạn có thể đăng nhập ngay.", true);
        }

        private void Bao(string s, bool ok) { lblThongBao.Text = s; lblThongBao.CssClass = ok ? "ok" : "loi"; }
    }
}
