#include <stdio.h>
#ifndef SINGLE_LINKED_LIST_H
#define SINGLE_LINKED_LIST_H
typedef struct Node {
    void* data;
    struct Node* next;
} Node;

typedef struct {
    Node* head;
    void* (*f_hash)(void *data);
    int (*f_cmp)(void *data1, void *data2);
    void (*f_print)(void *data);

} SingleLinkedList;


SingleLinkedList* createLinkedList(void* (*f_hash)(void *data), int (*f_cmp)(void *data1, void *data2), void (*f_print)(void *data));
Node* createNode(void* data);
void printLinkedList(SingleLinkedList* list);
//PRINT FUNCTIONS
void insert(SingleLinkedList* list, void* data);
void deleteNode(SingleLinkedList* list);
void deleteSingleLinkedList(SingleLinkedList* list);
#endif //SINGLE_LINKED_LIST_H