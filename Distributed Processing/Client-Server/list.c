#include "list.h"
#include <stdio.h>
#include <stdlib.h>

SingleLinkedList* createLinkedList(void* (*f_hash)(void *data), int (*f_cmp)(void *data1, void *data2), void (*f_print)(void *data))
{
    SingleLinkedList* new_list = (SingleLinkedList*)malloc(sizeof(SingleLinkedList));
    if(new_list == NULL)
    {
        printf("Memory allocation failed\n");
        return NULL;
    }
    new_list->head = NULL;
    new_list->f_hash = f_hash;
    new_list->f_cmp = f_cmp;
    new_list->f_print = f_print;
    return new_list;
}


Node* createNode(void* data)
{
    Node* new_node = (Node*)malloc(sizeof(Node));
    if(new_node == NULL)
    {
        printf("Memory allocation failed\n");
        return NULL;
    }
    new_node->data = data;
    new_node->next = NULL;
    return new_node;
}



void printLinkedList(SingleLinkedList* list)
{
    Node* temp = list->head;
    if(temp == NULL)
    {
        printf("Empty List\n");
        return;
    }
    while (temp != NULL)
    {
        list->f_print(temp->data);
        if(temp->next != NULL)
            printf(" -> ");
        temp = temp->next;
    }
    printf("\n");
}
//PRINT FUNCTIONS

void insert(SingleLinkedList* list, void* data)
{
    Node* new_node = createNode(data);
    new_node->next = list->head;
    list->head = new_node;
} // insert at head

void deleteNode(SingleLinkedList* list)
{
    if (list->head == NULL)
    {
        printf("Empty List\n");
        return;
    }

    Node* temp = list->head;
    list->head = temp->next;
    free(temp->data);
    free(temp);
}

void deleteSingleLinkedList(SingleLinkedList* list)
{
    Node* temp = list->head;
    Node* next;
    while (temp != NULL)
    {
        next = temp->next;
        free(temp->data);
        free(temp);
        temp = next;
    }
    free(list);


}