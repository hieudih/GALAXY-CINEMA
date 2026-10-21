<%@ Page Title="Đăng ký" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DangKy.aspx.cs" Inherits="GalaxyCinemaWeb.DangKy" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box" style="max-width:440px">
        <h2>Đăng ký tài khoản</h2>
        <div class="form-row"><label>Họ tên</label><asp:TextBox ID="txtHoTen" runat="server" /></div>
        <div class="form-row"><label>Email</label><asp:TextBox ID="txtEmail" runat="server" TextMode="Email" /></div>
        <div class="form-row"><label>Số điện thoại</label><asp:TextBox ID="txtSdt" runat="server" /></div>
        <div class="form-row"><label>Mật khẩu (6 chữ số)</label><asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" /></div>
        <div class="form-row"><label>Nhập lại mật khẩu</label><asp:TextBox ID="txtNhapLai" runat="server" TextMode="Password" /></div>
        <asp:Button ID="btnDangKy" runat="server" Text="Đăng ký" OnClick="btnDangKy_Click" />
        <p><asp:Label ID="lblThongBao" runat="server" /></p>
    </div>
</asp:Content>
