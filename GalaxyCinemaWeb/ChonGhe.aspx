<%@ Page Title="Chọn ghế" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChonGhe.aspx.cs" Inherits="GalaxyCinemaWeb.ChonGhe" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2><asp:Literal ID="litTenPhim" runat="server" /></h2>
        <p><asp:Literal ID="litThongTinSuat" runat="server" /></p>
        <div class="man-hinh">MÀN HÌNH</div>
        <asp:Literal ID="litSoDoGhe" runat="server" />
        <p class="chu-thich"><span></span>Thường <span style="background:#fff4d6;border-color:#c79100"></span>VIP <span style="background:#bbb"></span>Đã có người đặt</p>
        <div class="form-row"><label>Khuyến mãi</label><asp:DropDownList ID="ddlKhuyenMai" runat="server" /></div>
        <asp:Button ID="btnDatVe" runat="server" Text="Đặt vé" OnClick="btnDatVe_Click" />
        <p><asp:Label ID="lblThongBao" runat="server" CssClass="loi" /></p>
    </div>
</asp:Content>
