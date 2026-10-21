<%@ Page Title="Quản lý phim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Phim.aspx.cs" Inherits="GalaxyCinemaWeb.QuanLy.Phim" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2><asp:Literal ID="litTieuDe" runat="server" Text="Thêm phim mới" /></h2>
        <asp:HiddenField ID="hfMaPhim" runat="server" />
        <div class="form-inline">
            <div class="form-row"><label>Tên phim</label><asp:TextBox ID="txtTenPhim" runat="server" /></div>
            <div class="form-row"><label>Thể loại chính</label><asp:TextBox ID="txtTheLoai" runat="server" /></div>
            <div class="form-row"><label>Thời lượng (phút)</label><asp:TextBox ID="txtThoiLuong" runat="server" TextMode="Number" /></div>
            <div class="form-row"><label>Độ tuổi</label>
                <asp:DropDownList ID="ddlDoTuoi" runat="server">
                    <asp:ListItem>P</asp:ListItem><asp:ListItem>K</asp:ListItem><asp:ListItem>T13</asp:ListItem>
                    <asp:ListItem>T16</asp:ListItem><asp:ListItem>T18</asp:ListItem>
                </asp:DropDownList></div>
            <div class="form-row"><label>Ngày khởi chiếu</label><asp:TextBox ID="txtKhoiChieu" runat="server" TextMode="Date" /></div>
        </div>
        <asp:Button ID="btnLuu" runat="server" Text="Thêm phim" OnClick="btnLuu_Click" />
        <asp:Button ID="btnMoi" runat="server" Text="Nhập mới" CssClass="phu" OnClick="btnMoi_Click" />
        <p><asp:Label ID="lblThongBao" runat="server" /></p>
    </div>
    <div class="box">
        <h2>Danh sách phim</h2>
        <asp:GridView ID="gvPhim" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None"
            DataKeyNames="MaPhim" OnRowCommand="gvPhim_RowCommand">
            <Columns>
                <asp:BoundField DataField="MaPhim" HeaderText="Mã" />
                <asp:BoundField DataField="TenPhim" HeaderText="Tên phim" />
                <asp:BoundField DataField="TheLoaiChinh" HeaderText="Thể loại" />
                <asp:BoundField DataField="ThoiLuong" HeaderText="Phút" />
                <asp:BoundField DataField="DoTuoiChoPhep" HeaderText="Độ tuổi" />
                <asp:BoundField DataField="NgayKhoiChieu" HeaderText="Khởi chiếu" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="SoSuat" HeaderText="Số suất" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton runat="server" Text="Sửa" CommandName="Sua" CommandArgument='<%# Eval("MaPhim") %>' />
                        &nbsp;
                        <asp:LinkButton runat="server" Text="Xóa" CommandName="Xoa" CommandArgument='<%# Eval("MaPhim") %>'
                            OnClientClick="return confirm('Xóa phim này?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
