using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.IO;
using System.Drawing;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]

public class Screenshooter : System.Web.Services.WebService
{

    public Screenshooter()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public bool PutImage(byte[] Screenshot, string Filename) // <= Add UserName parameter
    {

        if (String.IsNullOrEmpty(Filename))
        { Filename = (DateTime.Now.ToString()).Replace(":", ""); }

        System.IO.MemoryStream ms = new System.IO.MemoryStream(Screenshot);
        System.Drawing.Bitmap b = (System.Drawing.Bitmap)Image.FromStream(ms);

        // TO DO, Filepath and adding to the Ticket
        b.Save(@"C:\Temp\" + Filename + ".png", System.Drawing.Imaging.ImageFormat.Png);

        return true;
    }

}

