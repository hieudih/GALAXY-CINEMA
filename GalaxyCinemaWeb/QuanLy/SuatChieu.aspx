<%@ Page Title="Lịch chiếu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SuatChieu.aspx.cs" Inherits="GalaxyCinemaWeb.QuanLy.SuatChieu" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Xếp lịch chiếu</h2>
        <div class="form-inline">
            <div class="form-row"><label>Phim</label><asp:DropDownList ID="ddlPhim" runat="server" /></div>
            <div class="form-row"><label>Phòng</label><asp:DropDownList ID="ddlPhong" runat="server" /></div>
            <div class="form-row"><label>Ngày chiếu</label><asp:TextBox ID="txtNgay" runat="server" TextMode="Date" /></div>
            <div class="form-row"><label>Giờ bắt đầu</label><asp:TextBox ID="txtGio" runat="server" TextMode="Time" /></div>
        </div>
        <asp:Button ID="btnThem" runat="server" Text="Thêm suất chiếu" OnClick="btnThem_Click" />
        <p><asp:Label ID="lblThongBao" runat="server" /></p>
    </div>
    <div class="box">
        <h2>Lịch chiếu từ hôm nay</h2>
        <asp:GridView ID="gvSuat" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None" OnRowCommand="gvSuat_RowCommand"
            EmptyDataText="Chưa có suất chiếu nào.">
            <Columns>
                <asp:BoundField DataField="MaSuat" HeaderText="Mã suất" />
                <asp:BoundField DataField="TenPhim" HeaderText="Phim" />
                <asp:BoundField DataField="TenPhong" HeaderText="Phòng" />
                <asp:BoundField DataField="NgayChieu" HeaderText="Ngày" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="GioBatDau" HeaderText="Bắt đầu" DataFormatString="{0:hh\:mm}" />
                <asp:BoundField DataField="GioKetThuc" HeaderText="Kết thúc" DataFormatString="{0:HH:mm}" />
                <asp:BoundField DataField="SoVe" HeaderText="Vé đã bán" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton runat="server" Text="Xóa" CommandName="Xoa" CommandArgument='<%# Eval("MaSuat") %>'
                            OnClientClick="return confirm('Xóa suất chiếu này?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
