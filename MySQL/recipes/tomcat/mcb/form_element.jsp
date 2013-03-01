<%-- form_element.jsp --%>
<%--
- Default values aren't selected properly
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Form Element Generation"/>

<html>
<head>
<title><c:out value="${title}"/></title>
</head>
<body bgcolor="white">

<form action="<%= request.getRequestURI () %>" method="post">

<p>Cow color:</p>

<%-- Retrieve list of cow colors --%>

<%-- #@ _FETCH_COLOR_LIST_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT color FROM cow_color ORDER BY color
</sql:query>
<%-- #@ _FETCH_COLOR_LIST_ --%>

<%-- Use list to generate single-pick elements --%>

<%-- radio button group --%>

<p>As radio button group:</p>
<%-- #@ _PRINT_COLOR_RADIO_ --%>
<c:forEach items="${rs.rows}" var="row">
  <input type="radio" name="color"
    value="<c:out value="${row.color}"/>"
  /><c:out value="${row.color}"/><br />
</c:forEach>
<%-- #@ _PRINT_COLOR_RADIO_ --%>

<%-- pop-up menu --%>

<p>As popup menu:</p>
<%-- #@ _PRINT_COLOR_POPUP_ --%>
<select name="color">
<c:forEach items="${rs.rows}" var="row">
  <option value="<c:out value="${row.color}"/>">
  <c:out value="${row.color}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_COLOR_POPUP_ --%>

<%-- single-pick scrolling list, 3 rows visible at a time --%>

<p>As single-pick scrolling list:</p>
<%-- #@ _PRINT_COLOR_SCROLLING_SINGLE_ --%>
<select name="color" size="3">
<c:forEach items="${rs.rows}" var="row">
  <option value="<c:out value="${row.color}"/>">
  <c:out value="${row.color}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_COLOR_SCROLLING_SINGLE_ --%>

<hr />
<p>State of residence:</p>

<%-- Retrieve list of state abbreviations and full names--%>

<%-- #@ _FETCH_STATE_LIST_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT abbrev, name FROM states ORDER BY name
</sql:query>
<%-- #@ _FETCH_STATE_LIST_ --%>

<%-- Use list to generate single-pick elements --%>

<%-- radio button group --%>

<p>As radio button group:</p>
<p>(skipped; too long)</p>

<%-- pop-up menu --%>

<p>As popup menu:</p>
<%-- #@ _PRINT_STATE_POPUP_ --%>
<select name="state">
<c:forEach items="${rs.rows}" var="row">
  <option value="<c:out value="${row.abbrev}"/>">
  <c:out value="${row.name}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_STATE_POPUP_ --%>

<%-- single-pick scrolling list, six rows visible at a time --%>

<p>As single-pick scrolling list:</p>
<%-- #@ _PRINT_STATE_SCROLLING_SINGLE_ --%>
<select name="state" size="6">
<c:forEach items="${rs.rows}" var="row">
  <option value="<c:out value="${row.abbrev}"/>">
  <c:out value="${row.name}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_STATE_SCROLLING_SINGLE_ --%>

<hr />
<p>Cow size:</p>

<%-- Retrieve metadata for ENUM column --%>

<%-- _GET_ENUM_OR_SET_VALUES_ --%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>

<%!
// declare a class method for busting up ENUM/SET values.
// typeDefAttr - the name of the page context attribute that contains
// the columm type definition
// valListAttr - the name of the page context attribute to stuff the
// column value list into

void getEnumOrSetValues (PageContext ctx,
                         String typeDefAttr,
                         String valListAttr)
{
  String typeDef = ctx.getAttribute (typeDefAttr).toString ();
  List values = new ArrayList ();

  // column must be an ENUM or SET
  Pattern pc = Pattern.compile ("(enum|set)\\((.*)\\)",
                                Pattern.CASE_INSENSITIVE);
  Matcher m = pc.matcher (typeDef);
  // matches() fails unless it matches entire string
  if (m.matches ())
  {
    // split value list on commas, trim quotes from end of each word
    String[] v = m.group (2).split (",");
    for (int i = 0; i < v.length; i++)
      values.add (v[i].substring (1, v[i].length() - 1));
  }
  ctx.setAttribute (valListAttr, values);
}

%>
<%-- _GET_ENUM_OR_SET_VALUES_ --%>

<%-- #@ _FETCH_SIZE_INFO_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT COLUMN_TYPE, COLUMN_DEFAULT
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'cookbook' AND TABLE_NAME = 'cow_order'
  AND COLUMN_NAME = 'size'
</sql:query>
<c:set var="typeDef" scope="page" value="${rs.rowsByIndex[0][0]}"/>
<% getEnumOrSetValues (pageContext, "typeDef", "values"); %>
<c:set var="default" scope="page" value="${rs.rowsByIndex[0][1]}"/>
<%-- #@ _FETCH_SIZE_INFO_ --%>

<%-- Use ENUM column information to generate single-pick list elements --%>

<p>As radio button group:</p>
<%-- #@ _PRINT_SIZE_RADIO_ --%>
<c:forEach items="${values}" var="val">
  <input type="radio" name="size"
    value="<c:out value="${val}"/>"
    <c:if test="${val == default}">checked="checked"</c:if>
  /><c:out value="${val}"/><br />
</c:forEach>
<%-- #@ _PRINT_SIZE_RADIO_ --%>

<p>As popup menu:</p>
<%-- #@ _PRINT_SIZE_POPUP_ --%>
<select name="size">
<c:forEach items="${values}" var="val">
  <option
    value="<c:out value="${val}"/>"
    <c:if test="${val == default}">selected="selected"</c:if>
  >
  <c:out value="${val}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_SIZE_POPUP_ --%>

<p>As single-pick scrolling list:</p>
<p>(skipped; too few items)</p>

<hr >
<p>Cow accessories:</p>

<%-- Retrieve metadata for SET column --%>

<%-- #@ _FETCH_ACCESSORY_INFO_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT COLUMN_TYPE, COLUMN_DEFAULT
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'cookbook'
  AND TABLE_NAME = 'cow_order'
  AND COLUMN_NAME = 'accessories'
</sql:query>
<c:set var="typeDef" scope="page" value="${rs.rowsByIndex[0][0]}"/>
<% getEnumOrSetValues (pageContext, "typeDef", "values"); %>
<c:set var="defList" scope="page" value="${rs.rowsByIndex[0][1]}"/>
<%-- #@ _FETCH_ACCESSORY_INFO_ --%>

<%-- Use SET column information to generate multiple-pick list elements --%>

<p>As checkbox group:</p>
<%-- #@ _PRINT_ACCESSORY_CHECKBOX_ --%>
<c:forEach items="${values}" var="val">
  <input type="checkbox" name="accessories"
    value="<c:out value="${val}"/>"
    <c:forEach items="${defList}" var="default">
      <c:if test="${val == default}">checked="checked"</c:if>
    </c:forEach>
  /><c:out value="${val}"/><br />
</c:forEach>
<%-- #@ _PRINT_ACCESSORY_CHECKBOX_ --%>

<p>As multiple-pick scrolling list:</p>
<%-- #@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_ --%>
<select name="accessories" size="3" multiple="multiple">
<c:forEach items="${values}" var="val">
  <option
    value="<c:out value="${val}"/>"
    <c:forEach items="${defList}" var="default">
      <c:if test="${val == default}">selected="selected"</c:if>
    </c:forEach>
  >
  <c:out value="${val}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_ --%>

<hr />
<p>Tables in cookbook database:</p>

<%-- Retrieve list of tables in database --%>

<%-- #@ _FETCH_TABLES_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = 'cookbook'
  ORDER BY TABLE_NAME
</sql:query>
<%-- #@ _FETCH_TABLES_ --%>

<%-- Use list to generate single-pick elements --%>

<%-- radio button group --%>

<p>As radio button group:</p>
<p>(skipped; likely to be long)</p>

<%-- pop-up menu --%>

<p>As popup menu:</p>
<%-- #@ _PRINT_TABLES_POPUP_ --%>
<select name="table">
<c:forEach items="${rs.rowsByIndex}" var="row">
  <option value="<c:out value="${row[0]}"/>">
  <c:out value="${row[0]}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_TABLES_POPUP_ --%>

<%-- single-pick scrolling list, 5 rows visible at a time --%>

<p>As single-pick scrolling list:</p>
<%-- #@ _PRINT_TABLES_SCROLLING_SINGLE_ --%>
<select name="table" size="5">
<c:forEach items="${rs.rowsByIndex}" var="row">
  <option value="<c:out value="${row[0]}"/>">
  <c:out value="${row[0]}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_TABLES_SCROLLING_SINGLE_ --%>

<hr />
<p>List of dates in last week:</p>

<%-- Retrieve list of dates --%>

<%-- #@ _FETCH_DATES_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT
    CURDATE() - INTERVAL 6 DAY,
    CURDATE() - INTERVAL 5 DAY,
    CURDATE() - INTERVAL 4 DAY,
    CURDATE() - INTERVAL 3 DAY,
    CURDATE() - INTERVAL 2 DAY,
    CURDATE() - INTERVAL 1 DAY,
    CURDATE()
</sql:query>
<%-- #@ _FETCH_DATES_ --%>

<%-- Use list to generate single-pick elements --%>

<%-- radio button group --%>

<p>As radio button group:</p>
<%-- #@ _PRINT_DATE_RADIO_ --%>
<c:set var="dateList" value="${rs.rowsByIndex[0]}"/>
<c:forEach items="${dateList}" var="date">
  <input type="radio" name="date"
    value="<c:out value="${date}"/>"
  /><c:out value="${date}"/><br />
</c:forEach>
<%-- #@ _PRINT_DATE_RADIO_ --%>

</form>

</body>
</html>
