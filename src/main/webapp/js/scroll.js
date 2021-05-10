$(document).ready(function(){
	scrollEvent();
});

function scrollEvent(){
	$( window ).scroll(function() {
		$("#scrollEvent").text("Scroll Event!").show().fadeOut( "slow" );
  		var winPosY = $(window).scrollTop(); // 받을 스크롤 Y 위치 값
  		var winPosX = $(window).scrollLeft(); // 받을 스크롤 X 위치 값
  		$("#scrollPosY").val(winPosY);
  		$("#scrollPosX").val(winPosX);
	});
}

function scrollPosYadd(){
	var winPos = $(window).scrollTop();
	$(window).scrollTop(winPos+10); // 넘겨줄 스크롤 Y 위치 값 (+10제거)
}

function scrollPosYminus(){
	var winPos = $(window).scrollTop();
	$(window).scrollTop(winPos-10); 
}

function scrollPosXadd(){
	var winPos = $(window).scrollLeft();
	$(window).scrollLeft(winPos+10); // 넘겨줄 스크롤 X 위치 값 (+10제거)
}

function scrollPosXminus(){
	var winPos = $(window).scrollLeft();
	$(window).scrollLeft(winPos-10);
}

function getYPosition(){
	var y = $(window).scrollTop();
	return y;
}

function setYPosition(yPosition){
	$("#scrollPosY").val(yPosition);
	$(window).scrollTop(yPosition);
}