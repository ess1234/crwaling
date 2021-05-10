package socket;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.vertx.java.core.Handler;
import org.vertx.java.core.Vertx;
import org.vertx.java.core.http.HttpServer;
import org.vertx.java.core.json.JsonObject;

import com.nhncorp.mods.socket.io.SocketIOServer;
import com.nhncorp.mods.socket.io.SocketIOSocket;
import com.nhncorp.mods.socket.io.impl.DefaultSocketIOServer;
import com.nhncorp.mods.socket.io.spring.DefaultEmbeddableVerticle;

import merge.RealTime;
import merge.ReservedWord;
import merge.Spell;

public class MoreChatServer extends DefaultEmbeddableVerticle {
	
	@Autowired
	Spell spell;
	
	@Autowired
	RealTime realTime;
	
	@Autowired
	ReservedWord reservedWord;

	private static SocketIOServer io = null;
	private static HashMap<String, String> users = new HashMap<String, String>();
	private static int userSeq = 1;

	public void start(Vertx vertx) {
		
		users.put("10.67.69.56", "봄대식가");
		users.put("10.83.28.242", "A율B남편은출장중");
		users.put("10.67.21.241", "김부장아직20대");
		users.put("10.83.28.90", "신빙구");
		users.put("10.67.21.240", "Oh!3개월지각상");

		HttpServer server = vertx.createHttpServer();
		io = new DefaultSocketIOServer(vertx, server);
		io.sockets().onConnection(new Handler<SocketIOSocket>() {
			public void handle(final SocketIOSocket socket) {
				socket.on("msg", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String msg = event.getString("msg");
						String ip = event.getString("ip");						
						if(!users.containsKey(ip)) users.put(ip, "guest"+(userSeq++));
						String userName = users.get(ip);
						event.putString("userName", userName);						
						
						System.out.println("user : " +userName+"("+ ip+") ==> msg ::: " + msg);
						
						// 사용자  쳇창 보내기
						io.sockets().emit("msg", event);
						
						boolean sendOnot = true;
						JsonObject json = new JsonObject();

						// 철자축약
						// String result = spell.spellMerge(msg);
						String result = spell.wordMerge(msg);
						json.putString("msg", result);
						json.putString("ip", ip);
						json.putString("userName", userName);
						
						// 예약어검증	
						if(reservedWord.checkReservedLaughWord(result)) {
							io.sockets().emit("reserved", "laugh");
							sendOnot = false;
						}
						if(reservedWord.checkReservedSmileWord(result)) {
							io.sockets().emit("reserved", "smile");
							sendOnot = false;
						}
						if(reservedWord.checkReservedCryWord(result)) {
							io.sockets().emit("reserved", "cry");
							sendOnot = false;
						}
						if(reservedWord.checkReservedSurprisedWord(result)) {
							io.sockets().emit("reserved", "surprised");
							sendOnot = false;
						}
						if(reservedWord.checkReservedShakeWord(result)) {
							io.sockets().emit("reserved", "shake");
							sendOnot = false;
						}
						if(reservedWord.checkReservedOWord(result)) {
							io.sockets().emit("reserved", "O");
							sendOnot = false;
						}
						
						// 실시간 체크
						if(sendOnot) {
							@SuppressWarnings("unchecked")
							HashMap<String, Integer> rt = (HashMap<String, Integer>)realTime.offerSentence(result);
							
							if(rt.containsKey("seq") && !rt.get("seq").equals("")) json.putString("seq", rt.get("seq").toString());
							
							if(rt.containsKey("duplicate") && !rt.get("duplicate").equals("")){
								json.putString("seq", rt.get("duplicate").toString());								
								io.sockets().emit("realTime", json);
								sendOnot = false;
							}
						}
						
						// 운영자 쳇창 보내기
						if(sendOnot) io.sockets().emit("more", json);
						
						// 채팅방 리플래쉬
						if(msg.equals("LemonDtoks")){
							realTime.flush();
							io.sockets().emit("flush", "초기화");
							json.putString("msg", "관리자가 방을 초기화 하였습니다.");
							io.sockets().emit("msg", json);
							io.sockets().emit("more", json);
						}
						
					}
				});
			}
		});
		server.listen(8081);
	}

}
