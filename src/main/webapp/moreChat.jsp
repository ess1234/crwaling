<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String ip = request.getRemoteAddr();
	String server_ip = request.getLocalAddr();
	System.out.println("client_ip ::"+ ip);
	System.out.println("server_ip ::"+ server_ip);
%>
<html lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="keywords" content="아프리카TV,아프리카,개인방송,신대륙,UCC">
	<meta name="Description" content="보이는라디오,개인방송 신대륙,아프리카TV">
	<link rel="shortcut icon" type="image/x-icon" href="http://www.afreeca.com/afreeca.ico">
	<link rel="stylesheet" type="text/css" href="http://www.afreeca.com/css/default1.css">
	
	<link rel="stylesheet" type="text/css" href="/css/chat.css"><!-- 모아채팅 CSS -->
	
	<link rel="stylesheet" type="text/css" href="http://www.afreeca.com/css/global/flashplayer/main.css"><!-- 플래시플레이어_레이어 CSS -->
	<link rel="stylesheet" type="text/css" href="http://www.afreeca.com/css/global/flashplayer/chat_layer.css"><!-- 플래시플레이어_채팅레이어 CSS -->
	<link rel="stylesheet" type="text/css" href="http://www.afreeca.com/css/global/flashplayer/pop_layer.css"><!-- 플래시플레이어_팝업레이어 CSS -->
	<!-- 플래시플레이어_중국어번역 CSS -->

	<!-- ie7이하 브라우저 -->
	<!--[if lte IE 7]>
	<link rel="stylesheet" type="text/css" href="http://www.afreeca.com/css/global/flashplayer/for_ie_old.css" />
	<![endif]-->
	<script src="/js/jquery-1.10.2.min.js"></script>
	<script src="/js/jquery-ui.min.js"></script>
	<script src="/js/scroll.js"></script>
	<script src="/js/socket.io.js"></script>
	<!-- <script type="text/javascript" src="http://www.afreeca.com/script/common/placeholders.min.js"></script> -->
	<title>More 모아 TV</title>
	
	
	<!-- ess -->
	
	
	<script>
	var socket = io.connect("<%=server_ip %>:8081");
		var searchKey = false;
		var searchUser = false;
		
		$(document).ready(function() {
			
			socket.on('msg', function(msg) {
				addRow(msg.userName, msg.msg);
				// $("#msg").text(msg.msg);
				addSearch(msg.userName, msg.msg);
				
			});
			
			socket.on('more', function(msg) {
				//console.log(msg);
				addRow2(msg.userName, msg.msg, msg.seq);
			});
			
			socket.on('reserved', function(msg) {
				//console.log(msg);
				reservedEmotion(msg);
			});
			
			socket.on('realTime', function(msg) {
				//console.log(msg);
				duplicateRow(msg.userName, msg.seq);
				//$("#duplication").html(msg);
			});
			
			socket.on('flush', function(msg) {
				console.log(msg);
				document.location.reload();
			});
			
			$("#btn_send").bind("click", function() {
				sendMessage();
			});
			
			$("#write_area").on("keydown",function(e) {
			    if (e.which == 13) {
			        e.preventDefault();
			        sendMessage();
			    }
			});
			
			$("#tagSearch").bind("click", function(e) {
				 e.preventDefault();
				 searchByTag();
			});
			
			$("#tagKey").on("keydown",function(e) {
			    if (e.which == 13) {
			    	searchByTag();
			    }
			});
			
			$("#tagCancel").bind("click", function(e) {
				 e.preventDefault();
				 searchKey = false;
				 $("#tagKey").val("#");
				 $("#chat_area_search").html("");
			});
			
			
		});
		
		function searchByTag(){
			var word = $("#tagKey").val();
			if((!word.match("^#") && !word.match("^@") ) || (word.match("^#") == null && word.match("^@") == null)) {
				return false;
			}else if(word.substring(1).trim() == ""){
				return false;
			}else if(word.match("^#")){
				word = word.replace(/#+/,"");
				searchUser = false;
				searchKey = word;
			}else if(word.match("^@")){
				word = word.replace(/@+/,"");
				searchKey = false;
				searchUser = word;
			}
			var chats = $("#chat_area_user dl");
			var msg,user,html;
			$("#chat_area_search").html("");
			for(var i=0; i<chats.length; i++){
				if((searchKey && chats.eq(i).find("dd").text().indexOf(word) > -1 ) || (searchUser && chats.eq(i).find("dt a").text() == word)){
					msg = chats.eq(i).find("dd").text();
					userName = chats.eq(i).find("dt a").text();
					html = "<dl class=\"user_msg\"><dt class=\"user_m\"><a class=\"user_name\">"+userName+"</a> :</dt><dd>"+msg+"</dd></dl>";
					$("#chat_area_search").append(html);
				}
			}
			$("#chat_area3").scrollTop($("#chat_area_search").height());
		}
		
		function sendMessage(){
			var msg = $("#write_area").val();
			var ip = '<%=ip %>';
			if(msg.trim() == "") return false;
			
			// console.log(msg);
			socket.emit('msg', {msg : msg, ip:ip});
			$("#write_area").val("");
		}
		function addRow(userName, msg) {
			//console.log(msg);
			var html = "<dl class=\"user_msg\"><dt class=\"user_m\"><a href=\"#\" class=\"user_name\" onclick=\"setUserSearch(this)\">"+userName+"</a> :</dt><dd>"+msg+"</dd></dl>";
			$("#chat_area_user").append(html);
			$("#chat_area").scrollTop($("#chat_area_more").height());
			$("#chat_area2").scrollTop($("#chat_area_user").height());
		}
		
		function addRow2(userName, msg, seq) {
			//console.log(msg);
			//console.log(seq);
			var html = "<dl class=\"user_msg\" data-seq=\""+seq+"\"><dt class=\"user_m\"><a href=\"#\" class=\"user_name\" onclick=\"setUserSearch(this)\">"+userName+"</a> :</dt><dd>"+msg+"</dd></dl>";
			$("#chat_area_more").append(html);
			$("#chat_area").scrollTop($("#chat_area_more").height());
			$("#chat_area2").scrollTop($("#chat_area_user").height());
		}
		
		function addSearch(userName, msg){
			var html = "<dl class=\"user_msg\"><dt class=\"user_m\"><a class=\"user_name\">"+userName+"</a> :</dt><dd>"+msg+"</dd></dl>";
			if((searchKey && msg.indexOf(searchKey) > -1) || (searchUser && userName == searchUser)){
				$("#chat_area_search").append(html);
				$("#chat_area3").scrollTop($("#chat_area_search").height());	
			}
		}
		
		function duplicateRow(userName, seq) {
			var origin = $("#chat_area_more dl[data-seq=\'"+seq+"\']");
			var msg = origin.find("dd").text();
			var html = "<dl class=\"user_msg\"><dt class=\"user_m\"><dt class=\"user_m\"><a href=\"#\" class=\"user_name\" onclick=\"setUserSearch(this)\">"+userName+"</a> :</dt><dd>"+msg+"</dd></dl>";
			//var html2 = "<p class=\'dupe_chat\'>"+txt+"</p>"
			var merge = origin.parent(".merged");
			if(origin.parent(".merged").length == 0){
				merge = $("<div class=\"merged\"><p class=\"merged_msg\" onclick=\"openMerged(this)\" >"+msg+"<span class=\"merge_num\">1</span></p></div>");
				origin.after(merge);
				merge.append(origin);
			}
			
			merge.append(html)
			var cnt = merge.find(".merge_num");
			cnt.text(Number(cnt.text())+1);
				
///			var parent = origin.parent("merged").length > 0 ? ;
			 
///			parent.after(html);
			
		}
		
		function setUserSearch(el){
			var userName = $(el).text();
			$("#tagKey").val("@"+userName);
			$("#tagSearch").trigger("click");
			event.preventDefault();
		}
		
		function openMerged(el){
			var merge = $(el).parent(".merged");
			merge.toggleClass("merged_open");
			//$(this).toggleClass("merged_open");
		}
		
		function reservedEmotion(msg){
			if(!$("#emotion").is(":animated") && !$("#emotion").is(":visible")){
				
				$("#emotion").addClass("emoticon_"+msg);
				$("#emotion").addClass("emotion_on");
				$("#emotion").effect( "bounce", {times:5,distance:7}, 800, function(){
					$("#emotion").removeClass("emotion_on");
					$("#emotion").removeClass("emoticon_"+msg);
				});
			}
		}
		
	</script>
	
<body style="margin: 0px; overflow-y: hidden;" naver_screen_capture_injected="true">
<!-- wrap -->
<div class="wrap">
	<!-- top -->
	<div id="topbox" class="topbox tb_chat_list">
		<!--
		채팅, 리스트 둘다 있는 경우 tb_chat_list
		채팅만 있는 경우 tb_chat
		리스트, 즐찾만 있는 경우 tb_list
		리스트, 즐찾 둘다 없는 경우 tb_video
		-->
		<h1><a href="#" title="more모아tv" target="_blank"><img src="img/more_logo.jpg" alt="more모아tv"></a></h1>
		<div class="topmenu">
			<ul class="tm_ul">
			<!-- 로그인전 -->
			<li class="login"><a href="#" onclick=";"><span class="zh" data-translate="로그인">로그인</span></a></li>
			<!-- //로그인전 -->
			<!-- 로그인후 -->
			<li id="topmenu_name" class="name" style="display:none;"><a href="#" onclick=";"></a></li>
			<!-- //로그인후 -->
			<li id="topmenu_chat" class="chat"><a href="#" onclick=";" class="on">채팅창</a></li>
			<li id="topmenu_airlist" class="airlist"><a href="#" onclick=";" class="on">방송리스트</a></li>
			<li id="topmenu_fav" class="fav"><a href="#" onclick=";" class="off">즐겨찾기</a></li>
			<li id="topmenu_search" class="search">
				<input type="text" title="검색어" id="szKeyword" value="" class="input_text" maxlength="20" size="20">
				<a href="#" onclick=";" class="btn_search">검색하기</a>
			</li>
			</ul>
		</div>
	</div>
	<!-- //top -->
	<!-- contbox -->
	<div id="contbox" class="contbox cb_chat_list">
		<!--
		채팅, 리스트 둘다 있는 경우 cb_chat_list
		채팅만 있는 경우 cb_chat
		리스트, 즐찾만 있는 경우 cb_list
		리스트, 즐찾 둘다 없는 경우 cb_video
		-->
		<!-- videobox -->
		<div class="videobox">
			<!-- 영상소스 -->
			<div class="embed">
				<div class="embed_in">
					<video width="100%" controls autoplay loop>
					  <source src="/video/malnyun.mp4" type="video/mp4">
					</video>
					
					<!-- <object id="livePlayer" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%">
						<param name="movie" value="http://update.afreeca.com:8134/PLAYER/LivePlayer.swf">
						<param name="allowscriptaccess" value="always">
						<param name="allowfullscreen" value="true">
						<param name="allowNetworking" value="all">
						<param name="wmode" value="transparent">
						<param name="flashvars" value="s=landing&amp;interface=_interface.callScript&amp;id=bubbledia&amp;no=170495247&amp;lang=">
						[if !IE]>
						<embed width="100%" height="100%" src="http://www.youtube.com/v/oaxUPPdXkaI" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true"></embed>
						<![endif]
					</object> -->

					<!-- 스크린 모드 종료 -->
					<div class="smode_exit"><a href="#" onclick=";">스크린 모드 종료</a></div>
					<!-- //스크린 모드 종료 -->
					<!-- 채팅창 열기 -->
					<div class="smode_chatbtn"><a href="#" onclick=";">채팅창 열기</a></div>
					<!-- //채팅창 열기 -->
				</div>
			</div>
			<!-- //영상소스 -->

			<!-- 스크린모드 시청 2015-11-10 수정 -->
			<div class="btn_player_wrap">
				<div class="btn_smode"><a href="#" onclick=";">스크린모드</a></div>
				<div class="btn_smode_tip">
					<em>스크린모드는 전체화면으로 방송 시청과 <span class="br">채팅 관전을 편하게 할 수 있는 모드입니다.</span><span class="ttip_sam"></span></em>
				</div>
			</div>
			<!-- //스크린모드 시청 -->

			<!-- airinfo -->
			<div id="airinfo" class="airinfo">
				<!-- 탭 -->
				<div class="tab">
					<ul>
					<li class="li1"><a href="#" onclick=";" class="on"><span class="zh" data-translate="방송정보">방송정보</span></a></li><!-- 활성화 시 on 추가 -->
					<li class="li2"><a href="#" onclick=";"><span class="zh" data-translate="방송공지">방송공지</span></a></li>
					<li class="li3"><a href="#" onclick=";"><span class="zh" data-translate="공유">공유<span></span></span></a></li>
					</ul>
				</div>
				<!-- //탭 -->
				<!-- 방송정보 -->
				<div id="broad_info" class="info">
					<div class="bjlogo">
						<img src="http://stimg.afreeca.com/LOGO/bu/bubbledia/bubbledia.jpg" onerror="this.src='http://www.afreeca.com/mybs/img/default_small_re.gif';" alt="BJ 로고" class="thum">
						<a href="http://www.afreeca.com/bubbledia" target="_blank" title="BJ 방송국으로 가기" class="btn">BJ 방송국</a>
						<span class="style"></span>
					</div>
					<dl class="bj">
					<dd class="name">버블디아</dd>
					<!--dt>방송 중이지 않습니다.</dt-->
					<dt>[연애특강] '라인'으로 여자친구 만들기[버블디아]</dt>
					<dd class="viewer">
						<em>
							<span data-translate="현재시청자수">현재 시청자수</span>
								<span class="more">
									<div class="more_pc">PC : <span class="n">126</span></div>
									<div class="more_m"><span data-translate="모바일">모바일</span> : <span class="n">327</span></div>
									<div class="more_j"><span data-translate="중계방">중계방</span> : <span class="n">0</span></div>
									<div class="more_all"><span data-translate="전체시청인원">전체시청인원</span> : <span class="n">453</span></div>
								</span>
							<span class="ttip_sam"></span>
						</em>
						<span class="count">453</span><!-- 숫자 -->
					</dd>
					<dd class="viewer_total">
						<em><span data-translate="누적시청자수">누적 시청자수</span><span class="ttip_sam"></span></em>
						<span class="count">956</span><!-- 숫자 -->
					</dd>
					<dd class="fav">
						<em><span data-translate="애청자수">애청자 수</span><span class="ttip_sam"></span></em>
						<span class="count">240,262</span><!-- 숫자 -->
					</dd>
					<dd class="detail">
						<a href="#" onclick=";" class="down"><span class="zh" data-translate="상세보기">상세보기</span></a>
					</dd>
					</dl>
					<!-- 상세보기내용 -->
					<div class="detail_view">
						<dl>
						<dt class="zh" data-translate="방송시작시간">방송시작시간</dt><dd>2016-02-24 03:08:43</dd>
						<dt class="zh" data-translate="해상도">해상도</dt><dd>1280X720</dd>
						<dt class="zh" data-translate="화질">화질</dt><dd>2000K</dd>
						<dt class="zh" data-translate="카테고리">카테고리</dt><dd data-translate="알수없음"><span data-translate="토크/캠방">토크/캠방</span></dd>
						<dt class="zh" data-translate="개인방송국">개인방송국</dt><dd><a href="http://www.afreeca.com/bubbledia" target="_blank">http://www.afreeca.com/bubbledia</a></dd>
						</dl>
					</div>
					<!-- //상세보기내용 -->
				</div>
				<!-- //방송정보 -->
				<!-- 방송공지 -->
				<div class="notice"><em class="tit" data-translate="등록된공지사항이없습니다">등록된 공지사항이 없습니다.</em></div>
				<!-- //방송공지 -->
				<!-- 공유 -->
				<div class="share">
					<ul class="ul">
					<li class="li1"><em class="tit" data-translate="페이지공유">페이지 공유</em>
						<input type="text" class="input_url" value="">
						<!-- 툴팁 -->
						<span class="ttip_url_copy" id="ttip_url_copy1" data-translate="URL을복사하세요">URL을 복사(Ctrl+C)하여 원하는 곳에 붙여넣기 (Ctrl+V) 하세요.</span>
						<!-- //툴팁 -->
					</li>
					<li class="li2"><em class="tit" data-translate="화면공유">화면 공유</em>
						<!-- 플레이어 크기 -->
						<div class="size">
							<em><span data-translate="화면크기">화면 크기</span></em>
							<div class="size_sel">
								<span class="selected"><a href="#" onclick=";">540X340</a></span>
								<div class="select_list">
									<ul>
									<li><a href="#" onclick=";" data-width="540" data-height="340">540X340</a></li>
									<li><a href="#" onclick=";" data-width="640" data-height="397">640X397</a></li>
									<li><a href="#" onclick=";" data-width="720" data-height="442">720X442</a></li>
									</ul>
								</div>
							</div>
						</div>
						<!-- //플레이어 크기 -->
						<div class="emss"><input type="text" value=""></div>
						<!-- 툴팁 -->
						<span class="ttip_url_copy" id="ttip_url_copy2" data-translate="URL을복사하세요">URL을 복사(Ctrl+C)하여 원하는 곳에 붙여넣기 (Ctrl+V) 하세요.</span>
						<!-- //툴팁 -->
					</li>
					<li class="li3"><em class="tit" data-translate="SNS공유">SNS 공유</em>
						<span class="btn_sns_twitter"><a href="#" onclick=";" title="트위터에 공유하기">트위터</a></span>
						<span class="btn_sns_fb"><a href="#" onclick=";" title="페이스북에 공유하기">페이스북</a></span>
					</li>
					</ul>
				</div>
				<!-- //공유 -->
			</div>
			<!-- //airinfo -->
			<!-- BJ의동영상 -->
			<div class="bj_vod">
				<h2><em>버블디아</em><span class="zh" data-translate="의동영상">의 동영상</span></h2>
				<ul><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33717889&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160223_ee27bdaf_170479999_4_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">04:24:56</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33717889&amp;szSkin=" target="_blank" title="[연애특강] '라인'으로 여자친구 만들기[버블디아]">[연애특강] '라인'으로 여자친구 만들기[버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">489</dd>		<dt>추천수</dt><dd class="dd2">6</dd>		<dt>댓글수</dt><dd class="dd3">1</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33704332&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160223_2ff3178f_170423574_11_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">19:36:35</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33704332&amp;szSkin=" target="_blank" title="<♥핵공감쇼♥>남녀가 혼자있을때...쉿♥![버블디아]">&lt;♥핵공감쇼♥&gt;남녀가 혼자있을때...쉿♥![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">127</dd>		<dt>추천수</dt><dd class="dd2">1</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33670857&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160222_80c5ab57_170407805_3_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">04:25:51</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33670857&amp;szSkin=" target="_blank" title="<♥핵공감쇼♥>남녀가 혼자있을때...쉿♥![버블디아]">&lt;♥핵공감쇼♥&gt;남녀가 혼자있을때...쉿♥![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">400</dd>		<dt>추천수</dt><dd class="dd2">11</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33657070&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160221_fdc87a91_170284443_23_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">43:00:48</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33657070&amp;szSkin=" target="_blank" title="오늘 놀자!!! 썰도풀고, 노래도 하고![버블디아]">오늘 놀자!!! 썰도풀고, 노래도 하고![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">111</dd>		<dt>추천수</dt><dd class="dd2">0</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33580356&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160220_124c27ee_170266303_3_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">04:47:31</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33580356&amp;szSkin=" target="_blank" title="오늘 놀자!!! 썰도풀고, 노래도 하고![버블디아]">오늘 놀자!!! 썰도풀고, 노래도 하고![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">422</dd>		<dt>추천수</dt><dd class="dd2">10</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33566273&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160220_ef6a17ba_170209351_11_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">20:18:47</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33566273&amp;szSkin=" target="_blank" title="버블디아 재즈 콘서트 티켓 쟁탈전~![버블디아]">버블디아 재즈 콘서트 티켓 쟁탈전~![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">157</dd>		<dt>추천수</dt><dd class="dd2">1</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33531550&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160219_06a49e7b_170194191_3_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">03:33:28</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33531550&amp;szSkin=" target="_blank" title="버블디아 재즈 콘서트 티켓 쟁탈전~![버블디아]">버블디아 재즈 콘서트 티켓 쟁탈전~![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">269</dd>		<dt>추천수</dt><dd class="dd2">9</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33519738&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160219_4ce6883b_170134166_10_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">18:50:25</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33519738&amp;szSkin=" target="_blank" title="[발성] 시청자 '노래 한달 퀵뷰'!!![버블디아]">[발성] 시청자 '노래 한달 퀵뷰'!!![버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">227</dd>		<dt>추천수</dt><dd class="dd2">0</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33504763&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160217_df9eda35_170004796_6_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">08:31:49</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33504763&amp;szSkin=" target="_blank" title="노래방에서 '악' 쓰는 노래TOP20[버블디아]">노래방에서 '악' 쓰는 노래TOP20[버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">341</dd>		<dt>추천수</dt><dd class="dd2">5</dd>		<dt>댓글수</dt><dd class="dd3">0</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33472082&amp;szSkin=" target="_blank">		<img src="http://videoimg.afreeca.com/php/SnapshotLoad.php?rowKey=20160218_54c96f3b_170114375_3_r" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">04:46:34</em>			<em class="icon_review">다시보기</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=33472082&amp;szSkin=" target="_blank" title="[발성] 시청장 전데 퀵뷰 '한달치' 배틀[버블디아]">[발성] 시청장 전데 퀵뷰 '한달치' 배틀[버블디아]</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">436</dd>		<dt>추천수</dt><dd class="dd2">22</dd>		<dt>댓글수</dt><dd class="dd3">3</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24295179&amp;szSkin=" target="_blank">		<img src="http://iflv12.afreeca.com/AFFLV/00/7/7/12_00_1432557915959361_2147483647.jpg" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">00:26</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24295179&amp;szSkin=" target="_blank" title="재덩님의 장구실력~">재덩님의 장구실력~</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">1,640</dd>		<dt>추천수</dt><dd class="dd2">5</dd>		<dt>댓글수</dt><dd class="dd3">5</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24295139&amp;szSkin=" target="_blank">		<img src="http://iflv13.afreeca.com/AFFLV/03/7/56/13_03_1432557873671913_2147483647.jpg" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">01:14</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24295139&amp;szSkin=" target="_blank" title="우리가 수타킹을 실제로 보다!!!!!!!!">우리가 수타킹을 실제로 보다!!!!!!!!</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">1,392</dd>		<dt>추천수</dt><dd class="dd2">7</dd>		<dt>댓글수</dt><dd class="dd3">2</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24288493&amp;szSkin=" target="_blank">		<img src="http://iflv12.afreeca.com/AFFLV/03/7/12/12_03_1432548328104831_2147483647.jpg" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">02:21</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24288493&amp;szSkin=" target="_blank" title="어색이라는 단어는 우리에게는 없었다.">어색이라는 단어는 우리에게는 없었다.</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">1,713</dd>		<dt>추천수</dt><dd class="dd2">8</dd>		<dt>댓글수</dt><dd class="dd3">6</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24286813&amp;szSkin=" target="_blank">		<img src="http://iflv13.afreeca.com/AFFLV/00/7/36/13_00_1432545938276010_2147483647.jpg" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">00:51</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24286813&amp;szSkin=" target="_blank" title="캬!!!!!!! 나의 사랑 너의 사랑 라키아~">캬!!!!!!! 나의 사랑 너의 사랑 라키아~</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">913</dd>		<dt>추천수</dt><dd class="dd2">6</dd>		<dt>댓글수</dt><dd class="dd3">7</dd>	</dl></li><li>	<span class="sshot"><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24286550&amp;szSkin=" target="_blank">		<img src="http://iflv13.afreeca.com/AFFLV/00/7/21/13_00_1432545545077490_2147483647.jpg" onerror="this.src='http://www.afreeca.com/images/afmain/img_thumb_defalut.jpg';" alt="영상스샷"></a>			<em class="time">00:10</em>	</span>	<dl class="info">		<dt><a href="http://live.afreeca.com:8079/app/index.cgi?szType=read_ucc_bbs&amp;szBjId=bubbledia&amp;nStationNo=13365668&amp;nTitleNo=24286550&amp;szSkin=" target="_blank" title="팡이팡이 ㅋㅋ 귀여운 팡이팡이">팡이팡이 ㅋㅋ 귀여운 팡이팡이</a></dt>		<dd><a href="#" onclick=";" user_id="bubbledia">버블디아</a></dd>	</dl>	<dl class="eabox">		<dt>시청수</dt><dd class="dd1">791</dd>		<dt>추천수</dt><dd class="dd2">5</dd>		<dt>댓글수</dt><dd class="dd3">10</dd>	</dl></li></ul>
			</div>
			<!-- //BJ의동영상 -->
		</div>
		<!-- //videobox -->

		<!-- chatbox -->
		<div id="chatbox" class="chatbox">
			<h2><span class="zh" data-translate="채팅">모아 채팅</span></h2>
			
			<span class="btn_org" style="padding-left:24px;font-weight:bold;letter-spacing:normal;background:none"><span data-translate="중계자 모드">| 중계자 모드</span></span>
			<!-- setbox -->
			<div class="setbox">
				<!-- 버튼들 -->
				<ul id="btnset" class="btnset">
				<li id="setbox_mchat" class="mchat" style="display:none;">
					<a href="#" onclick=";" class="off">매니저 채팅</a><em class="ttip">매니저 채팅<span></span></em>
				</li>
				<li id="setbox_ice" class="ice" style="display:none;">
					<a href="#" onclick=";" class="freeze">얼리기</a>
					<em class="ttip">얼리기<span></span></em>
				</li>
				<li id="setbox_viewer" class="viewer">
					<a href="#" onclick=";" class="off">채팅참여인원</a><em class="ttip"><em data-translate="채팅참여인원">채팅참여인원</em><span></span></em>
				</li><!-- 활성화  class="on" 추가 -->
				<li id="setbox_set" class="set">
					<a href="#" onclick=";" class="off">설정</a><em class="ttip"><em data-translate="설정">설정</em><span></span></em>
				</li>
				<li id="setbox_close" class="close">
					<a href="#" onclick=";">채팅영역 숨기기</a><em class="ttip"><em data-translate="채팅영역숨기기">채팅영역 숨기기</em><span></span></em>
				</li>
				</ul>
				<!-- //버튼들 -->
			</div>
			<!-- //setbox -->

			<!-- idsearch 2015-07-31 추가 -->
			<div id="idsearch" class="idsearch" style="display:none;">
				<input type="text" id="searchId" class="input_text" title="아이디" placeholder="아이디">
				<!-- SORT -->
				<div class="sel"><!-- 1개나 첫번째엔 first 추가 -->
					<em><a href="#" onclick=";" id="selChatOpt">채팅금지</a></em>
					<ul id="selChatOptList" style="display: none;">
					<li><a href="#" onclick=";">채팅금지</a></li>
					<li><a href="#" onclick=";">강제퇴장</a></li>
					</ul>
				</div>
				<!-- //SORT -->
				<a id="applyChatOpt" href="#" onclick=";" class="btn_apply">적용</a>
			</div>
			<!-- //idsearch -->

			<!-- actionbox -->
			<div id="actionbox" class="actionbox">
				<!-- 버튼들 -->
				<ul id="ul1" class="ul1">
				<li id="btn_emo" class="emo first"><a href="#" onclick=";" class="">이모티콘<span class="emo_new"></span></a><em class="ttip" data-translate="이모티콘">이모티콘<span></span></em></li><!-- 활성화  class="on" 추가 -->
				<li id="btn_police" class="police"><a href="#" onclick=";">신고</a><em class="ttip" data-translate="신고">신고<span></span></em></li>
				</ul>
				<ul id="ul2" class="ul2">
				<li id="btn_hope" class="hope" style="display:none;"><a href="#" onclick=";" data-translate="희망풍선선물하기">희망풍선 선물하기</a><em class="ttip">희망풍선 선물하기<span></span></em></li>
				<li id="btn_star" class="star"><a href="#" onclick=";">별풍선 선물하기</a><em class="ttip" data-translate="별풍선선물하기">별풍선 선물하기<span></span></em></li>
				<li id="btn_sticker" class="sticker"><a href="#" onclick=";">스티커 선물하기</a><em class="ttip" data-translate="스티커선물하기">스티커 선물하기<span></span></em></li>
				<li id="btn_choco" class="choco"><a href="#" onclick=";">초콜릿  선물하기</a><em class="ttip" data-translate="초콜릿선물하기">초콜릿 선물하기<span></span></em></li>
				</ul>
				<!-- //버튼들 -->
				<!-- chat_write -->
				<div id="chat_write" class="chat_write">
					<h3>채팅쓰기</h3>
					<textarea id="write_area" class="write_area"></textarea>
					<button type="button" id="btn_send" class="btn_send" title="보내기"><span class="zh" data-translate="보내기">보내기</span></button>

				</div>
				<!-- //chat_write -->
			</div>
			<!-- //actionbox -->

			<!-- 레이어_이모티콘 2015-09-07 추가 -->
			<div id="emoticonArea">
				<div id="emoticonBox">
					<h1><span data-translate="이모티콘">이모티콘</span></h1>
					<div class="scroll_area">
						<!--
								1. 프로야구 이모티콘 항상 맨뒤 노출
								2. 기본 이모티콘 /images/chat/emoticon/small/1~92.png
								3. 프로야구 전용 이모티콘 /images/chat/emoticon/small/baseball/1~23.png
								4. 채팅시 나오는 기본 이모티콘 /images/chat/emoticon/large/1~92.png
								5. 채팅시 나오는 프로야구 전용 이모티콘 images/chat/emoticon/large/baseball/1~23.png

						-->
					</div>
					<div class="btn_close"><a href="#" onclick=";" title="닫기">닫기</a></div>
				</div>
			</div>
			<!-- //레이어_이모티콘 -->

			<div id="chat_area" class="chat_area">
				<div id="chat_area_more" class="chat_memoyo">
					<!-- <dl class="notice_gamble">	<dt>More모아TV 기본 채팅 매너</dt>	<dd>		<div class="box"><span class="ic_arw_blue"></span>따뜻한 소통과 배려로 더욱 즐거운 More모아TV를 만들어주세요!  특정인에 대한 비방과 비하, 인종/지역/성/장애인 차별, 청소년 보호법 위반, 정치 선동성 채팅은 제재의 대상이 됩니다.	</div>	</dd></dl> -->
					
				</div>
				
			</div>
			
			<div id="emotion" class="emoticon_area"></div>
			<!-- //chat_area -->
		</div>
		<!-- //chatbox -->
		
		<!-- chatbox2 -->
		<div id="chatbox2" class="chatbox">
			<h2><span class="zh" data-translate="채팅">기본 채팅</span></h2>
			<span class="btn_org" style="padding-left:24px;font-weight:bold;letter-spacing:normal;background:none"><span data-translate="중계자 모드">| 사용자 모드</span></span>
			<!-- setbox -->
			<div class="setbox">
				<!-- 버튼들 -->
				<ul id="btnset2" class="btnset">
				<li id="setbox_mchat2" class="mchat" style="display:none;">
					<a href="#" onclick=";" class="off">매니저 채팅</a><em class="ttip">매니저 채팅<span></span></em>
				</li>
				<li id="setbox_ice2" class="ice" style="display:none;">
					<a href="#" onclick=";" class="freeze">얼리기</a>
					<em class="ttip">얼리기<span></span></em>
				</li>
				<li id="setbox_viewer2" class="viewer">
					<a href="#" onclick=";" class="off">채팅참여인원</a><em class="ttip"><em data-translate="채팅참여인원">채팅참여인원</em><span></span></em>
				</li><!-- 활성화  class="on" 추가 -->
				<li id="setbox_set2" class="set">
					<a href="#" onclick=";" class="off">설정</a><em class="ttip"><em data-translate="설정">설정</em><span></span></em>
				</li>
				<li id="setbox_close2" class="close">
					<a href="#" onclick=";">채팅영역 숨기기</a><em class="ttip"><em data-translate="채팅영역숨기기">채팅영역 숨기기</em><span></span></em>
				</li>
				</ul>
				<!-- //버튼들 -->
			</div>
			<!-- //setbox -->

			<!-- idsearch 2015-07-31 추가 -->
			<div id="idsearch2" class="idsearch" style="display:none;">
				<input type="text" id="searchId2" class="input_text" title="아이디" placeholder="아이디">
				<!-- SORT -->
				<div class="sel"><!-- 1개나 첫번째엔 first 추가 -->
					<em><a href="#" onclick=";" id="selChatOpt2">채팅금지</a></em>
					<ul id="selChatOptList2" style="display: none;">
					<li><a href="#" onclick=";">채팅금지</a></li>
					<li><a href="#" onclick=";">강제퇴장</a></li>
					</ul>
				</div>
				<!-- //SORT -->
				<a id="applyChatOpt2" href="#" onclick=";" class="btn_apply">적용</a>
			</div>
			<!-- //idsearch -->

			<!-- actionbox -->
			<!-- <div id="actionbox2" class="actionbox">
				<ul id="ul12" class="ul1">
				<li id="btn_emo2" class="emo first"><a href="#" onclick=";" class="">이모티콘<span class="emo_new"></span></a><em class="ttip" data-translate="이모티콘">이모티콘<span></span></em></li>활성화  class="on" 추가
				<li id="btn_police2" class="police"><a href="#" onclick=";">신고</a><em class="ttip" data-translate="신고">신고<span></span></em></li>
				</ul>
				<ul id="ul22" class="ul2">
				<li id="btn_hope2" class="hope" style="display:none;"><a href="#" onclick=";" data-translate="희망풍선선물하기">희망풍선 선물하기</a><em class="ttip">희망풍선 선물하기<span></span></em></li>
				<li id="btn_star2" class="star"><a href="#" onclick=";">별풍선 선물하기</a><em class="ttip" data-translate="별풍선선물하기">별풍선 선물하기<span></span></em></li>
				<li id="btn_sticker2" class="sticker"><a href="#" onclick=";">스티커 선물하기</a><em class="ttip" data-translate="스티커선물하기">스티커 선물하기<span></span></em></li>
				<li id="btn_choco2" class="choco"><a href="#" onclick=";">초콜릿  선물하기</a><em class="ttip" data-translate="초콜릿선물하기">초콜릿 선물하기<span></span></em></li>
				</ul>
				//버튼들
				chat_write
				<div id="chat_write2" class="chat_write">
					<h3>채팅쓰기</h3>
					<div id="write_area2" class="write_area" contenteditable="true" ondragenter="return false;" ondrop="return false;" ondragover="return false;"></div>
					<button type="button" id="btn_send2" class="btn_send" title="보내기"><span class="zh" data-translate="보내기">보내기</span></button>

				</div>
			</div> -->
			<!-- //actionbox -->

			<div id="chat_area2" class="chat_area">
				<div id="chat_area_user" class="chat_memoyo">
					
				</div>
			</div>
			<!-- //chat_area -->
		</div>
		<!-- //chatbox2 -->

		<!-- chatbox3 -->
		<div id="chatbox3" class="chatbox">
			<h2><span class="zh" data-translate="채팅">검색</span></h2>
			
			<!-- setbox -->
			<div class="setbox">
				<!-- 버튼들 -->
				<ul id="btnset3" class="btnset">
				
				<li id="setbox_close3" class="close">
					<a href="#" onclick=";">채팅영역 숨기기</a><em class="ttip"><em data-translate="채팅영역숨기기">채팅영역 숨기기</em><span></span></em>
				</li>
				</ul>
				<!-- //버튼들 -->
			</div>
			<!-- //setbox -->
			<div class="search_wrap">
				<div class="search_tag">
					<input type="text" title="검색어" value="#" id="tagKey" class="search_input" maxlength="40">
					<a href="#" id="tagCancel" class="btn_cancel">x</a>
					<a href="#" id="tagSearch" class="btn_search"><span style="display:none;">검색</span></a>
				</div>
			</div>
			<div id="chat_area3" class="chat_area">
				<div id="chat_area_search" class="chat_memoyo">
				</div>
			</div>
			<!-- //chat_area -->
		</div>
		<!-- //chatbox3 -->
	</div>
	<!-- //contbox -->
</div>
<!-- //wrap -->

<!-- 레이어_라이트박스용_검정배경 -->
<!-- <div class="bg_dark"></div> -->
</body><audio src="" id="naver_dic_audio_controller" controls="controls" style="width: 0px; height: 0px;"></audio>
</html>