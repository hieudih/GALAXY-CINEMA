<%@ Page Title="Đăng nhập" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DangNhap.aspx.cs" Inherits="GalaxyCinemaWeb.DangNhap" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box" style="max-width:440px">
        <h2>Đăng nhập</h2>
        <asp:Panel runat="server" DefaultButton="btnDangNhap">
            <div class="form-row"><label>Email (khách hàng) hoặc tên đăng nhập (nhân viên)</label>
                <asp:TextBox ID="txtTen" runat="server" /></div>
            <div class="form-row"><label>Mật khẩu</label>
                <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" /></div>
            <asp:Button ID="btnDangNhap" runat="server" Text="Đăng nhập" OnClick="btnDangNhap_Click" />
        </asp:Panel>
        <p><asp:Label ID="lblThongBao" runat="server" CssClass="loi" /></p>
        <p>Chưa có tài khoản? <a href="DangKy.aspx">Đăng ký</a></p>
    </div>
</asp:Content>
