using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace GalaxyCinemaWeb.QuanLy
{
    public partial class GiaKhuyenMai : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "QuanLy");
            if (!IsPostBack) NapDuLieu();
        }

        private void NapDuLieu()
        {
            gvGia.DataSource = Db.Query("SELECT * FROM tblBangGia ORDER BY NgayApDung DESC, LoaiNgay, LoaiGhe");
            gvGia.DataBind();
            gvKM.DataSource = Db.Query(
                @"SELECT km.*, (SELECT COUNT(*) FROM tblDonDatVe d WHERE d.MaKM = km.MaKM) AS SoDon
                  FROM tblKhuyenMai km ORDER BY km.NgayBatDau DESC");
            gvKM.DataBind();
        }

        protected void btnThemGia_Click(object sender, EventArgs e)
        {
            decimal gia;
            DateTime? ngay = Db.DocNgay(txtNgayApDung.Text);
            if (!decimal.TryParse(txtGiaVe.Text, out gia) || gia <= 0) { Bao(lblGia, "Giá vé phải là số dương.", false); return; }
            if (ngay == null) { Bao(lblGia, "Vui lòng chọn ngày áp dụng.", false); return; }
            try
            {
                using (SqlConnection cn = Db.Open())
                using (SqlTransaction tr = cn.BeginTransaction())
                {
                    string ma = Db.NextId(cn, tr, "BG", "tblBangGia", "MaGia", 2);
                    Db.Cmd(cn, tr, "INSERT INTO tblBangGia (MaGia, LoaiGhe, LoaiNgay, GiaVe, NgayApDung) VALUES (@m, @g, @n, @v, @a)",
                           "@m", ma, "@g", ddlLoaiGhe.SelectedValue, "@n", ddlLoaiNgay.SelectedValue, "@v", gia, "@a", ngay.Value).ExecuteNonQuery();
                    tr.Commit();
                    Bao(lblGia, "Đã thêm mức giá " + ma + ".", true);
                }
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                Bao(lblGia, "Đã có mức giá cho loại ghế, loại ngày này với cùng ngày áp dụng.", false);
            }
            NapDuLieu();
        }

        protected void btnThemKM_Click(object sender, EventArgs e)
        {
            decimal giam;
            DateTime? tu = Db.DocNgay(txtTuNgay.Text), den = Db.DocNgay(txtDenNgay.Text);
            string ten = txtTenKM.Text.Trim(), dk = txtDieuKien.Text.Trim();
            if (ten == "") { Bao(lblKM, "Vui lòng nhập tên chương trình.", false); return; }
            if (!decimal.TryParse(txtMucGiam.Text, out giam) || giam <= 0) { Bao(lblKM, "Mức giảm phải là số dương.", false); return; }
            if (tu == null || den == null || den < tu) { Bao(lblKM, "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.", false); return; }

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                string ma = Db.NextId(cn, tr, "KM", "tblKhuyenMai", "MaKM", 2);
                Db.Cmd(cn, tr, @"INSERT INTO tblKhuyenMai (MaKM, TenKM, MucGiam, NgayBatDau, NgayKetThuc, DieuKienApDung)
                                 VALUES (@m, @t, @g, @a, @b, @d)",
                       "@m", ma, "@t", ten, "@g", giam, "@a", tu.Value, "@b", den.Value, "@d", dk == "" ? null : dk).ExecuteNonQuery();
                tr.Commit();
                Bao(lblKM, "Đã thêm khuyến mãi " + ma + ".", true);
            }
            txtTenKM.Text = txtMucGiam.Text = txtTuNgay.Text = txtDenNgay.Text = txtDieuKien.Text = "";
            NapDuLieu();
        }

        protected void gvKM_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Xoa") return;
            try
            {
                Db.Execute("DELETE FROM tblKhuyenMai WHERE MaKM = @m", "@m", (string)e.CommandArgument);
                Bao(lblKM, "Đã xóa khuyến mãi.", true);
            }
            catch (SqlException ex) when (ex.Number == 547)
            {
                Bao(lblKM, "Không thể xóa: khuyến mãi đã được dùng trong đơn đặt vé.", false);
            }
            NapDuLieu();
        }

        private static void Bao(Label lbl, string s, bool ok) { lbl.Text = s; lbl.CssClass = ok ? "ok" : "loi"; }
    }
}
