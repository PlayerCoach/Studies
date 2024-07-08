package org.example;
import java.io.*;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class ClientHandler implements Runnable
{

    private Socket socket; // passed from server class, establishes connection with server
    private ObjectOutputStream out;// used to send messages to client (sever(ClientHandler) -> client)
    private ObjectInputStream in; // used to read messages from client (client -> server)
    private static int serverResponses = 0;


    public ClientHandler(Socket socket) throws IOException
    {
        try
        {
            this.socket = socket;
            this.out = new ObjectOutputStream(socket.getOutputStream());
            this.in = new ObjectInputStream(socket.getInputStream());


        }
        catch(IOException e)
        {
            close();
        }

    }

    @Override
    public void run()
    {

        while(socket.isConnected())
        {

            try
            {   System.out.println("Waiting for number of messages");
                Message readyMessage = new Message();
                increaceServerResponses();
                readyMessage.setNumber(getServerResponses());
                readyMessage.setContent("Ready");
                out.writeObject(readyMessage);
                out.flush();
                Message numberMessage = (Message) in.readObject();
                try {

                    int numberOfMessages = Integer.parseInt(numberMessage.getContent());
                    Message receiveMessage = new Message();
                    increaceServerResponses();
                    receiveMessage.setNumber(getServerResponses());
                    receiveMessage.setContent("Ready to receive messages");
                    out.writeObject(receiveMessage);
                    out.flush();

                    System.out.println("Number of messages: " + numberOfMessages);

                    for(int i = 0; i<numberOfMessages; i++)
                    {
                        Message message = new Message();
                        message = (Message) in.readObject();
                        System.out.println("Message: " + message.getContent());
                    }
                    increaceServerResponses();
                    Message receivedMessage = new Message();
                    receivedMessage.setNumber(getServerResponses());
                    receivedMessage.setContent("All messages received");
                    System.out.println("All messages received -- " + numberMessage.getContent() + " messages");
                    out.writeObject(receivedMessage);
                    out.flush();

                } catch (NumberFormatException e)
                {
                    close();
                    break;
                }
            }
            catch(IOException e)
            {
                close();
                break;
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public void broadcastMessage(String message) throws IOException
    {
        System.out.println(message);

    }


    private void close()
    {
        try
        {
            in.close();
            out.close();
            socket.close();
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
    }

    private void increaceServerResponses()
    {
        serverResponses++;
    }
    private int getServerResponses()
    {
        return serverResponses;
    }

}




