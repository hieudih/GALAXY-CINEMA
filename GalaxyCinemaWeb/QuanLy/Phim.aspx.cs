using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace GalaxyCinemaWeb.QuanLy
{
    public partial class Phim : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "QuanLy");
            if (!IsPostBack) NapDuLieu();
        }

        private void NapDuLieu()
        {
            gvPhim.DataSource = Db.Query(
                @"SELECT p.*, (SELECT COUNT(*) FROM tblSuatChieu s WHERE s.MaPhim = p.MaPhim) AS SoSuat
                  FROM tblPhim p ORDER BY p.NgayKhoiChieu DESC");
            gvPhim.DataBind();
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            string ten = txtTenPhim.Text.Trim(), theLoai = txtTheLoai.Text.Trim();
            int thoiLuong;
            DateTime? khoiChieu = Db.DocNgay(txtKhoiChieu.Text);
            if (ten == "" || theLoai == "") { Bao("Vui lòng nhập tên phim và thể loại.", false); return; }
            if (!int.TryParse(txtThoiLuong.Text, out thoiLuong) || thoiLuong <= 0) { Bao("Thời lượng phải là số nguyên dương.", false); return; }
            if (khoiChieu == null) { Bao("Vui lòng chọn ngày khởi chiếu.", false); return; }

            if (hfMaPhim.Value == "")
            {
                using (SqlConnection cn = Db.Open())
                using (SqlTransaction tr = cn.BeginTransaction())
                {
                    string ma = Db.NextId(cn, tr, "P", "tblPhim", "MaPhim");
                    Db.Cmd(cn, tr, @"INSERT INTO tblPhim (MaPhim, TenPhim, TheLoaiChinh, ThoiLuong, DoTuoiChoPhep, NgayKhoiChieu)
                                     VALUES (@m, @t, @l, @tl, @dt, @kc)",
                           "@m", ma, "@t", ten, "@l", theLoai, "@tl", thoiLuong, "@dt", ddlDoTuoi.SelectedValue, "@kc", khoiChieu.Value).ExecuteNonQuery();
                    tr.Commit();
                    Bao("Đã thêm phim " + ma + ".", true);
                }
            }
            else
            {
                Db.Execute(@"UPDATE tblPhim SET TenPhim = @t, TheLoaiChinh = @l, ThoiLuong = @tl, DoTuoiChoPhep = @dt, NgayKhoiChieu = @kc
                             WHERE MaPhim = @m",
                           "@m", hfMaPhim.Value, "@t", ten, "@l", theLoai, "@tl", thoiLuong, "@dt", ddlDoTuoi.SelectedValue, "@kc", khoiChieu.Value);
                Bao("Đã cập nhật phim " + hfMaPhim.Value + ".", true);
            }
            XoaForm();
            NapDuLieu();
        }

        protected void btnMoi_Click(object sender, EventArgs e) { XoaForm(); lblThongBao.Text = ""; }

        protected void gvPhim_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string ma = (string)e.CommandArgument;
            if (e.CommandName == "Sua")
            {
                DataRow r = Db.Query("SELECT * FROM tblPhim WHERE MaPhim = @m", "@m", ma).Rows[0];
                hfMaPhim.Value = ma;
                txtTenPhim.Text = (string)r["TenPhim"];
                txtTheLoai.Text = (string)r["TheLoaiChinh"];
                txtThoiLuong.Text = r["ThoiLuong"].ToString();
                ddlDoTuoi.SelectedValue = (string)r["DoTuoiChoPhep"];
                txtKhoiChieu.Text = ((DateTime)r["NgayKhoiChieu"]).ToString("yyyy-MM-dd");
                litTieuDe.Text = "Sửa phim " + ma;
                btnLuu.Text = "Lưu thay đổi";
            }
            else if (e.CommandName == "Xoa")
            {
                try
                {
                    Db.Execute("DELETE FROM tblPhim WHERE MaPhim = @m", "@m", ma);
                    Bao("Đã xóa phim " + ma + ".", true);
                }
                catch (SqlException ex) when (ex.Number == 547)
                {
                    Bao("Không thể xóa: phim đã có suất chiếu.", false);
                }
                NapDuLieu();
            }
        }

        private void XoaForm()
        {
            hfMaPhim.Value = ""; txtTenPhim.Text = ""; txtTheLoai.Text = ""; txtThoiLuong.Text = ""; txtKhoiChieu.Text = "";
            ddlDoTuoi.SelectedIndex = 0; litTieuDe.Text = "Thêm phim mới"; btnLuu.Text = "Thêm phim";
        }

        private void Bao(string s, bool ok) { lblThongBao.Text = s; lblThongBao.CssClass = ok ? "ok" : "loi"; }
    }
}
