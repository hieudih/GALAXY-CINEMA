using System.Web;
using System.Web.UI;

namespace GalaxyCinemaWeb
{
    public static class Auth
    {
        public static void YeuCau(Page page, string vaiTro)
        {
            if ((string)page.Session["VaiTro"] != vaiTro)
                page.Response.Redirect("~/DangNhap.aspx?ReturnUrl=" + HttpUtility.UrlEncode(page.Request.RawUrl), true);
        }
    }
}
