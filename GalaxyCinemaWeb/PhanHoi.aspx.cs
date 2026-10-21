using System;
using System.Data.SqlClient;

namespace GalaxyCinemaWeb
{
    public partial class PhanHoi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "KhachHang");
            if (!IsPostBack) NapDuLieu();
        }

        private void NapDuLieu()
        {
            gvPhanHoi.DataSource = Db.Query("SELECT ThoiDiemGui, NoiDung FROM tblPhanHoi WHERE MaKH = @k ORDER BY ThoiDiemGui DESC",
                                            "@k", Session["MaKH"]);
            gvPhanHoi.DataBind();
        }

        protected void btnGui_Click(object sender, EventArgs e)
        {
            string nd = txtNoiDung.Text.Trim();
            if (nd == "") { Bao("Vui lòng nhập nội dung phản hồi.", false); return; }
            if (nd.Length > 1000) nd = nd.Substring(0, 1000);
            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                string ma = Db.NextId(cn, tr, "PH", "tblPhanHoi", "MaPhanHoi");
                Db.Cmd(cn, tr, "INSERT INTO tblPhanHoi (MaPhanHoi, MaKH, NoiDung) VALUES (@m, @k, @n)",
                       "@m", ma, "@k", Session["MaKH"], "@n", nd).ExecuteNonQuery();
                tr.Commit();
            }
            txtNoiDung.Text = "";
            Bao("Cảm ơn bạn đã gửi phản hồi.", true);
            NapDuLieu();
        }

        private void Bao(string s, bool ok) { lblThongBao.Text = s; lblThongBao.CssClass = ok ? "ok" : "loi"; }
    }
}
