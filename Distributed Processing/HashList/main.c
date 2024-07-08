#include <stdio.h>
#include <malloc.h>
#include "hash_table.h"
void  f_print(void* data)
{
    printf("%d ", *(int*)data);
}
int f_cmp(void* data1, void* data2)
{
    if (*(int*)data1 == *(int*)data2)
        return 0;
    else if (*(int*)data1 > *(int*)data2)
        return 1;
    else
        return -1;
}
void* f_hash(void* data)
{
    int* value = (int*)data;
    int* hash_code = (int *)malloc(sizeof(int));
    if (hash_code == NULL)
    {
        printf("Memory allocation failed\n");
        return NULL;
    }
    *hash_code =  *value % 100;
    return hash_code;
}
int main() {
    int* value1 = (int *)malloc(sizeof(int));
    *value1 = 50;
    int* value2 = (int *)malloc(sizeof(int));
    *value2 = 60;
    int* value3 = (int *)malloc(sizeof(int));
    *value3 = 70;
    int* value4 = (int *)malloc(sizeof(int));
    *value4 = 170;
    int* value5 = (int *)malloc(sizeof(int));
    *value5 = 270;
    int* value6 = (int *)malloc(sizeof(int));
    *value6 = 260;
    int* value7 = (int *)malloc(sizeof(int));
    *value7 = 75;
   // int* value5;


    HashTable* hash_table = createHashTable(f_hash, f_cmp, f_print);
    insertIntoHashTable(hash_table, value1);
    insertIntoHashTable(hash_table, value2);
    insertIntoHashTable(hash_table, value3);
    insertIntoHashTable(hash_table, value4);
    insertIntoHashTable(hash_table, value5);
    insertIntoHashTable(hash_table, value6);
    insertIntoHashTable(hash_table, value7);

    printHashTable(hash_table);
    deleteFromHashTable(hash_table, value1);
    printHashTable(hash_table);

    int* result = (int *)malloc(sizeof(int));
    getFromHashTable(hash_table, f_hash(value2), result, sizeof(int));
    printf("--------------- \n");
    printf("Result: %d\n\n", *result);
    *result = 0;
    printHashTable(hash_table);
    printf("Result: %d\n\n", *result);
    printf("--------------------\n");
    free(result);
    deleteFromHashTable(hash_table, value7);
    printHashTable(hash_table);
    deleteFromHashTable(hash_table, value3);
    printHashTable(hash_table);
    deleteHashTable(hash_table);

    return 0;


}
