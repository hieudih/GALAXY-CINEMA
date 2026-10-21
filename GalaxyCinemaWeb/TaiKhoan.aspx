<%@ Page Title="Tài khoản của tôi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TaiKhoan.aspx.cs" Inherits="GalaxyCinemaWeb.TaiKhoan" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Thông tin tài khoản</h2>
        <p>Mã khách hàng: <b><asp:Literal ID="litMaKH" runat="server" /></b></p>
        <p>Email đăng nhập: <b><asp:Literal ID="litEmail" runat="server" /></b></p>
        <p>Ngày đăng ký: <asp:Literal ID="litNgayDK" runat="server" /></p>
        <div class="form-row"><label>Họ tên</label><asp:TextBox ID="txtHoTen" runat="server" MaxLength="100" /></div>
        <div class="form-row"><label>Số điện thoại</label><asp:TextBox ID="txtSdt" runat="server" MaxLength="10" /></div>
        <asp:Button ID="btnLuu" runat="server" Text="Lưu thông tin" OnClick="btnLuu_Click" />
        <p><asp:Label ID="lblThongTin" runat="server" /></p>
    </div>
    <div class="box">
        <h2>Đổi mật khẩu</h2>
        <div class="form-row"><label>Mật khẩu hiện tại</label><asp:TextBox ID="txtMkCu" runat="server" TextMode="Password" /></div>
        <div class="form-row"><label>Mật khẩu mới (6 chữ số)</label><asp:TextBox ID="txtMkMoi" runat="server" TextMode="Password" /></div>
        <div class="form-row"><label>Nhập lại mật khẩu mới</label><asp:TextBox ID="txtNhapLai" runat="server" TextMode="Password" /></div>
        <asp:Button ID="btnDoiMk" runat="server" Text="Đổi mật khẩu" CssClass="phu" OnClick="btnDoiMk_Click" />
        <p><asp:Label ID="lblMatKhau" runat="server" /></p>
    </div>
</asp:Content>
