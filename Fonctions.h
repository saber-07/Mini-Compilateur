//
//  main.c
//  abderrahmane_saber
//
//  Created by  saber07 on 10/11/2021.
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {false, true} bool;

typedef struct info
{
    char Nom[256];
    int Type; // 0=int , 1=float
    int Nature; // 0=var , 1=cst
}info;

typedef struct élément
{
    info inf;
    struct élément *suivant;
}élément, *ListElts;

ListElts new_list (void) {return NULL;}

//--------------------------------------------------------------------------------------------------------------------------
bool list_is_empty(ListElts li)
{
    if(li==NULL)
        return  true;
    else return false;
}
//--------------------------------------------------------------------------------------------------------------------------

int list_length(ListElts li)
{
    int i=0;
    if (!list_is_empty(li))
    {
        while (li != NULL) {
            i++;
            li=li->suivant;
        }
    }
    return i;
}
//--------------------------------------------------------------------------------------------------------------------------

void  print_list (ListElts li)
{
    if(list_is_empty(li))
    {
        printf("rien a afficher liste vide \n");
        return;
    }
    printf("\n ******************************** Table des symboles ********************************\n");
    printf("__________________________________________________________\n");
    printf("\t|NomEntitée | NatureEntitée\n");
    printf("______________________________________\n");
    while(li !=NULL)
     {  printf("[\t%10s | %12d]\n",li->inf.Nom,li->inf.Nature);
         li=li->suivant;   }
     printf("\n");
}
//--------------------------------------------------------------------------------------------------------------------------
bool Search_element(ListElts li, char* s)
{
    while (strcmp(li->inf.Nom, s)==0 && list_is_empty(li->suivant)==false)
        li = li->suivant;
        
    if (list_is_empty(li)==true)
        return true;
    else return false;
}
//--------------------------------------------------------------------------------------------------------------------------
ListElts insert(ListElts li, info x)
{
    élément *element;
    
    element=malloc(sizeof(*element));
    
    if (element==NULL) {
        fprintf(stderr, "probléme d'allocation dynamyque. \n");
        exit(EXIT_FAILURE);
    }
    
    strcpy(element->inf.Nom, x.Nom);
    element->inf.Type = x.Type;
    element->inf.Nature = x.Nature;
    
    if(list_is_empty(li))
        element->suivant=NULL;
    else
        element->suivant=li;
    
    return element;
}