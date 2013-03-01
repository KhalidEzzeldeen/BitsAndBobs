// AddInsect.java - demonstrate client-side getLastInsertID() method
// for getting the most recent AUTO_INCREMENT value.

import java.sql.*;
import com.kitebird.mcb.Cookbook;

public class AddInsect
{
  public static void main (String[] args)
  {
    Connection conn = null;

    try
    {
      conn = Cookbook.connect ();

      try
      {
//@# _GETLASTINSERTID_1_
        Statement s = conn.createStatement ();
        s.executeUpdate ("INSERT INTO insect (name,date,origin)"
                          + " VALUES('moth','2006-09-14','windowsill')");
        long seq = ((com.mysql.jdbc.Statement) s).getLastInsertID ();
        s.close ();
//@# _GETLASTINSERTID_1_
        System.out.println ("seq: " + seq);
      }
      catch (Exception e)
      {
        Cookbook.printErrorMessage (e);
      }

      try
      {
//@# _GETLASTINSERTID_2_
        PreparedStatement s = conn.prepareStatement (
                            "INSERT INTO insect (name,date,origin)"
                            + " VALUES('moth','2006-09-14','windowsill')");
        s.executeUpdate ();
        long seq = ((com.mysql.jdbc.PreparedStatement) s).getLastInsertID ();
        s.close ();
//@# _GETLASTINSERTID_2_
        System.out.println ("seq: " + seq);
      }
      catch (Exception e)
      {
        Cookbook.printErrorMessage (e);
      }
    }
    catch (Exception e)
    {
      System.err.println ("Cannot connect to server");
    }
    finally
    {
      if (conn != null)
      {
        try
        {
          conn.close ();
        }
        catch (Exception e) { }
      }
    }
  }
}

