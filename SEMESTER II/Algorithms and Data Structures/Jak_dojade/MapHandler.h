#pragma once
#include "String.h"
#include "Vector.h"
#include "City.h"
#include "DoublyLinkedList.h"
#include "PriorityQueue.h"
#include "djikstra_t.h"
#include<iostream>
#define INF -1
#define HASH_SIZE 7

typedef struct 
{
	position_t position;
	int distance;
}pair_t;
typedef struct
{
	City city;
	int index;
}hash_map_t;

typedef struct
{
	int index;
	long long distance;
}graph_t;
typedef struct
{
	Vector<String> route;
	long long distance;
}route;
class MapHandler
{
private:
	const int width;
	const int height;
	Vector<String> map;
	Vector<City> cities;
	Vector<Vector<graph_t>> AdjacencyList;
	Vector<hash_map_t> name_hash_map;
public:
	MapHandler(const int width, const int height);
	void Load_map();
	void Print_map();
	void Find_cities();
	void Find_city_name(const position_t& position);
	String Acquire_city_name(const position_t& position);
	bool Check_for_map_symbols(const char symbol) const;
	bool Is_road_or_city(const char symbol) const;
	bool Check_for_exception(const position_t& position)const;
	void Print_cities();
	position_t Get_furthest_letter(const position_t position);
	void Create_AdjacencyList();
	void BFS(const position_t& position, bool* visited);
	size_t Find_index_of_city_at_position(const position_t& position);
	bool Check_for_road(const int i, const int j);
	int From_position_to_index(const position_t& position);
	int Get_city_at_position(const position_t& position);
	int Get_city_of_name(const String& name);
	void Print_List();
	route Djikstra_alg(int start, int end);
	void Load_planes(const int quanity);
	void Add_plane_conection(String& onset, String& destination, int distance);
	void Load_inquiries(const int quanity);
	void Handle_inquiries(String& onset, String& destination, int type);
	void Create_hash_map();
	int Hash_name(const String& name);
	void Fill_hashmap(const hash_map_t& hash_city);
	int Get_index_from_hash(const String& name);
	
};
