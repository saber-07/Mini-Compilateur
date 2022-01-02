%{
#include<stdio.h>
#include"Fonctions.h"
extern int ligne;
extern FILE* yyin;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
int operation;
int intertype;
%}

%union {
int entier;
char* chaine;
float reel;
struct TypeE{
                int entier;
                float reel;
                int type;
            }TypeE;
}
%start S
%token err mc_Program  mc_PDEC mc_PINST mc_Begin mc_End deuxpoints pvg mc_define mc_Pfloat mc_Pint
%token mc_FOR mc_WHILE mc_DO mc_ENDFOR mc_IF mc_ELSE mc_ENDIF aff Affectation
%token <chaine>idf <entier>cst_e <reel>cst_r
%token barrelateral etcomercial negation
%left Superieur Inferieur Superieurouegal Inferieurouegal Egal different 
%left Addition Soustraction Multiplication division
%right pargauche pardroite
%type <entier>TYPE 
%type <TypeE>EXPRESSION
%%

S : prog mc_PDEC PartieDeclaration mc_PINST mc_Begin PartieInstructions mc_End {printf("syntaxe correcte\n"); print_list(); YYACCEPT;}
;

prog: mc_Program idf
;

PartieDeclaration: DEC PartieDeclaration | DEC
;

DEC: DEC_VAR | DEC_CST 
;

DEC_VAR : LIST_idf deuxpoints TYPE pvg {while (!queue_is_empty()) {
                                            insert(queue_first(),0,$3);
                                            pop_queue();}
                                            }
;

LIST_idf : idf barrelateral LIST_idf {push_queue($1);}
        | idf {push_queue($1);}

DEC_CST: mc_define TYPE idf aff cst_e pvg { insert($3,1,$2);
                                            if(!compatible_type(return_type($3),0)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$3,ligne); 
                                            }
        | mc_define TYPE idf aff cst_r pvg { insert($3,1,$2);
                                             if(!compatible_type(return_type($3),0)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$3,ligne); 
                                            }
;

TYPE: mc_Pint {$$=0;}
    | mc_Pfloat {$$=1;}
;

PartieInstructions: INST PartieInstructions | INST  
;

INST: INST_AFF | INST_LOOP | INST_IF
;

INST_AFF: idf Affectation EXPRESSION pvg { if(!Search_element($1)) printf("erreur sémantique %s non déclarer à la ligne %d \n",$1,ligne);
                                                if(affectation_constant($1)) printf("erreur sémantique %s affectation_constant à la ligne %d \n",$1,ligne); 
                                                if(!compatible_type(return_type($1),intertype)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$1,ligne); 
                                                }
;

EXPRESSION: EXPRESSION Addition EXPRESSION
                    | EXPRESSION Soustraction EXPRESSION 
                    | EXPRESSION Multiplication EXPRESSION 
                    | EXPRESSION division EXPRESSION 
                    | idf { if(!Search_element($1)) printf("erreur sémantique %s non déclarer à la ligne %d \n",$1,ligne);
                            intertype=return_type($1);
                            }
                    | cst_r  {intertype=1;}
                    | cst_e {intertype=0;}
;

INST_LOOP: mc_FOR idf Affectation cst_e mc_WHILE cst_e mc_DO PartieInstructions mc_ENDFOR { if(!Search_element($2)) printf("erreur sémantique %s non déclarer à la ligne %d \n",$2,ligne);
                                                                                            if(!compatible_type(return_type($2),0)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$2,ligne); 
                                                                                            if(affectation_constant($2)) printf("erreur sémantique %s affectation_constant à la ligne %d \n",$2,ligne); 
                                                                                        }
;

INST_IF: mc_DO PartieInstructions deuxpoints mc_IF pargauche LOGIQUE pardroite mc_ENDIF
        | mc_DO PartieInstructions deuxpoints mc_IF pargauche LOGIQUE pardroite mc_ELSE PartieInstructions mc_ENDIF
;

LOGIQUE:  CONDITION etcomercial LOGIQUE
        | CONDITION barrelateral LOGIQUE
        | negation CONDITION
        | pargauche CONDITION pardroite
        | CONDITION
;

CONDITION:        EXPRESSION Egal EXPRESSION
                | EXPRESSION Inferieur EXPRESSION
                | EXPRESSION Inferieurouegal EXPRESSION
                | EXPRESSION Superieur EXPRESSION
                | EXPRESSION Superieurouegal EXPRESSION
                | EXPRESSION different EXPRESSION
;

%%
int yyerror(char* msg)
{
    printf("%s ligne %d et partie %d\n",msg,ligne,col+1);
    return 0;
}
int main(){ 
yyin = fopen("test.txt", "r");
yyparse();  
return 0;  
} 
