<%@ Page Title="Vé của tôi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VeCuaToi.aspx.cs" Inherits="GalaxyCinemaWeb.VeCuaToi" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Vé của tôi</h2>
        <p><asp:Label ID="lblThongBao" runat="server" /></p>
        <asp:GridView ID="gvDon" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None"
            DataKeyNames="MaDon" OnRowCommand="gvDon_RowCommand" EmptyDataText="Bạn chưa có đơn đặt vé nào.">
            <Columns>
                <asp:BoundField DataField="MaDon" HeaderText="Mã đơn" />
                <asp:BoundField DataField="TenPhim" HeaderText="Phim" />
                <asp:BoundField DataField="NgayChieu" HeaderText="Ngày chiếu" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="GioBatDau" HeaderText="Giờ" DataFormatString="{0:hh\:mm}" />
                <asp:BoundField DataField="TenPhong" HeaderText="Phòng" />
                <asp:BoundField DataField="DanhSachVe" HeaderText="Mã vé (ghế)" />
                <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền (đ)" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="TrangThaiDon" HeaderText="Trạng thái" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:HyperLink runat="server" CssClass="btn phu" Text="Thanh toán"
                            NavigateUrl='<%# "ThanhToan.aspx?MaDon=" + Eval("MaDon") %>'
                            Visible='<%# (string)Eval("TrangThaiDon") == "Chờ thanh toán" %>' />
                        <asp:Button runat="server" Text="Hủy đơn" CommandName="HuyDon" CommandArgument='<%# Eval("MaDon") %>'
                            Visible='<%# Convert.ToInt32(Eval("CoTheHuy")) == 1 %>'
                            OnClientClick="return confirm('Hủy toàn bộ vé của đơn này và hoàn tiền?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <p><i>Điều kiện hủy: đơn đã thanh toán, suất chiếu chưa bắt đầu và tất cả vé trong đơn chưa soát. Tiền được hoàn đủ qua phương thức đã thanh toán.</i></p>
    </div>
</asp:Content>
