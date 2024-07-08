using System.Globalization;
using System.Xml;

namespace LINQ_Ex
{
    public class Car
    {
        public string Model { get; private set;}
        public Engine Motor { get; private set; }
        public int Year { get; private set; }
        
        public Car()
        {
            
            Model = string.Empty;
            Motor = new Engine(); 
            Year = 0;
        }

        public Car(string model, Engine engine, int year)
        {
            Model = model;
            Motor = engine;
            Year = year;
        }
        
        public void WriteXml(XmlWriter writer)
        {
            writer.WriteStartElement("car");
            writer.WriteElementString("model", Model);
            writer.WriteElementString("year", Year.ToString());
            writer.WriteStartElement("Engine");
            writer.WriteAttributeString("model", Motor.Model);
            writer.WriteElementString("displacement", Motor.Displacement.ToString(CultureInfo.InvariantCulture));
            writer.WriteElementString("horsepower", Motor.Horsepower.ToString(CultureInfo.InvariantCulture));
            writer.WriteEndElement();
            writer.WriteEndElement();
            
        }

        public void ReadXml(XmlReader reader)
        {
            reader.MoveToContent();
            if (reader.IsStartElement("car"))
            {
                reader.ReadStartElement("car");
                reader.MoveToContent();
                Model = reader.ReadElementContentAsString();
                reader.MoveToContent();
                Year = reader.ReadElementContentAsInt();
                reader.ReadToFollowing("Engine"); 
                Motor = new Engine();
                Motor.Model = reader.GetAttribute("model"); 
                reader.ReadToFollowing("displacement");
                Motor.Displacement = reader.ReadElementContentAsDouble();
                reader.ReadToFollowing("horsepower");
                Motor.Horsepower = reader.ReadElementContentAsDouble();
                reader.ReadEndElement(); 
                reader.ReadEndElement(); 
            }
        }



    }
}