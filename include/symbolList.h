#ifndef SYMBOL_LIST_H
#define SYMBOL_LIST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tree.h"

typedef struct SymbolList
{
    Node *symbol;
    int size;
    struct SymbolList *next;

} SymbolList;

SymbolList *createSymbolList(Node *symbol); 
void freeSymbolList(SymbolList *symbolList); 
Node* findNodeInLevel(SymbolList *symbolList, char *symbol);

#endif // SYMBOL_LIST_H