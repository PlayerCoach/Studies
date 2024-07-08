package org.example;
import java.io.*;
import java.net.Socket;
import java.util.Scanner;

public class Client
{
    private Socket socket;

    private ObjectOutputStream out;// used to send messages to client (sever(ClientHandler) -> client)
    private ObjectInputStream in; // used to read messages from client (client -> server)
    private int counterOfRequests = 0;



    public Client(Socket socket)
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

    public void sendMessage()
    {

        try
        {

            Scanner scanner = new Scanner(System.in);

            while(socket.isConnected())
            {
                Message messageNumberOfRequests = new Message();
                String numberOfRequests = scanner.nextLine();
                messageNumberOfRequests.setContent(numberOfRequests);
                increaseCounter();
                messageNumberOfRequests.setNumber(getCounter());
                out.writeObject(messageNumberOfRequests);
                out.flush();

                for(int i = 0; i<Integer.parseInt(numberOfRequests); i++)
                {
                    Message messagePhrase = new Message();
                    String m = scanner.nextLine();
                    messagePhrase.setContent(m);
                    increaseCounter();
                    messagePhrase.setNumber(getCounter());
                    out.writeObject(messagePhrase);
                    out.flush();
                }

            }
        }
        catch(IOException e)
        {
            close();
        }

    }

    public void listenForMessages()
    {
        new Thread(() -> {
            try
            {
                while(socket.isConnected())
                {
                    Message message = (Message) in.readObject();
                    System.out.println("Server: " + message.getContent());
                }
            }
            catch(IOException | ClassNotFoundException e)
            {
                close();
            }
        }).start();
    }

    private void close()
    {
        try
        {
            socket.close();
            in.close();
            out.close();
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
    }

    private void increaseCounter()
    {
        counterOfRequests++;
    }

    private int getCounter()
    {
        return counterOfRequests;
    }

    public static void main(String[] args) throws IOException
    {

        Socket socket = new Socket("localhost", 6666);
        Client client = new Client(socket);
        client.listenForMessages();
        client.sendMessage();

    }



}

