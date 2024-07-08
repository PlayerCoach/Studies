#include "hash_list.h"
#include <stdio.h>
#include <stdlib.h>

HashList* createHashList(void* (*f_hash)(void *data), int (*f_cmp)(void *data1, void *data2), void (*f_print)(void *data))
{
    HashList* new_list = (HashList*)malloc(sizeof(HashList));
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


HashNode* createHashNode(void* hash, HashList* list)
{
    HashNode* new_node = (HashNode*)malloc(sizeof(HashNode));
    if(new_node == NULL)
    {
        printf("Memory allocation failed\n");
        return NULL;
    }
    new_node->hash = hash;
    new_node->next = NULL;
    new_node->prev = NULL;
    new_node->value_list = createLinkedList(list->f_hash, list->f_cmp, list->f_print);
    return new_node;
}

void printHashList(HashList* list)
{
    HashNode* temp = list->head;
    if(temp == NULL)
    {
        printf("Empty Hash List\n");
        return;
    }
    while (temp != NULL)
    {
        list->f_print(temp->hash);
        printf(" => ");
        printLinkedList((temp->value_list));
        temp = temp->next;
    }
    printf("\n");
}
//PRINT FUNCTIONS

void insertToHashList(HashList* list, void* data)
{
    void* hash = list->f_hash(data);
    HashNode* temp = list->head;
    while (temp != NULL)
    {
        if (list->f_cmp(temp->hash, hash) == 0)
        {
            insert((temp->value_list), data);
            free(hash);
            return;
        }
        temp = temp->next;
    }
    HashNode* new_node = createHashNode(hash,list);
    if (list->head != NULL) {
        list->head->prev = new_node;
    }
    new_node->next = list->head;
    list->head = new_node;
    insert((new_node->value_list), data);
    sortHashList(list);
}

void deleteHashNode(HashList* list, void* data)
{
    void* hash = list->f_hash(data);
    HashNode* temp = list->head;
    while (temp != NULL)
    {
        if (list->f_cmp(temp->hash, hash) == 0)
        {
            deleteNode((temp->value_list));
            if (temp->value_list->head == NULL)
            {
                free(temp->value_list);
                if (temp->prev == NULL)
                {
                    list->head = temp->next;
                    if (temp->next != NULL)
                    {
                        temp->next->prev = NULL;
                    }
                }
                else
                {
                    temp->prev->next = temp->next;
                    if (temp->next != NULL)
                    {
                        temp->next->prev = temp->prev;
                    }
                }

                free(temp->hash);
                free(temp);
            }
            free(hash);
            return;
        }
        temp = temp->next;
    }
}

void deleteHashList(HashList* list)
{
    HashNode* temp = list->head;
    HashNode* next;
    while (temp != NULL)
    {
        next = temp->next;
        deleteSingleLinkedList((temp->value_list));
        free(temp->hash);
        free(temp);
        temp = next;
    }

    free(list);
}
void sortHashList(HashList* list)
{
    HashNode* temp = list->head;
    HashNode* temp2;
    while (temp != NULL)
    {
        temp2 = temp->next;
        while (temp2 != NULL)
        {
            if (list->f_cmp(temp->hash, temp2->hash) > 0)
            {
                void* temp_hash = temp->hash;
                temp->hash = temp2->hash;
                temp2->hash = temp_hash;
                SingleLinkedList* temp_list = temp->value_list;
                temp->value_list = temp2->value_list;
                temp2->value_list = temp_list;
            }
            temp2 = temp2->next;
        }
        temp = temp->next;
    }
}