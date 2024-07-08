#include <stdio.h>
#include "single_linked_list.h"

typedef struct HashNode {
    void *hash;
    struct HashNode* next;
    struct HashNode* prev;
    SingleLinkedList* value_list;

} HashNode;

typedef struct HashList{
    HashNode* head;
    void* (*f_hash)(void *data);
    int (*f_cmp)(void *data1, void *data2);
    void (*f_print)(void *data);
} HashList;

HashList* createHashList(void* (*f_hash)(void *data), int (*f_cmp)(void *data1, void *data2), void (*f_print)(void *data));
HashNode* createHashNode(void* hash, HashList* list);

void printHashList(HashList* list);

//insert_at_head
void insertToHashList(HashList* list, void* data);

//free memory
void deleteHashNode(HashList * list, void* data);

void deleteHashList(HashList* list);

void sortHashList(HashList* list);

