using System;
using System.Net.Sockets;
using System.Text.Json;
using System.Text;
using System.Threading;
using Lab12Client;

string serverIp = "127.0.0.1";
int serverPort = 5000;
string quitCommand = "quit";

try
{
    TcpClient client = new TcpClient(serverIp, serverPort);
    if (!client.Connected)
    {
        Console.WriteLine("Failed to connect to the server.");
        return;
    }
    Console.WriteLine("Connected to the server...");
    Console.WriteLine("Choose a username: ");
    string userName = Console.ReadLine();

    NetworkStream stream = client.GetStream();

    Thread thread = new Thread(() => ReceiveData(client, stream));
    thread.Start();

    while (true)
    {
        SerializableObject obj = new SerializableObject
        {
            UserName = userName,
            IntegerField = new Random().Next(1, 100),
            StringField = Console.ReadLine()

        };
        if (obj.StringField.ToLower() == quitCommand)
        {
            Console.WriteLine("Disconnecting from the server...");
            break;
        }


        string json = JsonSerializer.Serialize(obj);
        byte[] data = Encoding.UTF8.GetBytes(json);
        stream.Write(data, 0, data.Length);
        Console.WriteLine($"Sent: {obj}");
        Thread.Sleep(2000);
    }
}
catch (Exception ex)
{
    Console.WriteLine($"Client error: {ex.Message}");
}

void ReceiveData(TcpClient client, NetworkStream stream)
{
    try
    {
        while (client.Connected)
        {
            byte[] buffer = new byte[1024];
            int bytesRead = stream.Read(buffer, 0, buffer.Length);
            string json = Encoding.UTF8.GetString(buffer, 0, bytesRead);
            var receivedObject = JsonSerializer.Deserialize<SerializableObject>(json);
            Console.WriteLine($"Received from server modified object: {receivedObject}");
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Receive error: {ex.Message}");
    }
}

namespace Lab12Client
{
    public class SerializableObject
    {
        public int IntegerField { get; set; }
        public string StringField { get; set; }

        public string UserName { get; set; }  


        public override string ToString()
        {
            return $"IntegerField: {IntegerField}, StringField: {StringField}";
        }
    }
}
