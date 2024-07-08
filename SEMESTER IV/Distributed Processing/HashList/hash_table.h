#include <stdio.h>
#include <malloc.h>
#include "hash_list.h"
#include <string.h>

typedef struct HashTable
{
   HashList* hashList;
   void* (*f_hash)(void *data);
   int (*f_cmp)(void *data1, void *data2);
   void (*f_print)(void *data);
}HashTable;

HashTable* createHashTable(void* (*f_hash)(void *data), int (*f_cmp)(void *data1, void *data2), void (*f_print)(void *data));
void insertIntoHashTable(HashTable* hashTable, void* data);
void deleteFromHashTable(HashTable* hashTable, void* hash);
void getFromHashTable(HashTable* hashTable, void* hash, void* result, size_t value_size);
void printHashTable(HashTable* hashTable);
void deleteHashTable(HashTable* hashTable);