<%@ Page Title="Thanh toán" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ThanhToan.aspx.cs" Inherits="GalaxyCinemaWeb.ThanhToan" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Xác nhận đơn <asp:Literal ID="litMaDon" runat="server" /></h2>
        <asp:GridView ID="gvVe" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None">
            <Columns>
                <asp:BoundField DataField="MaVe" HeaderText="Mã vé" />
                <asp:BoundField DataField="TenPhim" HeaderText="Phim" />
                <asp:BoundField DataField="NgayChieu" HeaderText="Ngày chiếu" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="GioBatDau" HeaderText="Giờ" DataFormatString="{0:hh\:mm}" />
                <asp:BoundField DataField="Ghe" HeaderText="Ghế" />
                <asp:BoundField DataField="LoaiGhe" HeaderText="Loại ghế" />
                <asp:BoundField DataField="GiaVe" HeaderText="Giá vé (đ)" DataFormatString="{0:N0}" />
            </Columns>
        </asp:GridView>
        <p>Tiền vé: <asp:Literal ID="litTienVe" runat="server" /> đ<br />
           Giảm giá: <asp:Literal ID="litGiam" runat="server" /> đ<br />
           <b>Tổng tiền: <asp:Literal ID="litTong" runat="server" /> đ</b></p>
        <div class="form-row"><label>Phương thức thanh toán</label>
            <asp:DropDownList ID="ddlPhuongThuc" runat="server">
                <asp:ListItem>Ví điện tử</asp:ListItem>
                <asp:ListItem>Thẻ ngân hàng</asp:ListItem>
            </asp:DropDownList></div>
        <div class="form-row"><label>Kết quả trả về từ cổng thanh toán (mô phỏng)</label>
            <asp:DropDownList ID="ddlKetQua" runat="server">
                <asp:ListItem Value="OK">Thành công</asp:ListItem>
                <asp:ListItem Value="FAIL">Thất bại</asp:ListItem>
            </asp:DropDownList></div>
        <asp:Button ID="btnThanhToan" runat="server" Text="Thanh toán" OnClick="btnThanhToan_Click" />
        <p><i>Ghế được giữ trong 8 phút kể từ khi đặt.</i></p>
        <p><asp:Label ID="lblThongBao" runat="server" CssClass="loi" /></p>
    </div>
</asp:Content>
