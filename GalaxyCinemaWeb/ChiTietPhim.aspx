<%@ Page Title="Chọn suất chiếu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChiTietPhim.aspx.cs" Inherits="GalaxyCinemaWeb.ChiTietPhim" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2><asp:Literal ID="litTenPhim" runat="server" /></h2>
        <p><asp:Literal ID="litThongTin" runat="server" /></p>
    </div>
    <div class="box">
        <h2>Suất chiếu</h2>
        <asp:GridView ID="gvSuat" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None"
            EmptyDataText="Hiện chưa có suất chiếu nào cho phim này.">
            <Columns>
                <asp:BoundField DataField="NgayChieu" HeaderText="Ngày chiếu" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="GioBatDau" HeaderText="Giờ" DataFormatString="{0:hh\:mm}" />
                <asp:BoundField DataField="TenPhong" HeaderText="Phòng" />
                <asp:BoundField DataField="LoaiPhong" HeaderText="Loại phòng" />
                <asp:BoundField DataField="GheTrong" HeaderText="Ghế trống" />
                <asp:HyperLinkField Text="Chọn ghế" DataNavigateUrlFields="MaSuat" DataNavigateUrlFormatString="ChonGhe.aspx?MaSuat={0}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
