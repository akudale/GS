using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SlickTicketExtensions;
using System.IO;
using SlickTicket.DomainModel;
using SlickTicket.DomainModel.Objects;
using SlickTicket.DomainModel.Extensions;
using System.Data.SqlClient;
using System.Data;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            HttpContext.Current.Session["UserName"] = null;
            HttpContext.Current.Session["currentUser"] = null;
        }
        lblError.Text = "";
    }

    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {
        if (txtUserName.Text == "")
        {
            lblError.Text = "Please enter User Name.";
            return;
        }
        if (txtPassword.Text == "")
        {
            lblError.Text = "Please enter Password.";
            return;
        }

        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["SlickTicket"].ToString());
        SqlDataAdapter da = new SqlDataAdapter("Select * from Users where userName='"+txtUserName.Text.Trim()+"' and Password='"+txtPassword.Text.Trim()+"'",con);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt != null && dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["UserName"] = txtUserName.Text;
            Response.Redirect("~/Profile.aspx");
        }
        else
        {
            lblError.Text = "Wrong UserName and/or Password.";
        }

    }
}