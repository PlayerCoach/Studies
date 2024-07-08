#include "Vector.h"
#include <chrono>
#include <iostream>
#include "PriorityQueue.h"
#include "MapHandler.h"
#include "String.h"


using namespace std;

int main()
{
    int width, height,airplanes,inquiries;
    cin >> width;
    cin >> height;
    getchar();
    MapHandler maphandler(width,height);
    maphandler.Load_map();
    maphandler.Find_cities();
    maphandler.Create_AdjacencyList();
    cin >> airplanes;
    getchar();
    maphandler.Load_planes(airplanes);
    cin >> inquiries;
    getchar();
    maphandler.Load_inquiries(inquiries);
   
   



     return 0;
}
