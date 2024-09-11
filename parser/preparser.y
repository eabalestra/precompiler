%{
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

#include "../binarytree/Tree.h"
#include "../symboltable/SymbolTable.h"

Tree *ast;

static enum Type integerType = INTEGER;
static enum Type boolType = BOOLEAN;
static enum Type voidType = VOID;

%}

%union{
    enum Type *vtype;
    struct Node *vnode;
    struct Tree *vast;
    int vint;
    char *vstring;
    bool vbool;
}

%token<vstring> TID
%type<vtype> type

%token TRETURN
%token TCOLON
%token TLBRACKET
%token TRBRACKET
%token TLCURLY
%token TRCURLY
%token TMAIN

%token TPLUS
%token TMULTIPLY
%token TASSIGN
%token TAND
%token TOR

%token<vtype> TVOID
%token<vtype> TBOOLEAN
%token<vtype> TINTEGER
%token<vint> TNUMBER
%token<vbool> TTRUE
%token<vbool> TFALSE

%type<vast> prog
%type<vast> decls
%type<vast> decl
%type<vast> stmts
%type<vast> stmt
%type<vast> expr

%left '+' TPLUS
%left '*' TMULTIPLY
%left "or" TOR
%left "and" TAND

%%

prog: type TMAIN TLBRACKET TRBRACKET TLCURLY decls stmts TRCURLY {
    printf("PARSER OK\n");
    Node *newNode = createNode(PROG, type, NULL, NULL);
    ast = createTree(newNode, $6, $7);
    SymbolTable *table = semanticCheck(ast);
    printTree(ast);
    printSymbolTable(table);
}

decls:  decl {
            Node *newNode = createNode(COLON, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, NULL);
        }
        | decl decls {
            Node *newNode = createNode(DECLS, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, $2);
        }
        ;

decl:   type TID TCOLON {
            Node *newNode = createNode(ID, *$1, $2, NULL);
            Tree *idTree = createTree(newNode, NULL, NULL);
            $$ = createTree(createNode(DECL, NONTYPE, NULL, NULL), idTree, NULL);
        }
        | type TID TASSIGN expr TCOLON {
            Node *newNode = createNode(ID, *$1, $2, NULL);
            Tree *idTree = createTree(newNode, NULL, NULL);
            $$ = createTree(createNode(DECL, NONTYPE, NULL, NULL), idTree, $4);
        }
        ;

stmts:  stmt {
            Node *newNode = createNode(COLON, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, NULL); 
        }
        | stmt stmts {
            Node *newNode = createNode(STMTS, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, $2);
        }
        ;
        
stmt:   TID TASSIGN expr TCOLON {
            Node *newNode = createNode(ASSIGN, NONTYPE, NULL, NULL);
            Node *newId = createNode(ID, NONTYPE, $1, NULL);   
            Tree *idLeaf = createTree(newId, NULL, NULL);
            $$ = createTree(newNode, idLeaf, $3);
        }
        | TRETURN expr TCOLON {
            Node *newNode = createNode(RETURN, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $2, NULL);
        }
        | TRETURN TCOLON {
            Node *newNode = createNode(RETURN, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, NULL, NULL);
        }
        ;

expr:   expr TPLUS expr {
            Node *newNode = createNode(PLUS, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, $3);
        }
        | expr TMULTIPLY expr   {
            Node *newNode = createNode(MULTIPLY, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, $3);
        }
        | TLBRACKET expr TRBRACKET {
            $$ = $2;
        }
        | expr TAND expr {
            Node *newNode = createNode(AND, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, $3);
        }
        | expr TOR expr {
            Node *newNode = createNode(OR, NONTYPE, NULL, NULL);
            $$ = createTree(newNode, $1, $3);
        }
        | TFALSE {
            Node *newNode = createNode(BOOL, BOOLEAN, (void *) $1, NULL);
            $$ = createTree(newNode, NULL, NULL);
        }
        | TTRUE {
            Node *newNode = createNode(BOOL, BOOLEAN, (void *) $1, NULL);
            $$ = createTree(newNode, NULL, NULL);
        }
        | TNUMBER   {
            Node *newNode = createNode(NUMBER, INTEGER, $1, NULL);
            $$ = createTree(newNode, NULL, NULL);
        }
        | TID {
            Node *newNode = createNode(ID, NONTYPE, $1, NULL);     
            $$ = createTree(newNode, NULL, NULL);
        }
        ;

    type:   TINTEGER { $$ = &integerType; }
        | TBOOLEAN   { $$ = &boolType; }
        | TVOID  { $$ = &voidType; }
        ;

%%