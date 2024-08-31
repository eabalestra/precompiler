#ifndef TREE_H
#define TREE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "enum.h"

typedef enum NodeType {
    PROG, BODY, EXPR, NUMBER, ID, PLUS, MULTIPLY,
    ASSIGN, COLON, DECLS, STMTS, RETURN, DECL
} NodeType;

typedef struct Node {
    NodeType flag;
    Type type;
    void *value;
    char *name;
} Node;

typedef struct Tree {
    Node *root;
    struct Tree *left;
    struct Tree *right;
} Tree;

/* Node* createNode(NodeType flag, char *type, char *name, char *value);
Node* createNodeWithSymbol(int symbol);
void printTree(Node *node);
Node* createTree(int symbol, Node *left, Node *right); */

Tree* createTree(Node *root, Tree *left, Tree *right);
Node* createNode(NodeType flag, Type type, void *value, char *name);
void printTree(Tree *tree);
//void freeTree(Tree *tree);

#endif // TREE_H

