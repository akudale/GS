using System;
using System.Web;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Web.Configuration;

/// <summary>
/// Summary description for Settings
/// </summary>
public static class Settings
{
    public static string AttachmentDirectory
    {
        get { return HttpContext.Current.Server.MapPath("~" + Utils.Settings.Get("attachments")); }
        set { Utils.Settings.Update("attachments", value); }
    }

    /// <summary>
    /// not yet implemented
    /// </summary>
    public static AuthenticationMode AuthenticationMode
    {
        get
        {
            return AuthenticationMode.Windows;
            //Configuration config = WebConfigurationManager.OpenWebConfiguration("~");
            //SystemWebSectionGroup grp = (SystemWebSectionGroup)config.GetSectionGroup("system.web");
            //return grp.Authentication.Mode;
        }
    }
}
