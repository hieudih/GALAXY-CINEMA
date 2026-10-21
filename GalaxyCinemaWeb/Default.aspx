<%@ Page Title="Phim đang chiếu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GalaxyCinemaWeb._Default" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Phim đang chiếu</h2>
    <div class="grid">
        <asp:Repeater ID="rptDangChieu" runat="server">
            <ItemTemplate>
                <div class="card">
                    <h3><%#: Eval("TenPhim") %></h3>
                    <p><span class="tag"><%#: Eval("DoTuoiChoPhep") %></span> <%#: Eval("TheLoaiChinh") %></p>
                    <p>Thời lượng: <%#: Eval("ThoiLuong") %> phút</p>
                    <p>Khởi chiếu: <%#: Eval("NgayKhoiChieu", "{0:dd/MM/yyyy}") %></p>
                    <a class="btn" href='ChiTietPhim.aspx?MaPhim=<%#: Eval("MaPhim") %>'>Đặt vé</a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <h2 style="margin-top:32px">Phim sắp chiếu</h2>
    <div class="grid">
        <asp:Repeater ID="rptSapChieu" runat="server">
            <ItemTemplate>
                <div class="card">
                    <h3><%#: Eval("TenPhim") %></h3>
                    <p><span class="tag"><%#: Eval("DoTuoiChoPhep") %></span> <%#: Eval("TheLoaiChinh") %></p>
                    <p>Khởi chiếu: <%#: Eval("NgayKhoiChieu", "{0:dd/MM/yyyy}") %></p>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
