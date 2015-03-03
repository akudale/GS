//Slick-Ticket v2.0 - 2009
//http://slick-ticket.com :: http://naspinski.net
//Developed by Stan Naspinski - stan@naspinski.net


using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using SlickTicketExtensions;
using System.IO;
using SlickTicket.DomainModel;
using SlickTicket.DomainModel.Objects;
using SlickTicket.DomainModel.Extensions;

public partial class _ticket : System.Web.UI.Page
{
    stDataContext db = new stDataContext();
    CurrentUser currentUser;
    protected ticket t;
    int accessLevel;
    string userName;
    string n;

    protected void Page_Load(object sender, EventArgs e)
    {
        currentUser = CurrentUser.Get();
        n = Environment.NewLine;
        this.Title = Resources.Common.ViewTicket;
        userName = currentUser.UserName;
        db = new stDataContext();
        txtGoToTicket.Focus();
        //if (Request.QueryString["ticketID"] != null)
        //    populateTicket(Request.QueryString["ticketID"].ToString());
        if (Request.QueryString["orderno"] != null)
            populateTicket(Request.QueryString["orderno"].ToString());
        else pnlDisplay.Visible = false;
    }

    protected void populateTicket(string ticketID)
    {
        try
        {
            bool userCanEditThisTicket = true;
            t = Tickets.Get(db, ticketID);
            //ticketID = t.id.ToString();
            //t = Tickets.Get(db, ticketID);
            user_group ugAccessLevel = currentUser.HighestAccessLevelGroup;

            //if user is limited, they can only see their own tickets
            if (ugAccessLevel.security_level < 2 && t.submitter != currentUser.Details.id) 
                throw new InvalidOperationException(GetLocalResourceObject("LimitedUser").ToString() + " [" + ticketID + "]");
            
            ////populate comments
            IEnumerable<comment> comments = t.ActiveComments();
            StringBuilder sb = new StringBuilder();
            foreach (comment c in comments)
                buildComments(c);

            if (sb.Length > 0)
                lblComments.Text = sb.ToString();


            //only do the user is at the right level... if not, read only
            int intToPopATG = ugAccessLevel.security_level;
            accessLevel = intToPopATG;
            if (ugAccessLevel.security_level < t.sub_unit.access_level)
            {
                intToPopATG = 10; //if the user has too low a level to change this ticket, this is set to 10;
                userCanEditThisTicket = false;
            }

            if (!IsPostBack)
            {
                btnOpen.Visible = false; // (t.ticket_status == 12);
                btnClose.Visible = !(t.ticket_status == 12);
                if (userCanEditThisTicket) // full edit privs
                {
                    foreach (priority p in Misc.Priorities.List(db, 10)) ddlPriority.Items.Add(new ListItem(p.priority_name, p.id.ToString()));
                    foreach (statuse s in Misc.Statuses.List(db)) ddlStatus.Items.Add(new ListItem(s.status_name, s.id.ToString()));
                    ddlStatus.set(t.ticket_status.ToString());
                    ddlPriority.set(t.priority.ToString());
                    var units = Units.List(db, accessLevel);
                    foreach (unit u in units.OrderBy(p => p.unit_name))
                        ddlUnit.Items.Add(new ListItem(u.unit_name, u.id.ToString()));
                    ddlUnit.set(t.sub_unit.unit.id.ToString());
                    Utils.PopulateSubUnits(db, ddlUnit, ddlSubUnit, accessLevel);
                    ddlSubUnit.set(t.assigned_to_group.ToString());
                }
                else //user can not edit anything but comments
                {
                    ddlUnit.Items.Add(new ListItem(t.sub_unit.unit.unit_name, t.sub_unit.unit.ToString()));
                    ddlSubUnit.Items.Add(new ListItem(t.sub_unit.sub_unit_name, t.assigned_to_group.ToString()));
                    ddlPriority.Items.Add(new ListItem(t.priority1.priority_name, t.priority.ToString()));
                    ddlStatus.Items.Add(new ListItem(t.statuse.status_name, t.statuse.id.ToString()));
                    ddlSubUnit.Enabled = false;
                    ddlUnit.Enabled = false;
                    ddlPriority.Enabled = false;
                    ddlStatus.Enabled = false;

                    if (currentUser.Details.sub_unit == t.user.sub_unit || Comments.CommentingGroups(db, t.id).Contains(currentUser.Details.sub_unit))
                        lblReport.report(false, GetLocalResourceObject("CommentAttachClose").ToString(), null);
                    else
                    {
                        pnlComment.Style.Add(HtmlTextWriterStyle.Display, "none");
                        lblReport.report(false, GetLocalResourceObject("ViewOnly").ToString(), null);
                    }
                }
                Customer Cust = db.Customers.FirstOrDefault(u => u.MembershipNo.Equals(t.UniqueCode));
                if (Cust != null)
                {
                    lblWorkOrderNo.Text = t.Order_no;
                    lblName.Text = Cust.Name;
                    lblIMEI.Text = Cust.ImeiNo;
                    lblModelName.Text = Cust.BrandName;
                    lblModelNo.Text = Cust.ModelNo;
                    lblEstimation.Text = Cust.InvoiceDate.ToString();
                    
                }
            }
            pnlShowTicket.Style.Clear();
            pnlShowTicket.Style.Add(HtmlTextWriterStyle.Display, "block");
            pnlDisplay.Visible = true;
            pnlNoQuery.Visible = false;
        }
        catch (Exception ex)
        {
            if(ex.Message.Contains("Object reference not set to an instance of an object."))
                ex = new Exception(GetLocalResourceObject("NoTicket").ToString() + " " + Request.QueryString["ticketID"].ToString(), ex);
            lblTopReport.report(false, "Error", ex);
            pnlDisplay.Visible = false;
        }
    }

    protected void buildComments(comment c)
    {
        lblComments.Controls.Add(new LiteralControl("<br /><h3 class='smaller'><span class='title_header'>"));
        lblComments.Controls.Add(new LiteralControl("<a href='javascript:void();' class='tooltip'>" + c.user.userName + "<span class='border_color'><q class='inner_color base_text'>"));
        lblComments.Controls.Add(new LiteralControl("<div>" + c.user.email + "</div><div class='rollover'>" + c.user.phone + "</div><div class='rollover'>" + c.user.sub_unit1.unit.unit_name + "</div>"));
        lblComments.Controls.Add(new LiteralControl("<div class='rollover'>" + c.user.sub_unit1.sub_unit_name + "</div>"));
        lblComments.Controls.Add(new LiteralControl("</q></span></a>"));
        lblComments.Controls.Add(new LiteralControl("</span>" + c.submitted.ToString() + "</h3>"));
        lblComments.Controls.Add(new LiteralControl("<div class='comment_border border_color'><div class='comment inner_color'>"));

        string strComment = "<div class='comment_header'><span style='float:left'><span class='bold'>" + Resources.Common.AssignedTo + ": </span>" + c.sub_unit.unit.unit_name + " - " + 
            c.sub_unit.sub_unit_name + "</span>" + "<span style='float:right'><span class='bold'>" + Resources.Common.Status + ": </span>" + c.statuse.status_name + " <span class='bold'>" + 
            Resources.Common.Priority + ": </span>" + c.priority.priority_name + "</span><span  class='clear'></span></div>" + n + "<div>" + c.comment1 + "</div>";
        
        lblComments.Controls.Add(new LiteralControl(strComment));
        bool first_attachment = true;
        foreach (attachment a in c.attachments.AsEnumerable())
        {
            if (first_attachment)
            {
                lblComments.Controls.Add(new LiteralControl("<br />"));
                first_attachment = false;
            }
            lblComments.Controls.Add(new LiteralControl(n + "<div class='iconize'>"));
            LinkButton lb = new LinkButton()
            {
                CommandArgument = a.attachment_name,
                Text = a.attachment_name + " (" + a.attachment_size + " " + Resources.Common.Bytes + ")",
                CssClass = Path.GetExtension(a.attachment_name)
            };
            lb.Click += new EventHandler(btnAttachment_Click);
            lblComments.Controls.Add(lb);
            lblComments.Controls.Add(new LiteralControl("</div>"));
        }
        lblComments.Controls.Add(new LiteralControl("</div></div>"));
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        ddlStatus.set("5");
        ddlStatus.Items.Clear();
        ddlStatus.Items.Add(new ListItem(Resources.Common.Closed, "5"));
        btnUpdate_Click(null, null);
    }

    protected void btnOpen_Click(object sender, EventArgs e)
    {
        ddlStatus.set("5");
        ddlStatus.Items.Clear();
        ddlStatus.Items.Add(new ListItem(Resources.Common.Resolved, "4"));
        btnUpdate_Click(null, null);
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        string error = Resources.Common.Error;
        try
        {
            FileUpload[] fuControls = new FileUpload[] { FileUpload1, FileUpload2, FileUpload3, FileUpload4, FileUpload5 };
            IEnumerable<FileStream> attachments = fuControls.GetFileStreams(Settings.AttachmentDirectory);
            //int commentID = Comments.New(db, t.id, currentUser.Details.id, txtDetails.Text, ddlSubUnit.SelectedValueToInt(), ddlPriority.SelectedValueToInt(), ddlStatus.SelectedValueToInt(), attachments, Settings.AttachmentDirectory);
            int commentID = Comments.New(db, t.id, currentUser.Details.id, txtDetails.Text,currentUser.Details.sub_unit, ddlPriority.SelectedValueToInt(), ddlStatus.SelectedValueToInt(), attachments, Settings.AttachmentDirectory);
            Attachments.TempFolderCleanup(Settings.AttachmentDirectory);

            stDataContext db2 = new stDataContext(); // have to get new stDataContext in order to chage the foreign key since it was already open

            ticket _t = Tickets.Update(db2, t.id, Int32.Parse(ddlStatus.SelectedValue), Int32.Parse(ddlPriority.SelectedValue), Int32.Parse(ddlSubUnit.SelectedValue));
            bool new_or_closing_ticket = (t.statuse.id != 5 && _t.statuse.id == 5) || (t.statuse.id == 5 && _t.statuse.id == 4);
            string fromGroup = currentUser.Details.sub_unit1.unit.unit_name + " - " + currentUser.Details.sub_unit1.sub_unit_name;
            string toGroup = _t.sub_unit1.unit.unit_name + " - " + _t.sub_unit1.sub_unit_name;
            string groupEmail = _t.assigned_to_group == _t.assigned_to_group_last ? "0" : t.sub_unit.mailto;

            if ((bool.Parse(Utils.Settings.Get("email_notification"))))
            {
                if (new_or_closing_ticket || bool.Parse(Utils.Settings.Get("email_notification_only_open_close")) == false)
                {
                    try { buildAndSendEmail(fromGroup, toGroup, _t.user.userName, _t.title, _t.statuse, _t.priority1.priority_name, _t.id, t.user.email, _t.sub_unit.mailto); }
                    catch (Exception ex) { lblReport.report(false, error += " - " + Resources.Common.EmailError, ex); }
                }
            }
            Response.Redirect(Request.Url.ToString());
        }
        catch (Exception ex) { lblReport.report(false, error, ex); }
    }

    protected void buildAndSendEmail(string fromGroup, string toGroup, string submitterName, string title, statuse status, string _priority, int id, string originalEmail, string groupEmail)
    {
        bool sendToGroup = !toGroup.Equals("0");
        string body, subject;
        if (status.id == 5)
        {
            sendToGroup = false;
            subject = ddlPriority.SelectedItem.Text + " " + Resources.Common.Priority.ToLower() + " " + Resources.Common.TicketNumber.ToLower() + " " + id + " " + GetLocalResourceObject("BeenClosed").ToString();
            body = submitterName + " (" + fromGroup + ") " + GetLocalResourceObject("HasClosed").ToString() +" " + id + ": " + title + ".   " + GetLocalResourceObject("ReOpen").ToString() + n + n + Utils.CurrentUrlDirectory + "ticket.aspx?ticketID=" + id;
        }
        else
        {
            subject = Resources.Common.TicketNumber + " " + id + " " + GetLocalResourceObject("BeenUpdated") + " - " + Resources.Common.AssignedTo.ToLower()+ " " + toGroup;
            body = submitterName + " (" + fromGroup + ") " + GetLocalResourceObject("HasUpdated").ToString() + " " + Resources.Common.TicketNumber.ToLower() + " " + id + ":" + n + title + n + n;
            body += Resources.Common.Priority + ": " + _priority + n + Resources.Common.Status + ": " + status.status_name;
            body += n + n + GetLocalResourceObject("ViewIt").ToString() + ":" + n + Utils.CurrentUrlDirectory + "ticket.aspx?ticketID=" + id;
        }
        Utils.SendEmail(originalEmail, subject, body);
        if (sendToGroup && groupEmail != originalEmail) Utils.SendEmail(groupEmail, subject, body);
    }

    protected void btnGoToTicket_Click(object sender, EventArgs e)
    {
        ticket t = Tickets.Get(db, txtGoToTicket.Text.Trim());
        Response.Redirect("ticket.aspx?ticketID=" + t.id +"&orderno="+t.Order_no);
    }

    protected void ddlUnit_SelectedIndexChanged(object sender, EventArgs e)
    {
        Utils.PopulateSubUnits(db, ddlUnit, ddlSubUnit, accessLevel);
        ddlUnit.Focus();
    }

    protected void btnAttachment_Click(object sender, EventArgs e)
    {
        LinkButton clicked = (LinkButton)sender;
        string root = Utils.Settings.Get("attachments") + Request.QueryString["ticketID"].ToString() + "/";
        Response.AppendHeader("Content-Disposition", "attachment; filename=" + clicked.CommandArgument);
        Response.TransmitFile(Server.MapPath("~/" + root + clicked.CommandArgument));
        Response.End();
    }

    protected string getExtension(string s)
    {
        return Path.GetExtension(s);
    }
}
