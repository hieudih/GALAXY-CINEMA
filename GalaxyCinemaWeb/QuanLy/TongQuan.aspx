<%@ Page Title="Tổng quan" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TongQuan.aspx.cs" Inherits="GalaxyCinemaWeb.QuanLy.TongQuan" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Tổng quan tháng <asp:Literal ID="litThang" runat="server" /></h2>
    <div class="so-lieu">
        <div><b><asp:Literal ID="litSoVe" runat="server" /></b><span>Vé đã bán</span></div>
        <div><b><asp:Literal ID="litDoanhThu" runat="server" /></b><span>Doanh thu thực thu (đ)</span></div>
        <div><b><asp:Literal ID="litKhach" runat="server" /></b><span>Khách hàng</span></div>
        <div><b><asp:Literal ID="litSuatHomNay" runat="server" /></b><span>Suất chiếu hôm nay</span></div>
    </div>
    <div class="box">
        <h2>Phim bán chạy trong tháng</h2>
        <asp:GridView ID="gvTopPhim" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None" EmptyDataText="Chưa có vé nào trong tháng.">
            <Columns>
                <asp:BoundField DataField="TenPhim" HeaderText="Phim" />
                <asp:BoundField DataField="SoVe" HeaderText="Số vé" />
                <asp:BoundField DataField="DoanhThuVe" HeaderText="Tiền vé (đ)" DataFormatString="{0:N0}" />
            </Columns>
        </asp:GridView>
    </div>
    <div class="box">
        <h2>Đơn đặt vé gần đây</h2>
        <asp:GridView ID="gvDonMoi" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None">
            <Columns>
                <asp:BoundField DataField="MaDon" HeaderText="Mã đơn" />
                <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" />
                <asp:BoundField DataField="NgayDat" HeaderText="Thời điểm đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="SoVe" HeaderText="Số vé" />
                <asp:BoundField DataField="TrangThaiDon" HeaderText="Trạng thái" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
