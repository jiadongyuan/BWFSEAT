package com.boweifeng.cd.seat.websocket;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class SeatHandler extends TextWebSocketHandler {

    private static ConcurrentHashMap<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    public static synchronized void sendMessagesToAllClient(String message) throws IOException {
        for(WebSocketSession session : sessions.values()) {
            session.sendMessage(new TextMessage(message));
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("\nSeatHandler.afterConnectionEstablished【" + session.getRemoteAddress() + "】");
        System.out.println("session.getId() = " + session.getId());
        System.out.println("session.getAttributes() = " + session.getAttributes());
        sessions.put(session.getId(), session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        System.out.println("\nSeatHandler.afterConnectionClosed【" + session.getRemoteAddress() + "】");
        System.out.println("status = " + status);
        System.out.println("session.getId() = " + session.getId());
        System.out.println("session.getAttributes() = " + session.getAttributes());
        sessions.remove(session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        System.out.println("\nSeatHandler.handleTextMessage【" + session.getRemoteAddress() + "】");
        System.out.println("message = " + message.getPayload());
        for(String key : sessions.keySet()) {
            if(key.equals(session.getId())) {
                continue;
            }
            sessions.get(key).sendMessage(message);
        }
    }
}
