<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
 <head>
   <title>chat</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="/js/scroll.js"></script>
<script src="/js/jquery-1.10.2.min.js"></script>
<script src="/js/socket.io.js"></script>
<script>

	var socket = io.connect("http://10.67.21.239:12345");
	
	$(document).ready(function() {
		socket.on('msg', function(msg) {
			addRow(msg.msg);
			$("#msg").text(msg.msg);

		});
		$("#sendBtn").bind("click", function() {
			var msg = $("input[name=chat]").val();
			socket.emit('msg', {
				msg : msg
			});
		});
	});

	function addRow(msg) {
		// var newRow = $("#range_tbl tbody tr:first").html();
		var newRow = "<td>" + msg + "</td>";
		$("#range_tbl tbody tr:first").after(
				'<tr style="background-color:#efefef;">' + newRow + '</tr>');
	}

	function delRow() {
		if ($("#range_tbl tr").length > (parseInt($("#rangeCnt")[0].value) + 2)) {
			$("#range_tbl tbody tr:first").remove();
		}
	}
	
</script>
 </head>
 <body>
	<iframe style="float:left;" src='http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=FD4C08B2D79921338FAD842293854B345F44&outKey=V124c1e2b9489e9af6c42eb04249fcbcc34487d0fb9ee63535ae4eb04249fcbcc3448&controlBarMovable=true&jsCallable=true&isAutoPlay=true&skinName=tvcast_white' frameborder='no' scrolling='no' marginwidth='0' marginheight='0' WIDTH='544' HEIGHT='306' allowfullscreen></iframe>
	<input type="text" name="chat" />
	<input type="button" value="send" id="sendBtn" />

	<table id="range_tbl" class="table table-hover">
		<tr>
			<td>글이 아래 나와요. ㅎㅎㅎ</td>
		</tr>
	</table>
 </body>
 </html>
