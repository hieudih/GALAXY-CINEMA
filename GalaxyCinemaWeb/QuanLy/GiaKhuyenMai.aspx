<%@ Page Title="Giá vé và khuyến mãi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GiaKhuyenMai.aspx.cs" Inherits="GalaxyCinemaWeb.QuanLy.GiaKhuyenMai" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Bảng giá vé</h2>
        <p><i>Khi đổi giá, thêm một mức giá mới với ngày áp dụng mới; mức giá cũ được giữ lại để vé đã bán vẫn đúng giá lúc mua.</i></p>
        <div class="form-inline">
            <div class="form-row"><label>Loại ghế</label>
                <asp:DropDownList ID="ddlLoaiGhe" runat="server"><asp:ListItem>Thường</asp:ListItem><asp:ListItem>VIP</asp:ListItem></asp:DropDownList></div>
            <div class="form-row"><label>Loại ngày</label>
                <asp:DropDownList ID="ddlLoaiNgay" runat="server"><asp:ListItem>Ngày thường</asp:ListItem><asp:ListItem>Cuối tuần</asp:ListItem></asp:DropDownList></div>
            <div class="form-row"><label>Giá vé (đồng)</label><asp:TextBox ID="txtGiaVe" runat="server" TextMode="Number" /></div>
            <div class="form-row"><label>Ngày áp dụng</label><asp:TextBox ID="txtNgayApDung" runat="server" TextMode="Date" /></div>
            <asp:Button ID="btnThemGia" runat="server" Text="Thêm mức giá" OnClick="btnThemGia_Click" />
        </div>
        <p><asp:Label ID="lblGia" runat="server" /></p>
        <asp:GridView ID="gvGia" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None">
            <Columns>
                <asp:BoundField DataField="MaGia" HeaderText="Mã giá" />
                <asp:BoundField DataField="LoaiGhe" HeaderText="Loại ghế" />
                <asp:BoundField DataField="LoaiNgay" HeaderText="Loại ngày" />
                <asp:BoundField DataField="GiaVe" HeaderText="Giá vé (đ)" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="NgayApDung" HeaderText="Áp dụng từ" DataFormatString="{0:dd/MM/yyyy}" />
            </Columns>
        </asp:GridView>
    </div>
    <div class="box">
        <h2>Chương trình khuyến mãi</h2>
        <div class="form-inline">
            <div class="form-row"><label>Tên chương trình</label><asp:TextBox ID="txtTenKM" runat="server" /></div>
            <div class="form-row"><label>Mức giảm (đồng/đơn)</label><asp:TextBox ID="txtMucGiam" runat="server" TextMode="Number" /></div>
            <div class="form-row"><label>Từ ngày</label><asp:TextBox ID="txtTuNgay" runat="server" TextMode="Date" /></div>
            <div class="form-row"><label>Đến ngày</label><asp:TextBox ID="txtDenNgay" runat="server" TextMode="Date" /></div>
            <div class="form-row"><label>Điều kiện áp dụng</label><asp:TextBox ID="txtDieuKien" runat="server" /></div>
            <asp:Button ID="btnThemKM" runat="server" Text="Thêm khuyến mãi" OnClick="btnThemKM_Click" />
        </div>
        <p><asp:Label ID="lblKM" runat="server" /></p>
        <asp:GridView ID="gvKM" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None" OnRowCommand="gvKM_RowCommand">
            <Columns>
                <asp:BoundField DataField="MaKM" HeaderText="Mã" />
                <asp:BoundField DataField="TenKM" HeaderText="Tên chương trình" />
                <asp:BoundField DataField="MucGiam" HeaderText="Mức giảm (đ)" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="NgayBatDau" HeaderText="Từ ngày" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="NgayKetThuc" HeaderText="Đến ngày" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="DieuKienApDung" HeaderText="Điều kiện" />
                <asp:BoundField DataField="SoDon" HeaderText="Số đơn đã dùng" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton runat="server" Text="Xóa" CommandName="Xoa" CommandArgument='<%# Eval("MaKM") %>'
                            OnClientClick="return confirm('Xóa chương trình khuyến mãi này?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
