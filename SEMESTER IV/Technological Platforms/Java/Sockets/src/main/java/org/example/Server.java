package org.example;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    private final ServerSocket serverSocket;


    public Server(ServerSocket socket) throws IOException {
        this.serverSocket = socket;
    }
    public void start() {
        try
        {

        while(!serverSocket.isClosed())
        {
            Socket clientSocket = serverSocket.accept();
            System.out.println("Client connected: " + clientSocket.getPort());
            ClientHandler clientHandler = new ClientHandler(clientSocket);

            Thread clientThread = new Thread(clientHandler);
            clientThread.start();
        }
        }catch(IOException e)
        {
            CloseAllConnections();
        }

    }
    private void CloseAllConnections()
    {
        try
        {
            serverSocket.close();
        }catch(IOException e)
        {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) throws IOException
    {
        ServerSocket serverSocket = new ServerSocket(6666);
        Server server = new Server(serverSocket);
        server.start();
    }
}