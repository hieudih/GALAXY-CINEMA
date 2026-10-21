<%@ Page Title="Soát vé" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SoatVe.aspx.cs" Inherits="GalaxyCinemaWeb.SoatVe" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box" style="max-width:560px">
        <h2>Soát vé tại cửa phòng chiếu</h2>
        <asp:Panel runat="server" DefaultButton="btnSoat" CssClass="form-inline">
            <div class="form-row"><label>Mã vé</label><asp:TextBox ID="txtMaVe" runat="server" /></div>
            <asp:Button ID="btnSoat" runat="server" Text="Kiểm tra" OnClick="btnSoat_Click" />
        </asp:Panel>
        <h3><asp:Label ID="lblKetQua" runat="server" /></h3>
        <p><asp:Literal ID="litChiTiet" runat="server" /></p>
    </div>
</asp:Content>
