%{
#include<stdio.h>
#include"Fonctions.h"
extern int ligne;
extern FILE* yyin;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
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

S : prog mc_PDEC PartieDeclaration mc_PINST mc_Begin PartieInstructions mc_End {printf("syntaxe correcte\n"); print_list(); print_id(); YYACCEPT;}
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
                                            if(!compatible_type($2,0)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$3,ligne); 
                                            else insert_int($3,0,$5);
                                            }
        | mc_define TYPE idf aff cst_r pvg { insert($3,1,$2);
                                             if(!compatible_type($2,1)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$3,ligne);
                                             else insert_float($3,1,$5); 
                                            }
;

TYPE: mc_Pint {$$=0;}
    | mc_Pfloat {$$=1;}
;

PartieInstructions: INST PartieInstructions | INST  
;

INST: INST_AFF | INST_LOOP | INST_IF
;

INST_AFF: idf Affectation EXPRESSION pvg {  if(!Search_element($1)) printf("erreur sémantique %s non déclarer à la ligne %d \n",$1,ligne);
                                            else {  if(affectation_constant($1)) printf("erreur sémantique %s affectation_constant à la ligne %d \n",$1,ligne); 
                                                    else {if(!compatible_type(return_type($1),$3.type)) printf("erreur semantique %s, incompatibilite de type à la ligne %d \n",$1,ligne);
                                                          else{ if(return_type($1)==0){
                                                                     if(!Search_id($1)) insert_int($1,0,$3.entier);
                                                                     else replace_int($1,$3.entier);
                                                                    }
                                                                 if(return_type($1)==1){
                                                                     if(!Search_id($1)) insert_float($1,1,$3.reel);
                                                                     else replace_float($1,$3.reel);
                                                                    }
                                                                }
                                                            }
                                                    }
                                                }
;

EXPRESSION:  EXPRESSION Addition EXPRESSION { if(!compatible_type($1.type,$3.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                               else { $$.type=$1.type;
                                                      if($$.type==0) $$.entier=$1.entier + $3.entier;
                                                      else $$.reel = $1.reel + $3.reel; 
                                                      } 
                                                }
            | EXPRESSION Soustraction EXPRESSION {if(!compatible_type($1.type,$3.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                                    else {  $$.type=$1.type;
                                                            if($$.type==0) $$.entier=$1.entier - $3.entier;
                                                            else $$.reel = $1.reel - $3.reel; 
                                                            } 
                                                      }
            | EXPRESSION Multiplication EXPRESSION {if(!compatible_type($1.type,$3.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                                    else {  $$.type=$1.type;
                                                            if($$.type==0) $$.entier=$1.entier * $3.entier;
                                                            else $$.reel = $1.reel * $3.reel; 
                                                            } 
                                                        }
            | EXPRESSION division EXPRESSION {if(!compatible_type($1.type,$3.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                                else {      if($3.entier==0 || $3.reel==0) printf("erreur sémantique division sur zéro à la ligne %d\n",ligne);
                                                            else {
                                                                    $$.type=$1.type;
                                                                    if($$.type==0) $$.entier=$1.entier / $3.entier;
                                                                    else $$.reel = $1.reel / $3.reel; 
                                                                    }
                                                        } 
                                                }
            | pargauche EXPRESSION Addition EXPRESSION pardroite { if(!compatible_type($2.type,$4.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                               else { $$.type=$2.type;
                                                      if($$.type==0) $$.entier=$2.entier + $4.entier;
                                                      else $$.reel = $2.reel + $4.reel; 
                                                      } 
                                                }
            | pargauche EXPRESSION Soustraction EXPRESSION pardroite {if(!compatible_type($2.type,$4.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                                    else {  $$.type=$2.type;
                                                            if($$.type==0) $$.entier=($2.entier) - ($4.entier);
                                                            else $$.reel = ($2.reel) - ($4.reel); 
                                                            } 
                                                      }
            | pargauche EXPRESSION Multiplication EXPRESSION pardroite {if(!compatible_type($2.type,$4.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                                    else {  $$.type=$2.type;
                                                            if($$.type==0) $$.entier=$2.entier * $4.entier;
                                                            else $$.reel = $2.reel * $4.reel; 
                                                            } 
                                                        }
            | pargauche EXPRESSION division EXPRESSION pardroite {if(!compatible_type($2.type,$4.type)) printf("erreur semantique, incompatibilite de type à la ligne %d \n",ligne); 
                                                else {      if($4.entier==0 || $4.reel==0) printf("erreur sémantique division sur zéro à la ligne %d\n",ligne);
                                                            else {
                                                                    $$.type=$2.type;
                                                                    if($$.type==0) $$.entier=$2.entier / $4.entier;
                                                                    else $$.reel = $2.reel / $4.reel; 
                                                                    }
                                                        } 
                                                }
            | idf { if(!Search_element($1)) printf("erreur sémantique %s non déclarer à la ligne %d \n",$1,ligne);
                    $$.type=return_type($1);
                    if($$.type==0) $$.entier=return_int($1);
                    else $$.reel=return_float($1);
                    }
            | cst_r  {  $$.type=1;  
                        $$.reel=$1;
                        }
            | cst_e  {  $$.type=0;  
                        $$.entier=$1;
                        }
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
