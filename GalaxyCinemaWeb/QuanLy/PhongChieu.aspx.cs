using System;
using System.Data.SqlClient;

namespace GalaxyCinemaWeb.QuanLy
{
    public partial class PhongChieu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.YeuCau(this, "QuanLy");
            if (!IsPostBack) NapDuLieu();
        }

        private void NapDuLieu()
        {
            gvPhong.DataSource = Db.Query(
                @"SELECT pc.MaPhong, pc.TenPhong, pc.LoaiPhong,
                         (SELECT COUNT(*) FROM tblGhe g WHERE g.MaPhong = pc.MaPhong AND g.LoaiGhe = N'Thường') AS SoGheThuong,
                         (SELECT COUNT(*) FROM tblGhe g WHERE g.MaPhong = pc.MaPhong AND g.LoaiGhe = N'VIP') AS SoGheVip,
                         (SELECT COUNT(*) FROM tblSuatChieu s WHERE s.MaPhong = pc.MaPhong) AS SoSuat
                  FROM tblPhongChieu pc ORDER BY pc.MaPhong");
            gvPhong.DataBind();
        }

        protected void btnThem_Click(object sender, EventArgs e)
        {
            int soHang, soGhe, hangVip;
            string ten = txtTenPhong.Text.Trim();
            if (ten == "") { Bao("Vui lòng nhập tên phòng.", false); return; }
            if (!int.TryParse(txtSoHang.Text, out soHang) || soHang < 1 || soHang > 15 ||
                !int.TryParse(txtSoGhe.Text, out soGhe) || soGhe < 1 || soGhe > 20 ||
                !int.TryParse(txtHangVip.Text, out hangVip) || hangVip < 0 || hangVip > soHang)
            { Bao("Số hàng, số ghế hoặc số hàng VIP không hợp lệ.", false); return; }

            using (SqlConnection cn = Db.Open())
            using (SqlTransaction tr = cn.BeginTransaction())
            {
                string ma = Db.NextId(cn, tr, "PC", "tblPhongChieu", "MaPhong", 2);
                Db.Cmd(cn, tr, "INSERT INTO tblPhongChieu (MaPhong, TenPhong, LoaiPhong) VALUES (@m, @t, @l)",
                       "@m", ma, "@t", ten, "@l", ddlLoaiPhong.SelectedValue).ExecuteNonQuery();
                for (int h = 0; h < soHang; h++)
                {
                    string hang = ((char)('A' + h)).ToString();
                    string loai = h >= soHang - hangVip ? "VIP" : "Thường";
                    for (int s = 1; s <= soGhe; s++)
                        Db.Cmd(cn, tr, "INSERT INTO tblGhe (MaGhe, MaPhong, HangGhe, SoGhe, LoaiGhe) VALUES (@g, @m, @h, @s, @l)",
                               "@g", ma + hang + s, "@m", ma, "@h", hang, "@s", s, "@l", loai).ExecuteNonQuery();
                }
                tr.Commit();
                Bao("Đã thêm phòng " + ma + " với " + (soHang * soGhe) + " ghế.", true);
            }
            txtTenPhong.Text = "";
            NapDuLieu();
        }

        private void Bao(string s, bool ok) { lblThongBao.Text = s; lblThongBao.CssClass = ok ? "ok" : "loi"; }
    }
}
