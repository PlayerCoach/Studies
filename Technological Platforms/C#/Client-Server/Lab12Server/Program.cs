using System;
using System.Net;
using System.Net.Sockets;
using System.Text.Json;
using System.Threading;
using System.Text;
using System.Threading.Tasks;

namespace Lab12Server
{
    class Program
    {
        private static TcpListener listener;
        private static bool isRunning = true;

        static void Main(string[] args)
        {
            listener = new TcpListener(IPAddress.Any, 5000);
            listener.Start();
            Console.WriteLine("Server started...");

            while (isRunning)
            {
                TcpClient client = listener.AcceptTcpClient();
                Console.WriteLine("Client connected...");
                Thread clientThread = new Thread(new ParameterizedThreadStart(HandleClient));
                clientThread.Start(client);

            }
        }

        private static void HandleClient(object clientObj)
        {
            TcpClient client = (TcpClient)clientObj;
            NetworkStream stream = client.GetStream();

            try
            {
                while (client.Connected)
                {
                    byte[] buffer = new byte[1024];
                    int bytesRead = stream.Read(buffer, 0, buffer.Length);
                    string json = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                    var receivedObject = JsonSerializer.Deserialize<SerializableObject>(json);
                    //unpack the object to extract the username
                    Console.WriteLine($"Received from : \"{receivedObject.UserName}\" : {receivedObject}");

                    // Increment the integer field
                    receivedObject.IntegerField++;

                    // Send the modified object back to the client
                    string responseJson = JsonSerializer.Serialize(receivedObject);
                    byte[] responseBuffer = Encoding.UTF8.GetBytes(responseJson);
                    stream.Write(responseBuffer, 0, responseBuffer.Length);
                    Console.WriteLine($"Sent: {receivedObject}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Client connection error: {ex.Message}");
            }
            finally
            {
                client.Close();
            }
        }
    }

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
