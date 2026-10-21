using System;

namespace GalaxyCinemaWeb
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            rptDangChieu.DataSource = Db.Query(
                "SELECT * FROM tblPhim WHERE NgayKhoiChieu <= CAST(GETDATE() AS DATE) ORDER BY NgayKhoiChieu DESC");
            rptDangChieu.DataBind();
            rptSapChieu.DataSource = Db.Query(
                "SELECT * FROM tblPhim WHERE NgayKhoiChieu > CAST(GETDATE() AS DATE) ORDER BY NgayKhoiChieu");
            rptSapChieu.DataBind();
        }
    }
}
