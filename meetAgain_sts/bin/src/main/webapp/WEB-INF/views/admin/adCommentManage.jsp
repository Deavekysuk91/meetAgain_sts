<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:import url="/WEB-INF/views/common/adminHeader.jsp"/>
<script>
$('.nav-item').addClass('canSee').removeClass('cantSee');
</script>

        <div class="col-md-8 offset-md-2 content">
          <h2>댓글 관리</h2>

<div class="component">
<table class="table" style="text-align:center;margin:auto; width:100%;">
<colgroup>
<col width="5%"/>
<col width="30%"/>
<col width="15%"/>
<col width="25%"/>
<col width="15%"/>
<col width="10%"/>
</colgroup>
<thead>
<tr>
	<th>No.</th>
	<th>댓글 내용</th>
	<th>신고 회원</th>
	<th>신고 사유</th>
	<th>신고자</th>
	<th>상태</th>
</tr>
</thead>
<tbody>
<c:if test="${! empty list }">
<c:forEach items="${list }" var="c">
<tr id="${c.rcId }">
	<input type="hidden" id="rcId" value="${c.rcId }" />
	<td>${c.rcId}</td>
	<td>${ c.CContent }</td>
	<td>${ c.tnickName }</td>
	<td>${ c.rcInfo }</td>
	<td>${ c.nickName }</td>
	<input type="hidden" id="stmt" value="${c.stmt }" />
	<td>${ c.stmt }</td>
</tr>
</c:forEach>
</c:if>
<c:if test="${empty list}">
<tr>
	<td colspan="6">댓글 신고 내역이 없습니다.</td>
</tr>
</c:if>
</tbody>
</table>
</div>
</div>
<c:out value="${pageBar}" escapeXml="false"/>
<script>
$(function(){
		
		$("tr[id]").mouseenter(function(){
			if($(this).children().eq(6).val() == 'N'){
			$(this).css({"background":"#cedced", "cursor":"pointer"});
			}
		}).mouseout(function(){
			
			$(this).css({"background":"white"});
		
		}).click(function(){
			if($(this).children().eq(6).val() == 'N'){
			var rcId = $('#rcId').val();
			location.href="${pageContext.request.contextPath}/admin/adCommentDetail.do?rcId="+rcId;
			}
		});
	});


</script>




<c:import url="/WEB-INF/views/common/adminFooter.jsp"/>