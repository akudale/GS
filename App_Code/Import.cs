using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Xml.Linq;
using SlickTicket.DomainModel;

/// <summary>
/// Summary description for Import
/// </summary>
public class Import
{
    public static string Faqs(Stream xmlFile)
    {
        string output = string.Empty;
        try
        {
            TextReader rdr = new StreamReader(xmlFile);
            XElement x = XElement.Load(rdr);
            var faqs = from p in x.Descendants("faq") select p;

            foreach (XElement xe in faqs)
            {
                stDataContext db = new stDataContext();
                faq f = new faq();
                f.title = xe.FirstAttribute.Value;
                f.body = xe.Value;
                db.faqs.InsertOnSubmit(f);
                try
                {
                    db.SubmitChanges(); //inefficient to submit each time, *but* this will tell which faqs got inserted and which didn't
                    output += "<div class='success'>-" + xe.FirstAttribute.Value + " " + Resources.Common.Updated + "</div>";
                }
                catch// (Exception ex)
                {
                    output += "<div class='error'>" + Resources.Common.Error + " " + xe.FirstAttribute.Value + "</div>";
                }
            }
        }
        catch (Exception ex)
        {
            output = "<div class='error'>" + Resources.Common.Error + ": <div class='sub_error'>" + ex.Message + "</div></div>";
        }
        return output;
    }

    public static string Styles(Stream xmlFile)
    {
        string output = string.Empty;
        try
        {
            TextReader rdr = new StreamReader(xmlFile);
            XElement x = XElement.Load(rdr);
            var styles = from p in x.Descendants("style") select p;

            foreach (XElement xe in styles)
            {
                stDataContext db = new stDataContext();
                Dictionary<string, string> styleAttributes = new Dictionary<string, string>();
                style s = new style();
                foreach (XAttribute xa in xe.Attributes())
                {
                    styleAttributes.Add(xa.Name.ToString(), xa.Value);
                }
                s.alt_rows = HtmlFilter.Filter(styleAttributes["alt_rows"]);
                s.background = HtmlFilter.Filter(styleAttributes["background"]);
                s.body = HtmlFilter.Filter(styleAttributes["body"]);
                s.borders = HtmlFilter.Filter(styleAttributes["borders"]);
                s.button_text = HtmlFilter.Filter(styleAttributes["button_text"]);
                s.header = HtmlFilter.Filter(styleAttributes["header"]);
                s.hover = HtmlFilter.Filter(styleAttributes["hover"]);
                s.links = HtmlFilter.Filter(styleAttributes["links"]);
                s.style_name = HtmlFilter.Filter(styleAttributes["style_name"]);
                s.text_color = HtmlFilter.Filter(styleAttributes["text_color"]);
                db.styles.InsertOnSubmit(s);
                try
                {
                    db.SubmitChanges(); //inefficient to submit each time, *but* this will tell which styles got inserted and which didn't
                    output += "<div class='success'>-" + styleAttributes["style_name"] + " " + Resources.Common.Updated + "</div>";
                }
                catch// (Exception ex)
                {
                    output += "<div class='error'>" + Resources.Common.Error + " " + styleAttributes["style_name"] + " - <span class='smaller'>most likely a duplicate</span></div>";
                }
            }
        }
        catch (Exception ex)
        {
            output = "<div class='error'>" + Resources.Common.Error + ": <div class='sub_error'>" + ex.Message + "</div></div>";
        }
        return output;
    }
}
