<%@ Page Title="Gửi phản hồi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PhanHoi.aspx.cs" Inherits="GalaxyCinemaWeb.PhanHoi" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="box">
        <h2>Gửi phản hồi</h2>
        <div class="form-row"><label>Nội dung góp ý</label>
            <asp:TextBox ID="txtNoiDung" runat="server" TextMode="MultiLine" Rows="4" MaxLength="1000" /></div>
        <asp:Button ID="btnGui" runat="server" Text="Gửi phản hồi" OnClick="btnGui_Click" />
        <p><asp:Label ID="lblThongBao" runat="server" /></p>
    </div>
    <div class="box">
        <h2>Phản hồi đã gửi</h2>
        <asp:GridView ID="gvPhanHoi" runat="server" AutoGenerateColumns="false" CssClass="bang" GridLines="None"
            EmptyDataText="Bạn chưa gửi phản hồi nào.">
            <Columns>
                <asp:BoundField DataField="ThoiDiemGui" HeaderText="Thời điểm" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="NoiDung" HeaderText="Nội dung" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
