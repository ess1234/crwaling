package socket;

import org.springframework.beans.factory.annotation.Autowired;
import org.vertx.java.core.Handler;
import org.vertx.java.core.Vertx;
import org.vertx.java.core.http.HttpServer;
import org.vertx.java.core.json.JsonObject;

import com.nhncorp.mods.socket.io.SocketIOServer;
import com.nhncorp.mods.socket.io.SocketIOSocket;
import com.nhncorp.mods.socket.io.impl.DefaultSocketIOServer;
import com.nhncorp.mods.socket.io.spring.DefaultEmbeddableVerticle;

import merge.Spell;

public class ChatServer extends DefaultEmbeddableVerticle {
	
	@Autowired
	Spell spell;

	private static SocketIOServer io = null;
	private static SocketIOServer io2 = null;

	public void start(Vertx vertx) {
		// 사용자 통신
		HttpServer server = vertx.createHttpServer();
		io = new DefaultSocketIOServer(vertx, server);
		io.sockets().onConnection(new Handler<SocketIOSocket>() {
			public void handle(final SocketIOSocket socket) {
				socket.on("msg", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						System.out.println("msg ::: " + event.getString("msg"));
						io.sockets().emit("msg", event);
					}
				});
			}
		});
		server.listen(12346);
	}

}
