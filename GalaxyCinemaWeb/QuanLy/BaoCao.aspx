<%@ Page Title="Báo cáo và phản hồi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BaoCao.aspx.cs" Inherits="GalaxyCinemaWeb.QuanLy.BaoCao" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Thống kê báo cáo</h2>
        <div class="form-inline">
            <div class="form-row"><label>Từ ngày</label><asp:TextBox ID="txtTu" runat="server" TextMode="Date" /></div>
            <div class="form-row"><label>Đến ngày</label><asp:TextBox ID="txtDen" runat="server" TextMode="Date" /></div>
            <asp:Button ID="btnXem" runat="server" Text="Xem báo cáo" OnClick="btnXem_Click" />
        </div>
        <p><asp:Label ID="lblThongBao" runat="server" CssClass="loi" /></p>
        <div class="so-lieu">
            <div><b><asp:Literal ID="litThu" runat="server" /></b><span>Tiền thu (đ)</span></div>
            <div><b><asp:Literal ID="litHoan" runat="server" /></b><span>Tiền hoàn (đ)</span></div>
            <div><b><asp:Literal ID="litThucThu" runat="server" /></b><span>Doanh thu thực thu (đ)</span></div>
            <div><b><asp:Literal ID="litSoVe" runat="server" /></b><span>Vé đã bán</span></div>
        </div>
        <h3>Doanh thu theo phim</h3>
        <asp:GridView ID="gvPhim" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None" EmptyDataText="Không có dữ liệu.">
            <Columns>
                <asp:BoundField DataField="TenPhim" HeaderText="Phim" />
                <asp:BoundField DataField="SoSuat" HeaderText="Số suất" />
                <asp:BoundField DataField="SoVe" HeaderText="Số vé" />
                <asp:BoundField DataField="TienVe" HeaderText="Tiền vé (đ)" DataFormatString="{0:N0}" />
            </Columns>
        </asp:GridView>
        <h3>Số vé bán theo suất chiếu</h3>
        <asp:GridView ID="gvSuat" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None" EmptyDataText="Không có dữ liệu.">
            <Columns>
                <asp:BoundField DataField="MaSuat" HeaderText="Mã suất" />
                <asp:BoundField DataField="TenPhim" HeaderText="Phim" />
                <asp:BoundField DataField="NgayChieu" HeaderText="Ngày" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="GioBatDau" HeaderText="Giờ" DataFormatString="{0:hh\:mm}" />
                <asp:BoundField DataField="TenPhong" HeaderText="Phòng" />
                <asp:BoundField DataField="SoVe" HeaderText="Vé đã bán" />
                <asp:BoundField DataField="TongGhe" HeaderText="Tổng ghế" />
            </Columns>
        </asp:GridView>
    </div>
    <div class="box">
        <h2>Phản hồi của khách hàng</h2>
        <asp:GridView ID="gvPhanHoi" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None" EmptyDataText="Chưa có phản hồi.">
            <Columns>
                <asp:BoundField DataField="ThoiDiemGui" HeaderText="Thời điểm" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" />
                <asp:BoundField DataField="NoiDung" HeaderText="Nội dung" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
