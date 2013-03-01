<%-- #@ _IMPORT_ --%>
<%@ page import="java.util.Date" %>
<%-- #@ _IMPORT_ --%>
<html>
<head>
<title>Test Page</title>
</head>
<body bgcolor="white">
<p>
This is a test.
<%-- #@ _DATE_ --%>
The current date is <%= new Date() %>.
<%-- #@ _DATE_ --%>
</p>
</body>
</html>
