import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SimpleServlet extends HttpServlet
{
  public void doGet (HttpServletRequest request,
                     HttpServletResponse response)
    throws IOException, ServletException
  {
    PrintWriter out = response.getWriter ();

    response.setContentType ("text/html");
    out.println ("<html>");
    out.println ("<head>");
    out.println ("<title>Simple Servlet</title>");
    out.println ("</head>");
    out.println ("<body bgcolor=\"white\">");
    out.println ("<p>Hello.</p>");
    out.println ("<p>The current date is "
            + new Date ()
            + ".</p>");
    out.println ("<p>Your IP address is "
            + request.getRemoteAddr ()
            + ".</p>");
    out.println ("</body>");
    out.println ("</html>");
  }

  public void doPost (HttpServletRequest request,
                      HttpServletResponse response)
    throws IOException, ServletException
  {
    doGet (request, response);
  }
}
