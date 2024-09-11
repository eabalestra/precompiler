#include "SymbolTable.h"

void handleDeclaration(Tree *tree, SymbolTable *table);

SymbolTable* createSymbolTable()
{
    SymbolTable *newSymbolTable = (SymbolTable *)malloc(sizeof(SymbolTable));
    newSymbolTable->symbol = NULL;
    newSymbolTable->next = NULL;
    newSymbolTable->size = 0;

    return newSymbolTable;
}

void insertSymbol(SymbolTable *table, Node *symbol)
{
    int valueExist = symbolExists(table, symbol->name);
    if (valueExist == 1) {
        printf("Can't insertSymbol new element, it already exists.\n");
        return;
    }
    
    SymbolTable *newSymbolTable = (SymbolTable *)malloc(sizeof(SymbolTable));
    newSymbolTable->symbol = symbol;
    newSymbolTable->next = NULL;

    if (table->symbol == NULL) {
        table->symbol = symbol;
    } else {
        SymbolTable *aux = table;
        while (aux->next != NULL) {
            aux = aux->next;
        }
        aux->next = newSymbolTable;
    }
    table->size++;
}

Node* findSymbol(SymbolTable *table, char *symbol)
{
    if (symbol == NULL || table->size == 0)
    {
        return NULL;
    }
    SymbolTable *aux = table;
    while (aux != NULL) {
        if (strcmp(aux->symbol->name, symbol) == 0) {
                return aux->symbol;
        }
        aux = aux->next;
    }
    return NULL;
}

int symbolExists(SymbolTable *table, char *symbol)
{
    if (findSymbol(table, symbol) != NULL)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void printSymbolTable(SymbolTable *table)
{
    printf("\n-- SYMBOL TABLE --\n");
    printf("SIZE = %d \n", table->size);
    SymbolTable *current_node = table;
   	while (current_node != NULL) {
        printf("\nNODE %s\n",nodeTypeToString(current_node->symbol->flag));
        printf("type: %u\n",current_node->symbol->type);
        printf("name: %s\n", current_node->symbol->name);
        printf("value: %d\n",current_node->symbol->value);
        current_node = current_node->next;
    }
}

SymbolTable* performSemanticCheck(Tree *tree)
{
    SymbolTable *table = createSymbolTable();
    checkDeclarations(tree->left, table);

    return table;
}

void checkDeclarations(Tree *tree, SymbolTable *table)
{
    if (tree == NULL || tree->root == NULL)
    {
        return;
    }
    if (tree->root->flag == DECL)
    {
        handleDeclaration(tree, table);
    }
    checkDeclarations(tree->left, table);
    checkDeclarations(tree->right, table);
}

void handleDeclaration(Tree *tree, SymbolTable *table)
{
    Tree *hi = tree->left;
    Node *newNode = createNode(VAR, hi->root->type, NULL, hi->root->value);
    if (tree->right != NULL && tree->right->root != NULL)
    {
        Tree *hd = tree->right;
        if (hd->root->flag == NUMBER || hd->root->flag == BOOL) { // TODO: PREGUNTAR
            if (newNode->type == hd->root->type) {
                newNode->value = hd->root->value;
            } else {
                printf("Incorrect types");
                return;
            }
        } else {
            Node *aux = findSymbol(table, hd->root->value);
            if (aux == NULL) {
                printf("Id not declared \n");
                return;
            }
            if (newNode->type == aux->type) {
                newNode->value = aux->value;
            }
        }
    }
    insertSymbol(table, newNode);
}
