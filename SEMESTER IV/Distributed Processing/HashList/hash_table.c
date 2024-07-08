#include "hash_table.h"

HashTable* createHashTable(void* (*f_hash)(void *data), int (*f_cmp)(void *data1, void *data2), void (*f_print)(void *data))
{
    HashTable* hashTable = (HashTable*)malloc(sizeof(HashTable));
    hashTable->hashList = createHashList(f_hash, f_cmp, f_print);
    hashTable->f_hash = f_hash;
    hashTable->f_cmp = f_cmp;
    hashTable->f_print = f_print;
    return hashTable;
}

void insertIntoHashTable(HashTable* hashTable, void* data)
{
    insertToHashList(hashTable->hashList, data);
}

void deleteFromHashTable(HashTable* hashTable, void* hash)
{
    deleteHashNode(hashTable->hashList, hash);
}
void getFromHashTable(HashTable* hashTable, void* hash, void* result, size_t value_size)
{
    HashNode* temp = hashTable->hashList->head;
    while (temp != NULL)
    {
        if (hashTable->f_cmp(temp->hash, hash) == 0)
        {
            memcpy(result, temp->value_list->head->data, value_size);
            free(hash);
            return;
        }
        temp = temp->next;
    }
    printf("Not found\n");
}
void printHashTable(HashTable* hashTable)
{
    printHashList(hashTable->hashList);
}
void deleteHashTable(HashTable* hashTable)
{
    deleteHashList(hashTable->hashList);
    free(hashTable);
}