%{
#include <stdio.h>
#include<string.h>
#include "psynt.tab.h"
int ligne=1;
int col=0;
extern YYSTYPE yylval;
%}
chiffre [0-9]
lettre [a-zA-Z]
idf {lettre}({lettre}|{chiffre}|_)*(({lettre}|{chiffre}))*
cst  [1-9]|0{chiffre}*

%%
Program {return mc_Program; col=col+yyleng;}
PDEC {return mc_PDEC;col=col+yyleng;}
PINST {return mc_PINST;col=col+yyleng;}
Begin {return mc_Begin;col=col+yyleng;}
End {return mc_End;col=col+yyleng;}
Pint {return mc_Pint; col=col+yyleng;}
Pfloat {return mc_Pfloat; col=col+yyleng;}
FOR {return mc_FOR ;col=col+yyleng;}
WHILE {return mc_WHILE ;col=col+yyleng;}
DO {return mc_DO ;col=col+yyleng;}
ENDFOR {return mc_ENDFOR ;col=col+yyleng;}
IF {return mc_IF; col=col+yyleng;}
ENDIF {return mc_ENDIF; col=col+yyleng;}
ELSE {return mc_ELSE; col=col+yyleng;}
"@define" {return mc_define; col=col+yyleng;}
"|" {return barrelateral; col++;}
"/" {return division; col++;}
"(" {return pardroite; col++;}
")" {return pargauche; col++;}
: {return deuxpoints; col++;}
= {return aff; col++;}
"<-" {return Affectation; col=col+2;}
"+" {return Addition; col++;}
"-" {return Soustraction; col++;}
"*" {return Multiplication; col++;}
== {return Egal; col=col+2;}
"<" {return Inferieur; col=col+2;}
">" {return Superieur; col=col+2;}
"<=" {return Inferieurouegal; col=col+2;}
">=" {return Superieurouegal; col=col+2;}
"!=" {return different; col=col+2;}
&  {return etcomercial; col++;}
; {return pvg; col++;}
[ \t] col++;
[\n] {ligne++;col=0;}
{idf} {if (yyleng<=12) { yylval.chaine=strdup(yytext); return idf;}
        else printf("erreur lexicale à la ligne %d:l'idf %s trop Long/n",ligne,yytext);
        }
{cst} {yylval.entier=atoi(yytext); return cst;}
. {printf("\nErreur lexical à la ligne %d sur l'entitée %s\n",ligne,yytext);
              return err;}


%%
int yywrap(void)
{
return 0;
}
