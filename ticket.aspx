﻿<%--
Slick-Ticket v2.9 - 2010
http://slick-ticket.com
Developed by Stan Naspinski - stan@naspinski.net
http://naspinski.net
--%>
<%@ Page Title="View Ticket" Language="C#" ValidateRequest="false" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ticket.aspx.cs" Inherits="_ticket" culture="auto" meta:resourcekey="PageResource1"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script type="text/javascript" src="js/ckeditor/ckeditor_source.js"></script>
    <script type="text/javascript">
        //$().ready(function () {
        //    CKEDITOR.replace('ctl00_body_txtDetails', { toolbar: 'SlickTicket' });
        //});

        function showHide(showDivId, hideDivId) {
            document.getElementById(showDivId).style.display = 'block';
            document.getElementById(hideDivId).style.display = 'none';
        } 
    </script> 
    <link rel="Stylesheet" type="text/css" href="css/iconize.css" />
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" Runat="Server">
    <asp:Panel ID="pnlNoQuery" runat="server" DefaultButton="btnGoToTicket" >
        <fieldset class="inner_color">
            <h2>
                
                <span  style="float:right;">
                    <asp:TextBox ID="txtGoToTicket" runat="server" style="text-align:right;" /> 
                    <asp:Button ID="btnGoToTicket" CssClass="button smaller" runat="server" onclick="btnGoToTicket_Click" ValidationGroup="GoToTicket" 
                        meta:resourcekey="btnGoToTicketResource1"  />
                </span>
                <span style="display:block; height:3px;"></span>
                <asp:Literal runat="server" ID="litEnterTicketNumber" Text="Enter Work Order No" />
                <%--<asp:Literal runat="server" ID="litEnterTicketNumber" meta:resourcekey="litEnterTicketNumberResource1" />--%>
                <span class="smaller clear">
                    <asp:Label ID="lblTopReport" runat="server" />
                   <%-- <asp:RegularExpressionValidator ID="regGotoTicket" CssClass="error top_error" ValidationExpression="^\d+$" ValidationGroup="GoToTicket"
                        ControlToValidate="txtGoToTicket" runat="server" Display="Dynamic" meta:resourcekey="regGotoTicketResource1" />--%>
                    <asp:RequiredFieldValidator ID="regRe" CssClass="top_error" ControlToValidate="txtGoToTicket" runat="server" Display="Dynamic" 
                        ValidationGroup="GoToTicket"  />
                </span>
            </h2>
        </fieldset>
    </asp:Panel>
    <asp:Panel ID="pnlShowTicket" runat="server" style="display:none;" DefaultButton="btnUpdate">
        <asp:Panel ID="pnlDisplay" runat="server">
            <h2 class="header">
                <span class="title_header">
                    <%= t.title %><span class="smaller">[<%= t.Order_no  %>]</span>
                </span>
                <span class="clear"></span>
            <span class="smaller"><asp:Label ID="lblReport" runat="server" /></span>
            </h2>
            <h3 class="smaller header">
                <span class="title_header iconize" style="text-align:left;">
                    <a href="javascript:void();" class="tooltip limited">
                        <%= t.user.userName %>
                        <span class="border_color">
                            <q class="inner_color base_text">
                                <%= t.user.email %><br />
                                <%= t.user.phone %><br />
                                <%= t.user.sub_unit1.unit.unit_name %><br />
                                <%= t.user.sub_unit1.sub_unit_name %>
                            </q>
                        </span>
                    </a>
                </span>
                <%= t.submitted %>
                <span class="clear" ></span>
            
            </h3>
            <fieldset class="inner_color faq_body">
                <div class="comment_header smaller">
                    <span style="float:left;visibility:collapse;">
                        <span class="bold"><%= Resources.Common.AssignedTo %>:  </span>
                         <%= t.sub_unit2.unit.unit_name %> - <%=  t.sub_unit2.sub_unit_name %>
                    </span>
                    <span style="float:right">
                        <span class="bold"><%= Resources.Common.Priority %>: </span>
                        <%= t.priority1.priority_name %>
                    </span>
                    <span  class="clear"></span>
                </div>
                <div class="comment_header smaller">
                    <span style="float:left;">
                        <span class="bold"><%= Resources.Common.UniqueCode %>: </span>
                        <%= t.UniqueCode %>
                    </span>
                </div>
                <br />
                <div><%= t.details %></div>
                <br />
                <div class="smaller bold iconize">
                    <asp:Repeater ID="rptAttachments" runat="server" DataSourceID="ldsAttachments">
                        <ItemTemplate>
                            <div class="iconize">
                                <asp:LinkButton ID="btnAttachment" runat="server" OnClick="btnAttachment_Click" CommandArgument='<%# Eval("attachment_name") %>' 
                                    CssClass='<%# getExtension(Eval("attachment_name").ToString()) %>'> 
                                    <%# Eval("attachment_name") %> (<%# Eval("attachment_size") %>&nbsp;<%= Resources.Common.Bytes %>)
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:LinqDataSource ID="ldsAttachments" runat="server" 
                    ContextTypeName="SlickTicket.DomainModel.stDataContext" OrderBy="attachment_name" 
                    Select="new (ticket_ref, attachment_name, attachment_size)" 
                    TableName="attachments" Where="ticket_ref == @ticket_ref AND comment_ref == null">
                    <WhereParameters>
                        <asp:QueryStringParameter DefaultValue="0" Name="ticket_ref" 
                            QueryStringField="ticketID" Type="Int32" />
                    </WhereParameters>
                </asp:LinqDataSource>
                
                <asp:Label ID="lblComments" CssClass="smaller" runat="server" 
                    meta:resourcekey="lblCommentsResource1" />
            </fieldset>
        </asp:Panel>
        <div class="divider"></div>
        <fieldset class="inner_color">
            <asp:UpdatePanel ID="up" runat="server">
                <ContentTemplate>
                    <h3>
                        <span class="title_header larger"><%= Resources.Common.AssignedTo %></span>&nbsp
                    </h3>
                    <table class="by2">
                        <%--<tr>
                            <td>
                                <h3>
                                    <span class="title_header">Order No</span>
                                </h3>
                                <asp:TextBox ID="txtOrder_No" runat="server" CssClass="half_table"></asp:TextBox>
                            </td>
                            <td></td>
                        </tr>--%>
                        <tr>
                            <td style="width:50%;display:none">
                                <h3><span class="title_header"><%= Resources.Common.Group %></span>
                                    <asp:RequiredFieldValidator ID="rfvUnit" runat="server" ControlToValidate="ddlUnit" CssClass="error" display="Dynamic" ForeColor="" InitialValue="0" meta:resourcekey="rfvUnitResource1" />
                                </h3>
                                <asp:DropDownList ID="ddlUnit" runat="server" AutoPostBack="True" CssClass="half_table" onselectedindexchanged="ddlUnit_SelectedIndexChanged" />
                            </td>
                            <td style="width:50%;display:none">
                                <h3><span class="title_header"><%= Resources.Common.Subgroup %></span>
                                    <asp:RequiredFieldValidator ID="rfvSubUnit" runat="server" ControlToValidate="ddlSubUnit" CssClass="error" display="Dynamic" ForeColor="" InitialValue="0" meta:resourcekey="rfvSubUnitResource1" />
                                </h3>
                                <asp:DropDownList ID="ddlSubUnit" runat="server" CssClass="half_table" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h3>
                                    <span class="title_header">Work Order No</span>
                                </h3>
                                <asp:Label ID="lblWorkOrderNo" runat="server"  CssClass="half_table" />
                            </td>
                            <td >
                                <h3>
                                    <span class="title_header">Customer Name</span>
                                </h3><br/>
                                <asp:Label ID="lblName" runat="server" CssClass="half_table<" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h3>
                                    <span class="title_header">Model Name</span>
                                </h3>
                                <asp:Label ID="lblModelName" runat="server"  CssClass="half_table" />
                            </td>
                            <td >
                                <h3>
                                    <span class="title_header">Model Number</span>
                                </h3><br/>
                                <asp:Label ID="lblModelNo" runat="server" CssClass="half_table<" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h3>
                                    <span class="title_header">IMEI No</span>
                                </h3>
                                <asp:Label ID="lblIMEI" runat="server"  CssClass="half_table" />
                            </td>
                            <td >
                                <h3>
                                    <span class="title_header">Estimation</span>
                                </h3><br/>
                                <asp:Label ID="lblEstimation" runat="server" CssClass="half_table<" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h3>
                                    <span class="title_header"><%= Resources.Common.Status %></span>
                                </h3>
                                <asp:DropDownList ID="ddlStatus" runat="server"  CssClass="half_table" />
                            </td>
                            <td >
                                <h3>
                                    <span class="title_header"><%= Resources.Common.Priority %></span>
                                </h3><br/>
                                <asp:DropDownList ID="ddlPriority" runat="server" CssClass="half_table<" />
                            </td>
                        </tr>
                    </table>   
                </ContentTemplate>
            </asp:UpdatePanel>
            
                <asp:Panel ID="pnlComment" runat="server" >
                    <h3>
                        <span class="title_header"><asp:Literal runat="server" ID="litComment" meta:resourcekey="litCommentResource1" /></span>&nbsp;
                    </h3>
                    <asp:TextBox ID="txtDetails" runat="server" TextMode="MultiLine" Height="100px" 
                        Width="100%" meta:resourcekey="txtDetailsResource1" />
                    
                    <h3>
                        <span class="title_header"><%= Resources.Common.Attachments %></span>
                        <span class="clear"></span>
                    </h3>
                    <div>
                        <div><asp:FileUpload CssClass="attachment" ID="FileUpload1" runat="server"  /></div>
                        <div id="add1">
                            <a href="javascript:void();" onclick="showHide('att2', 'add1')"><%= Resources.Common.AdditionalAttachment %></a>
                        </div>
                    </div>
                    <div id="att2" style="display:none;">
                        <div><asp:FileUpload CssClass="attachment" ID="FileUpload2" runat="server" /></div>
                        <div id="add2">
                            <a href="javascript:void();" onclick="showHide('att3', 'add2')"><%= Resources.Common.AdditionalAttachment %></a>
                        </div>
                    </div>
                    <div id="att3" style="display:none;">
                        <div><asp:FileUpload CssClass="attachment" ID="FileUpload3" runat="server" /></div>
                        <div id="add3">
                            <a href="javascript:void();" onclick="showHide('att4', 'add3')"><%= Resources.Common.AdditionalAttachment %></a>
                        </div>
                    </div>
                    <div id="att4" style="display:none;">
                        <div><asp:FileUpload CssClass="attachment" ID="FileUpload4" runat="server" /></div>
                        <div id="add4">
                            <a href="javascript:void();" onclick="showHide('att5', 'add4')"><%= Resources.Common.AdditionalAttachment %></a>
                        </div>
                    </div>
                    <div id="att5" style="display:none;">
                        <div><asp:FileUpload CssClass="attachment" ID="FileUpload5" runat="server" /></div>
                        <div>
                            <asp:Literal runat="server" ID="lit5Attachments" meta:resourcekey="lit5AttachmentsResource1" />
                        </div>
                    </div>
                <div>
                
                </div>
                <br />
                <div style="text-align:center;">
                    <asp:Button runat="server" ID="btnUpdate" CssClass="button" onclick="btnUpdate_Click" meta:resourcekey="btnUpdateResource1"   />
                    <asp:Button runat="server" ID="btnClose" CssClass="button" onclick="btnClose_Click" meta:resourcekey="btnCloseResource1"  />
                    <asp:Button runat="server" ID="btnOpen" CssClass="button" OnClick="btnOpen_Click" meta:resourcekey="btnOpenResource1" />
                </div>
            </asp:Panel>
        </fieldset>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="sidebar" Runat="Server">
</asp:Content>

