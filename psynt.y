%{
#include<stdio.h>
#include"Fonctions.h"
extern int ligne;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
%}

%union {
int entier;
char* chaine;
float reel;
}
%start S
%token err mc_Program  mc_PDEC mc_PINST mc_Begin mc_End deuxpoints <chaine>mc_Pint <chaine>mc_Pfloat pvg mc_define 
%token aff division Affectation Addition Soustraction Multiplication barrelateral etcomercial pardroite pargauche 
%token Superieur Inferieur Superieurouegal Inferieurouegal Egal different mc_FOR mc_WHILE mc_DO mc_ENDFOR mc_IF mc_ELSE
%token <chaine>idf <entier>cst 
%%

S : prog mc_PDEC PartieDeclaration mc_PINST mc_Begin PartieInstructions mc_End {printf("syntax correcte\n"); YYACCEPT;}
;

prog: mc_Program idf
;

PartieDeclaration: DEC PartieDeclaration | DEC
;

DEC: DEC_VAR 
    | DEC_CST 
;

DEC_VAR : LISTE_ID deuxpoints TYPE pvg 
;

LISTE_ID: idf barrelateral LISTE_ID {l=insert(l,{$1,x,y});}
        | idf  {l=insert(l,{$1,x,y});}
;

DEC_CST: mc_define TYPE idf aff cst pvg
;

TYPE: mc_Pint {$$=0}
    | mc_Pfloat {$$=1}
;

PartieInstructions: INST PartieInstructions | INST  
;

INST: INST_AFF | INST_LOOP | INST_IF
;

INST_AFF: idf Affectation TYPE_AFF pvg
;

TYPE_AFF: idf | cst | idf OPERATION cst | idf OPERATION idf
;

INST_LOOP: mc_FOR idf Affectation cst mc_WHILE cst mc_DO PartieInstructions mc_ENDFOR
;

INST_IF: mc_DO PartieInstructions mc_IF deuxpoints pardroite CONDITION pargauche 
        | mc_DO PartieInstructions mc_IF deuxpoints pardroite CONDITION pargauche mc_ELSE PartieInstructions
;

CONDITION: idf Expression_comparaison cst
;

Expression_comparaison: Egal | Inferieur | Inferieurouegal | Superieur | Superieurouegal | different
;

OPERATION: Addition | Soustraction | Multiplication | division
;

%%
int yyerror(char* msg)
{
    printf("%s ligne %d et colonne %d\n",msg,ligne,col);
return 0;
}
int main(){   
yyparse();  
return 0;  
} 
