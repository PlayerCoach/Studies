// ReSharper disable All

using System.Runtime.InteropServices;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;
using System.Xml.XPath;

namespace LINQ_Ex;

internal abstract class Program
{
    private static void Main()
    {
        List<Car> myCars =
        [
            new Car("E250", new Engine(1.8, 204, "CGI"), 2009),
            new Car("E350", new Engine(3.5, 292, "CGI"), 2009),
            new Car("A6", new Engine(2.5, 187, "FSI"), 2012),
            new Car("A6", new Engine(2.8, 220, "FSI"), 2012),
            new Car("A6", new Engine(3.0, 295, "TFSI"), 2012),
            new Car("A6", new Engine(2.0, 175, "TDI"), 2011),
            new Car("A6", new Engine(3.0, 309, "TDI"), 2011),
            new Car("S6", new Engine(4.0, 414, "TFSI"), 2012),
            new Car("S8", new Engine(4.0, 513, "TFSI"), 2012)
        ];
        GroupCars(myCars);
        SerializeCars(myCars, "cars.xml");
        List<Car> deserializedCars = DeserializeCars("cars.xml");
        Console.WriteLine("Deserialized cars:");
        foreach (Car car in deserializedCars)
        {
            Console.WriteLine("Model: {0}, Year: {1}, Engine: {2}, Displacement: {3}, Horsepower: {4}",
                car.Model, car.Year, car.Motor.Model, car.Motor.Displacement, car.Motor.Horsepower);
        }
        CalculateAvgPowerOnXml("cars.xml");
        List<string> carModels = GetCarModels(deserializedCars);
        Console.Write("Car models: ");
        foreach (var carModel in carModels)
        {
            Console.Write(carModel + " ");
        }
        Console.WriteLine();
        createXmlFromLinq(myCars);
        CreateXhtmlFromLinq(myCars);
        ModifyXmlDocument();
        
        
      
        
            
    }

    public static void GroupCars(List<Car> cars)
    {
        var carProjections = cars
            .Where(car => car.Model == "A6")
            .Select(car => new
            {
                egineType = car.Motor.Model == "TDI" ? "diesel" : "petrol",
                hppl = car.Motor.Horsepower / car.Motor.Displacement
                
                
            });
        var carGrouppedByEngineType = carProjections
            .GroupBy(car => car.egineType)
            .Select(group => new
            {
                EngineType = group.Key,
                AverageHPPL = group.Average(car => car.hppl)
            });
        
        foreach (var carGroupped in carGrouppedByEngineType)
        {
            Console.WriteLine("Engine type: {0}, Average HP per liter: {1}", carGroupped.EngineType, carGroupped.AverageHPPL);
        }
    }

    static void SerializeCars(List<Car> cars, string filePath)
    {
        XmlWriterSettings settings = new XmlWriterSettings();
        settings.Indent = true;
        //settings.OmitXmlDeclaration = true;

        using (XmlWriter writer = XmlWriter.Create(filePath, settings))
        {
            writer.WriteStartElement("cars");
            foreach (var car in cars)
            {
                car.WriteXml(writer);
            }
            writer.WriteEndElement();
        }
    }

    static List<Car> DeserializeCars(string filePath)
    {
        List<Car> cars = new List<Car>();
        using (XmlReader reader = XmlReader.Create(filePath))
        {
            while (reader.Read())
            {
                if (reader.Name == "car")
                {
                    Car car = new Car();
                    car.ReadXml(reader);
                    cars.Add(car);
                }
            }
        }
        return cars;
    }

    static void CalculateAvgPowerOnXml(string path)
    {
        XElement rootNode = XElement.Load("cars.xml");
        double avgHP = (double) rootNode.XPathEvaluate("sum(//Engine[@model!='TDI']/horsepower) div count(//Engine[@model!='TDI']/horsepower)");
        Console.WriteLine("Average horsepower of non-diesel cars: {0}", avgHP);
    }
    
    static List<string> GetCarModels(List<Car> cars)
    {
        XElement rootNode = XElement.Load("cars.xml");
        return rootNode.XPathSelectElements("//model").Select(model => model.Value).Distinct().ToList();
       
    }

    static void createXmlFromLinq(List<Car> cars)
    {
        IEnumerable<XElement> nodes = 
            from car in cars
            select new XElement("car",
                new XElement("model", car.Model),
                new XElement("year", car.Year),
                new XElement("Engine", 
                    new XAttribute("model", car.Motor.Model),
                    new XElement("displacement", car.Motor.Displacement),
                    new XElement("horsepower", car.Motor.Horsepower)
                )
            );

        XElement rootNode = new XElement("cars", nodes);
        rootNode.Save("CarsFromLinq.xml");
    }

    static void CreateXhtmlFromLinq(List<Car> cars)
    {
        XDocument xhtmlDoc = XDocument.Load("template.html");
        XElement table = new XElement("table",
            new XElement("thead",
                new XElement("tr",
                    new XElement("th", "Model"),
                    new XElement("th", "Year"),
                    new XElement("th", "Engine Model"),
                    new XElement("th", "Displacement"),
                    new XElement("th", "Horsepower")
                )
            ),
            new XElement("tbody",
                from car in cars
                select new XElement("tr",
                    new XElement("td", car.Model),
                    new XElement("td", car.Year),
                    new XElement("td", car.Motor.Model),
                    new XElement("td", car.Motor.Displacement),
                    new XElement("td", car.Motor.Horsepower)
                )
            )
        );
        xhtmlDoc.Root?.Element("body")?.Add(table);
        xhtmlDoc.Save("carsHtml.html");
        
    }
    static void ModifyXmlDocument()
    {
        XDocument doc = XDocument.Load("cars.xml");
        
        foreach (XElement carElement in doc.Descendants("car"))
        {
            XElement? horsepowerElement = carElement.Element("Engine")?.Element("horsepower");
            if (horsepowerElement != null)
            {
                horsepowerElement.Name = "hp";
            }
            
            XElement? yearElement = carElement.Element("year");
            XElement? modelElement = carElement.Element("model");
            if (yearElement != null && modelElement != null)
            {
                modelElement.SetAttributeValue("year", yearElement.Value);
                yearElement.Remove();
            }
        }
        
        doc.Save("cars.xml");
    }
}