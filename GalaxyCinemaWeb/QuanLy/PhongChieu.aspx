<%@ Page Title="Phòng chiếu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PhongChieu.aspx.cs" Inherits="GalaxyCinemaWeb.QuanLy.PhongChieu" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Thêm phòng chiếu và sơ đồ ghế</h2>
        <div class="form-inline">
            <div class="form-row"><label>Tên phòng</label><asp:TextBox ID="txtTenPhong" runat="server" /></div>
            <div class="form-row"><label>Loại phòng</label>
                <asp:DropDownList ID="ddlLoaiPhong" runat="server"><asp:ListItem>2D</asp:ListItem><asp:ListItem>3D</asp:ListItem><asp:ListItem>IMAX</asp:ListItem></asp:DropDownList></div>
            <div class="form-row"><label>Số hàng ghế (1-15)</label><asp:TextBox ID="txtSoHang" runat="server" TextMode="Number" Text="3" /></div>
            <div class="form-row"><label>Số ghế mỗi hàng (1-20)</label><asp:TextBox ID="txtSoGhe" runat="server" TextMode="Number" Text="6" /></div>
            <div class="form-row"><label>Số hàng VIP (tính từ cuối)</label><asp:TextBox ID="txtHangVip" runat="server" TextMode="Number" Text="1" /></div>
        </div>
        <asp:Button ID="btnThem" runat="server" Text="Thêm phòng" OnClick="btnThem_Click" />
        <p><asp:Label ID="lblThongBao" runat="server" /></p>
    </div>
    <div class="box">
        <h2>Danh sách phòng chiếu</h2>
        <asp:GridView ID="gvPhong" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None">
            <Columns>
                <asp:BoundField DataField="MaPhong" HeaderText="Mã phòng" />
                <asp:BoundField DataField="TenPhong" HeaderText="Tên phòng" />
                <asp:BoundField DataField="LoaiPhong" HeaderText="Loại" />
                <asp:BoundField DataField="SoGheThuong" HeaderText="Ghế thường" />
                <asp:BoundField DataField="SoGheVip" HeaderText="Ghế VIP" />
                <asp:BoundField DataField="SoSuat" HeaderText="Số suất chiếu" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
