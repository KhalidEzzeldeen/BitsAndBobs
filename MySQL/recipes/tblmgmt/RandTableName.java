// RandTableName.java - Generate a random table name

// #@ _CREATE_RANDOM_NAME_1_
import java.util.Random;
import java.lang.Math;
// #@ _CREATE_RANDOM_NAME_1_

public class RandTableName
{
  public static void main (String[] args)
  {
// #@ _CREATE_RANDOM_NAME_2_
    Random rand = new Random ();
    int n = rand.nextInt ();  // generate random number
    n = Math.abs (n);         // take absolute value
    String tblName = "tmp_tbl_" + n;
// #@ _CREATE_RANDOM_NAME_2_
    System.out.println ("Temporary table name: " + tblName);
  }
}
