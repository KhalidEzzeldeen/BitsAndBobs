<%--
  -- jstl_test.jsp - test page for verifying that Tomcat finds the JSTL tags
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="JSTL Test Page"/>

<html>
<head>
<title><c:out value="${title}"/></title>
</head>
<body bgcolor="white">

<%-- run a sample query --%>

<p>Items from profile table (id, name, birth, color, foods, cats):</p>

<sql:query dataSource="${conn}" var="rs">
  SELECT id, name, birth, color, foods, cats FROM profile ORDER BY id
</sql:query>

<c:forEach items="${rs.rows}" var="row">
<c:out value="${row.id}"/>,
<c:out value="${row.name}"/>,
<c:out value="${row.birth}"/>,
<c:out value="${row.color}"/>,
<c:out value="${row.foods}"/>,
<c:out value="${row.cats}"/>
<br />
</c:forEach>


</body>
</html>
