DROP FUNCTION IF EXISTS time_ampm;
delimiter $$
#@ _FRAG_
CREATE FUNCTION time_ampm (t TIME)
RETURNS VARCHAR(13) # mm:dd:ss {a.m.|p.m.} format
BEGIN
  DECLARE ampm CHAR(4);
  IF TIME_TO_SEC(t) < 12*60*60 THEN
    SET ampm = 'a.m.';
  ELSE
    SET ampm = 'p.m.';
  END IF;
  RETURN CONCAT(LEFT(TIME_FORMAT(t, '%r'),9),ampm);
END;
#@ _FRAG_
$$
delimiter ;
SET @t = '00:00:00';
SELECT @t, TIME_FORMAT(@t, '%r'), time_ampm(@t);
SET @t = '00:00:01';
SELECT @t, TIME_FORMAT(@t, '%r'), time_ampm(@t);
SET @t = '12:00:00';
SELECT @t, TIME_FORMAT(@t, '%r'), time_ampm(@t);
SET @t = '12:00:01';
SELECT @t, TIME_FORMAT(@t, '%r'), time_ampm(@t);
