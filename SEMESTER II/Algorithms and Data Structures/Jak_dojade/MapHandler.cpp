#include "MapHandler.h"


MapHandler::MapHandler(const int width, const int height) :width(width), height(height) {}
void MapHandler::Load_map()
{
	char* buffer = new char[width + 3];
	for (int i = 0; i < height; i++)
	{
		fgets(buffer, width+2,stdin);
		map.PushBack(buffer);
	
	}
	delete[] buffer;

}

void MapHandler::Print_map()
{
	for (int i = 0; i < map.Size(); i++)
	{
		std::cout << map[i];
	}
	std::cout << std::endl;
}

void MapHandler::Find_cities()
{
	for (int y = 0; y < height; y++)
	{
		for (int x = 0; x < width; x++)
		{
			if (map[y][x] == '*')
				Find_city_name({ y,x });
		}
	}
	Create_hash_map();
}

void MapHandler::Find_city_name(const position_t& position)
{
	for (int i = -1; i <= 1; i++)
	{
		for (int j = -1; j <= 1; j++)
		{
			if ((j != 0 || i != 0) && Check_for_exception({position.y+i,position.x+j})==false && Check_for_map_symbols(map[position.y + i][position.x + j]) == false)
			{
				String name = Acquire_city_name(Get_furthest_letter({ position.y + i,position.x + j }));
				City city(position, name);
				cities.PushBack(city);
				return;
			}
		}
	}
}
String MapHandler::Acquire_city_name(const position_t& position)
{
	String name = "";
	name=name+map[position.y][position.x];
	int shift = 1;
		while (Check_for_exception({ position.y,position.x + shift }) == false && Check_for_map_symbols(map[position.y][position.x + shift]) == false && Check_for_exception({ position.y,position.x + shift }) == false)
		{
			name = name + map[position.y][position.x + shift];
			shift++;
		}
		return name;
	
}
bool MapHandler::Check_for_map_symbols(const char symbol) const
{
	if (symbol == '.' || symbol == '*' || symbol == '#')
		return true;
	else
		return false;
}
bool MapHandler::Is_road_or_city(const char symbol) const
{
	if (symbol == '*' || symbol == '#')
		return true;
	else
		return false;
}
bool MapHandler::Check_for_exception(const position_t& position)const
{
	if (position.x < width && position.y < height && position.x>=0 && position.y>=0)
		return false;
	else return true;
}
void MapHandler::Print_cities()
{
	for (int i = 0; i < cities.Size(); i++)
	{
		std::cout << cities[i] << std::endl;
	}
}
position_t MapHandler::Get_furthest_letter(const position_t position)
{
	int shift = 0;
	do
	{
		shift--;
	} while (Check_for_exception({ position.y,position.x + shift }) == false && Check_for_map_symbols(map[position.y][position.x + shift]) == false);

		return { position.y,position.x + shift+1 };
	
}
void MapHandler::Create_AdjacencyList()
{
	
	bool* visited = new bool[width * height];
	memset(visited, false, width * height);
	
	for (int i = 0; i < cities.Size(); i++)
	{
		if (i > 0 && AdjacencyList[i - 1].Size() > 0)
			memset(visited, false,width * height);
		BFS(cities[i].position,visited);
	}
	delete[] visited;
}


void MapHandler::BFS(const position_t& position,bool* visited)
{
	DoublyLinkedList<pair_t> queue;
	Vector<graph_t> neighbours;
	queue.PushBack({ { position.y,position.x},0 });
	visited[From_position_to_index({position.y,position.x })] = true;

	while (queue.GetSize() > 0)
	{
		pair_t current = queue.PopFront();
		/*if (current.position.x == 0 && current.position.y == 4)
			std::cout<<std::endl<< "AAAA" << std::endl;*/
		
		for (int i = -1; i <= 1; i++)
		{
			for (int j = -1; j <= 1; j++)
			{
				if (Check_for_road(i, j) == true && Check_for_exception({ current.position.y + i,current.position.x + j }) == false
					&& Is_road_or_city(map[current.position.y + i][current.position.x + j]) == true
					&& visited[From_position_to_index({ current.position.y + i,current.position.x + j })] == false)
				{
					if (map[current.position.y + i][current.position.x + j] == '*')
					{
						if (Get_city_at_position({ current.position.y + i,current.position.x + j }) == -1)throw;
						neighbours.PushBack({ Get_city_at_position({ current.position.y + i,current.position.x + j }),current.distance + 1 });
						
					}
					else
					{
					queue.PushBack({ { current.position.y + i,current.position.x + j },current.distance + 1 });
					
					}
					visited[From_position_to_index({ current.position.y + i,current.position.x + j })] = true;
				}
			}
		}
	}
	AdjacencyList.PushBack(neighbours);
}

size_t MapHandler::Find_index_of_city_at_position(const position_t& position)
{
	for (size_t i = 0; i < cities.Size(); i++)
	{
		if (cities[i].position.x == position.x && cities[i].position.y == position.y)
			return i;
	}
	throw;//city at this position doesnt exist,something is wrong
}
bool MapHandler::Check_for_road(const int i, const int j)
{
	if ((j == 0 && i == 0) || (i == 1 && j == 1) || (i == -1 && j == -1) || (i == 1 && j == -1) || (i == -1 && j == 1))
		return false;
	else return true;
}
int MapHandler::From_position_to_index(const position_t& position)
{
	return position.y * width + position.x;
}

int MapHandler::Get_city_at_position(const position_t& position)
{
	for (int i = 0; i < cities.Size(); i++)
	{
		if (cities[i].position.y == position.y && cities[i].position.x == position.x)
			return i;
	}
	return -1;
}
int MapHandler::Get_city_of_name(const String& name)
{
	for (int i = 0; i < cities.Size(); i++)
	{
		if (cities[i].name==name)
			return i;
	}
	return -1;
}
void MapHandler::Print_List()
{
	std::cout <<std::endl<< "_________________________________" << std::endl;
	for (int i = 0; i < AdjacencyList.Size(); i++)
	{
		std::cout << i << std::endl;
		for (int j = 0; j < AdjacencyList[i].Size(); j++)
		{
			std::cout <<"Index: "<<AdjacencyList[i][j].index << " distance:  " << AdjacencyList[i][j].distance << std::endl;
		}
		std::cout << "_________________________________"<<std::endl;
	}
}
route MapHandler::Djikstra_alg(int start,int end)
{
	if (start == end)
		return { NULL,0 };
	bool* visited = new bool[cities.Size()];
	Vector<graph_t> city_vector;
	for (int i = 0; i < cities.Size(); i++)
	{
		visited[i] = false;
		if (start == i)
			city_vector.PushBack({  i, 0 });
		else
			city_vector.PushBack({ i, INF });//index of previous city,distance to city
	}
	PriorityQueue<djikstra_t> queue;
	visited[start] = true;
	//add nieghbouts of the start city to the queue
	for (int i = 0; i < AdjacencyList[start].Size(); i++)
	{
		queue.Push({ AdjacencyList[start][i].index,start,AdjacencyList[start][i].distance});
		
		
	}
	//queue.Push({ start, start, 0 });
	//dot¹d solidnie 
	while (queue.Size() > 0)
	{
		djikstra_t current = queue.Pop();
		if (city_vector[current.index].distance == INF || ((current.distance) <= city_vector[current.index].distance))
		{
			city_vector[current.index].distance =  current.distance;
			city_vector[current.index].index = current.previous_index;
		}

		if (current.index == end)
			break;
		
		visited[current.index] = true;
		
		
			for (int i = 0; i < AdjacencyList[current.index].Size(); i++)
			{
				if (visited[AdjacencyList[current.index][i].index] == false)
					queue.Push({ AdjacencyList[current.index][i].index, current.index, AdjacencyList[current.index][i].distance + city_vector[current.index].distance });
			}
		
		
	}
	delete[] visited;
	int i = end;
	Vector<String> route;
	while (city_vector[i].index != start)
	{
		route.PushBack(cities[city_vector[i].index].name);
		i=city_vector[i].index;
	}
	return { route,city_vector[end].distance };
	
}

void MapHandler::Load_planes(const int quanity)
{
	char input;
	String buffer="";
	String onset;
	String destination;
	for (int i = 0; i < quanity; i++)
	{
		do
		{
			input=getchar();
			buffer = buffer + input;
		} while (input != '\n');
		buffer.ToValidString();
		onset = buffer.CutString();
		destination = buffer.CutString();
		Add_plane_conection(onset, destination, buffer.ToInt());
		buffer = "";
	}
}
void MapHandler::Add_plane_conection(String& onset, String& destination, int distance)
{
	
	AdjacencyList[Get_index_from_hash(onset)].PushBack({ Get_index_from_hash(destination),distance});
}

void MapHandler::Load_inquiries(const int quanity)
{
	char input;
	String buffer = "";
	String onset;
	String destination;
	for (int i = 0; i < quanity; i++)
	{
		do
		{
			input = getchar();
			buffer = buffer + input;
		} while (input != '\n');
		buffer.ToValidString();
		onset = buffer.CutString();
		destination = buffer.CutString();
		Handle_inquiries(onset, destination, buffer.ToInt());
		buffer = "";
	}
}
void MapHandler::Handle_inquiries(String& onset, String& destination, int type)
{
	route output;
	output = Djikstra_alg(Get_index_from_hash(onset), Get_index_from_hash(destination));
	if (type == 1)
	{
		std::cout << output.distance;
		for (int i = output.route.Size()-1; i >= 0; i--)
		{
			std::cout << " " << output.route[i];
		}
		std::cout << std::endl;
	}
	else if (type == 0)
	{
		std::cout << output.distance;
		std::cout << std::endl;
	}
}
void MapHandler::Create_hash_map()
{
	for (int i = 0; i < HASH_SIZE * cities.Size(); i++)
	{
		name_hash_map.PushBack({{ {-1,-1},""},-1});
	}
	for (int i = 0; i < cities.Size(); i++)
	{
		Fill_hashmap({ cities[i],i });
	}
}
int MapHandler::Hash_name(const String& name)
{
	int hash = 0;
	for (int i = 0; i <4 && i<name.Length(); i++)
	{
		hash += hash * 45 + name[i];
	}
	return (hash % (HASH_SIZE*cities.Size()));
	
}
void MapHandler::Fill_hashmap(const hash_map_t& hash_city)
{
	int hash;
	hash = Hash_name(hash_city.city.name);

	while (true)
	{
		

		if (name_hash_map[hash].city.name == "" && name_hash_map[hash].city.position.x == -1 && name_hash_map[hash].city.position.y == -1)
		{
			name_hash_map[hash].city.name = hash_city.city.name;
			name_hash_map[hash].city.position = hash_city.city.position;
			name_hash_map[hash].index = hash_city.index;
			return;

		}
			if (hash + 1 < name_hash_map.Size())
				hash++;

			else
				hash = 0;
	}
	
}
int MapHandler::Get_index_from_hash(const String& name)
{
	int hash = Hash_name(name);
	while (true)
	{
		if (name_hash_map[hash].city.name == name)
			return name_hash_map[hash].index;

		if (hash + 1 < name_hash_map.Size())
			hash++;
		else
			hash = 0;
	}
}
