namespace LINQ_Ex
{
    public class Engine
    {
        public double Displacement { get;  set; }
        public double Horsepower { get;  set; }
        public string? Model { get;  set; }
        
        public Engine()
        {
            Displacement = 0.0;
            Horsepower = 0.0;
            Model = string.Empty;
        }
        
        public Engine(double displacement, double horsepower, string? model)
        {
            Displacement = displacement;
            Horsepower = horsepower;
            Model = model;
        }
    }
    
    
}