<%--
Slick-Ticket v2.9 - 2010
http://slick-ticket.com
Developed by Stan Naspinski - stan@naspinski.net
http://naspinski.net
--%>
<%@ Page Title="New Ticket " Language="C#" MasterPageFile="~/MasterPage.master" ValidateRequest="false" AutoEventWireup="true" CodeFile="new_ticket.aspx.cs" Inherits="new_ticket" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

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
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" Runat="Server">
    
    <fieldset class="inner_color">
            <asp:Panel ID="pnlNoQuery" runat="server" DefaultButton="btnGoToTicket" >
                <fieldset class="inner_color">
                    <h2>
                        <asp:Label ID="lblenter" Text="Enter Customer Membership Code" runat="server"></asp:Label>
                        <span  style="float:right;">
                            <asp:TextBox ID="txtRegistrationNo" runat="server" style="text-align:right;" /> 
                            <asp:Button ID="btnGoToTicket"  runat="server" onclick="btnGoToTicket_Click" ValidationGroup="GoToTicket" 
                                meta:resourcekey="btnGoToTicketResource1" />
                        </span>
                        <span style="display:block; height:3px;"></span>
                        <asp:Literal runat="server" ID="litEnterTicketNumber" meta:resourcekey="litEnterTicketNumberResource1" />
                        <span class="smaller clear">
                            <asp:Label ID="lblTopReport" runat="server" />
                            <asp:RegularExpressionValidator ID="regGotoTicket" CssClass="error top_error" ValidationExpression="^\d+$" ValidationGroup="GoToTicket"
                                ControlToValidate="txtRegistrationNo" runat="server" Display="Dynamic" meta:resourcekey="regGotoTicketResource1" />
                        </span>
                    </h2>
                       

                    
                </fieldset>
            </asp:Panel>
            <asp:Panel ID="pnlInput" runat="server" DefaultButton="btnSubmit" Visible="false" >
                <asp:UpdatePanel ID="up" runat="server">
                    <ContentTemplate>
                </ContentTemplate>
            </asp:UpdatePanel>
                        <h3>
                            <span class="title_header larger" style="visibility:collapse;"><asp:literal runat="server"  ID="litAssignTo" meta:resourcekey="litAssignToResource1" /></span>&nbsp
                        </h3>
                         <table class="by2">
                                <tr>
                                    <td colspan="1">
                                        <h3>
                                            <span class="title_header"><%= Resources.Common.UniqueCode %></span>
                                        </h3>
                                        <asp:Label ID="txtuniqueCode" CssClass="full_window" runat="server" Enabled="false" />
                                    </td>
                                    <td colspan="1">
                                        <h3>
                                            <span class="title_header">Membership Value</span>
                                        </h3>
                                        <asp:Label ID="TextBox1" CssClass="full_window" runat="server" Enabled="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%;">
                                        <h3>
                                            <span class="title_header">Customer Name</span>
                                        </h3>
                                        &nbsp;
                                        <asp:Label ID="lblCustName" runat="server" CssClass="half_table" />
                                    </td>
                                    <td style="width: 50%;">
                                        <h3>
                                            <span class="title_header">Contact Number</span>
                                            
                                        </h3>
                                        &nbsp;
                                        <asp:Label ID="lblCustMob" runat="server" CssClass="half_table" />
                                    </td>
                                </tr>
                             <tr>
                                 <td style="width: 50%;">
                                     <h3>
                                         <span class="title_header">Email</span>
                                     </h3>
                                     &nbsp;&nbsp;
                                        <asp:Label ID="lblEmail" runat="server" />
                                 </td>

                                 <td colspan="1" style="width: 50%;">
                                     <h3>
                                         <span class="title_header">Mobile Purchase Date</span>
                                     </h3>
                                     &nbsp;&nbsp;<br\>
                                    <asp:Label ID="lblMobPurchaseDate" CssClass="full_window" runat="server" Enabled="false" />
                                 </td>
                             </tr>
                             <tr>
                                 <td style="width: 50%;">
                                     <h3>
                                         <span class="title_header">Alternate No</span>
                                     </h3>
                                     &nbsp;&nbsp;
                                        <asp:Label ID="lblAlternate" runat="server" />
                                 </td>

                                 <td colspan="1" style="width: 50%;">
                                     <h3>
                                         <span class="title_header">Mobile Purchase Counter</span>
                                     </h3>
                                     &nbsp;&nbsp;
                                    <asp:Label ID="lblPurCounter" CssClass="full_window" runat="server" Enabled="false" />
                                 </td>
                             </tr>
                             <tr>
                                 <td colspan="2">
                                     <h3>
                                         <span class="title_header">Address</span>
                                     </h3>
                                     &nbsp;&nbsp;
                                        <asp:Label ID="lblAddress" runat="server" />
                                 </td>
                             </tr>
                            </table>
                        <table class="by2">
                            <tr>
                                <td style="width:50%;display:none">
                                    <h3>
                                        <span class="title_header"><%= Resources.Common.Group %></span>
                                        <asp:RequiredFieldValidator runat="server" ID="rfvUnit" ControlToValidate="ddlUnit" InitialValue="0" display="Dynamic" 
                                            ForeColor="" CssClass="error" meta:resourcekey="rfvUnitResource1" />
                                    </h3>
                                    <asp:DropDownList ID="ddlUnit" runat="server"  cssclass="half_table" onselectedindexchanged="ddlUnit_SelectedIndexChanged" AutoPostBack="True"   />
                                </td>
                                <td style="width:50%;display:none">
                                    <h3>
                                        <span class="title_header"><%= Resources.Common.Subgroup %></span>
                                        <asp:RequiredFieldValidator runat="server" ID="rfvSubUnit" ControlToValidate="ddlSubUnit" InitialValue="0" display="Dynamic" 
                                            ForeColor="" CssClass="error" meta:resourcekey="rfvSubUnitResource1" />
                                    </h3>
                                    <asp:DropDownList ID="ddlSubUnit" runat="server"  cssclass="half_table" />
                                </td>
                            </tr>
                            
                            <tr style="display:none;">
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header"><%= Resources.Common.MembershipType %></span>
                                    </h3>
                                    <asp:Label ID="lblMemType" cssclass="full_window" runat="server" />
                                </td>
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header">Mobile Purchase Date</span>
                                    </h3>
                                    <asp:Label ID="lbl" cssclass="full_window" runat="server" Enabled="false"/>
                                </td>
                            </tr>
                            
                            <tr>
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header">Mobile Brand</span>
                                    </h3>&nbsp;&nbsp;
                                    <asp:Label ID="lblMobBrand" cssclass="full_window" runat="server" />
                                </td>
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header">Mobile Model</span>
                                    </h3>&nbsp;&nbsp;
                                    <asp:Label ID="lblMobModel" cssclass="full_window" runat="server" Enabled="false"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header">GS Card Purchase Date</span>
                                    </h3>&nbsp;&nbsp;
                                    <asp:Label ID="lblGSDate" cssclass="full_window" runat="server" />
                                </td>
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header">IMEI No</span>
                                    </h3>&nbsp;&nbsp;
                                    <asp:Label ID="lblIMEI" cssclass="full_window" runat="server" Enabled="false"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="1">
                                    <h3>
                                        <span class="title_header"><%= Resources.Common.Priority %></span>
                                    </h3>
                                    <asp:DropDownList ID="ddlPriority" cssclass="full_window" runat="server" />
                                </td>
                                
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <h3>
                                        <span class="title_header"><asp:literal runat="server" Text="Problem Reported" 
                                            ID="litTopic"  /></span>
                                        <asp:RequiredFieldValidator ID="rfvTopic" runat="server" ControlToValidate="txtTopic" display="Dynamic" 
                                            meta:resourcekey="rfvTopicResource1" />
                                    </h3>
                                    <h2>
                                        <asp:TextBox ID="txtTopic" runat="server" cssclass="full_window" />
                                    </h2>
                                </td>
                            </tr>
                        </table>
            <h3>
            <span class="title_header"><asp:literal runat="server" ID="litDetails" meta:resourcekey="litDetailsResource1" /></span>&nbsp;
            </h3>
            <div>
                <asp:TextBox ID="txtDetails" runat="server" TextMode="MultiLine" Height="100px" Width="100%" />
            </div>
            
            <br />
            <h3>
                <span class="title_header"><%= Resources.Common.Attachments %></span>
                <span class="clear"></span>
            </h3>
            <div>
                <div><asp:FileUpload CssClass="attachment" ID="FileUpload1" runat="server" /></div>
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
                    <asp:literal runat="server" ID="litMoreAttachments" meta:resourcekey="litMoreAttachmentsResource1" />
                </div>
            </div>
            <br />
            <div style="text-align:center;">
                <asp:Button runat="server" ID="btnSubmit" CssClass="button" onclick="btnSubmit_Click" meta:resourcekey="btnSubmitResource1" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlOutput" runat="server" Visible="False" >
            <h2 class="bold success larger"><asp:literal ID="litTicketSubmittedTitle" runat="server" meta:resourcekey="litTicketSubmittedTitleResource1" /></h2>
                <asp:literal runat="server" ID="litTicketSubmitted" meta:resourcekey="litTicketSubmittedResource1" />
                <asp:Label ID="lblSentTo" runat="server" /> 
                <br /><br />
                <asp:literal runat="server" ID="litYourTicketNumberIs" meta:resourcekey="litYourTicketNumberIsResource1" />
                <asp:Label ID="lblTicketNumber" CssClass="bold" runat="server" />; 
                <asp:literal runat="server" ID="litItWillBeAccess" meta:resourcekey="litItWillBeAccessResource1" />
                <a class="bold" href="my_issues.aspx"><%= Resources.Common.MyIssues %></a>.
        </asp:Panel>
        <asp:Panel ID="pnlError" runat="server" Visible="False" >
            <h2 class="header">
                <span class="smaller"><asp:Label ID="lblReport" runat="server" /></span>
            </h2>
        </asp:Panel>
        
    </fieldset>

</asp:Content>

