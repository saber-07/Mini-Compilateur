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

//def d'une liste de symbole
typedef struct élément
{
    char Nom[256];
    int Type; // 0=int , 1=float
    int Nature; // 0=var , 1=cst
    struct élément *suivant;
}élément, *ListElts;

//def d'une file de nom d'idf
typedef struct QueueElement
{
    char NomIdf[256];
    struct QueueElement *next;
}QueueElement, *Queue;

//parametre de la file 
static QueueElement *first=NULL;
static QueueElement *last=NULL;

//la liste de symbole
ListElts symbole=NULL;

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

void  print_list (void)
{
    ListElts temp=symbole ;

    if(list_is_empty(symbole))
    {
        printf("rien a afficher liste vide \n");
        return;
    }
    printf("\n ************************* Table des symboles *************************\n");
    printf("_________________________________________________________________________\n");
    printf("\t|NomEntitée | NatureEntitée | TypeEntitée\n");
    printf("-------------------------------------------------------------------------\n");
    while(temp !=NULL)
     {  printf("[\t%10s | %12d | %12d]\n",temp->Nom,temp->Nature,temp->Type);
         temp=temp->suivant;   }
     printf("\n");
}
//--------------------------------------------------------------------------------------------------------------------------
bool Search_element(char* s)
{
    if (symbole==NULL) return false;
    
    ListElts temp=symbole ;
    
    while (strcmp(temp->Nom, s)!=0 && temp->suivant!=NULL)
        temp = temp->suivant;
        
    if (strcmp(temp->Nom, s)==0)
        return true;
    else return false;
}
//--------------------------------------------------------------------------------------------------------------------------
void insert(char nom[256], int nature, int type)
{
    if(!Search_element(nom)){
        élément *element;

        element=malloc(sizeof(*element));
        
        if (element==NULL) {
            fprintf(stderr, "probléme d'allocation dynamique. \n");
            exit(EXIT_FAILURE);
        }
        
        strcpy(element->Nom, nom);
        element->Type = type;
        element->Nature = nature;
        element->suivant=NULL;

        if(list_is_empty(symbole)) symbole=element;
        else{
            ListElts temp=symbole ;

            while (temp->suivant!=NULL) temp = temp->suivant;

            temp->suivant=element;
            element->suivant=NULL;
        }
    }
    else printf("le symbole %s est deja déclaré\n",nom);
}
//--------------------------------------------------------------------------------------------------------------------------
int return_type(char* nom){
    if (Search_element(nom))
    {
        ListElts temp=symbole ;
        while (temp->suivant!=NULL && strcmp(temp->Nom, nom)!=0) temp = temp->suivant;
        return temp->Type;
    }
    else {
        printf("le symbole %s n'existe pas \n",nom);
        return -1;
    }
}
//--------------------------------------------------------------------------------------------------------------------------
int return_nature(char* nom){
    if (Search_element(nom))
    {
        ListElts temp=symbole ;
        while (temp->suivant!=NULL && strcmp(temp->Nom, nom)!=0) temp = temp->suivant;
        return temp->Nature;
    }
    else {
        printf("le symbole %s n'existe pas \n",nom);
        return -1;
    }
}
//--------------------------------------------------------------------------------------------------------------------------
//fonctions pour gérer les files de noms d'idf
//-----------------------------------------------------------------------
bool queue_is_empty(void)
{
    if(first==NULL && last==NULL) return true;
    else return false;
}
//----------------------------------------------------------------------- 
char* queue_first(void)
{
    if(queue_is_empty())
        exit(1);
    else
        return first->NomIdf;
}
//-----------------------------------------------------------------------
void push_queue(char x[256])
{
    QueueElement *element;
    element=malloc(sizeof(*element));
    if (element==NULL) {
        fprintf(stderr, "problem d'alocation");
    }
    strcpy(element->NomIdf,x);
    element->next=NULL;
    if (queue_is_empty()) {
        first = element;
        last=element;
    }
    else{
        last->next=element;
        last=element;
    }
}
//-----------------------------------------------------------------------
void pop_queue(void)
{
    if (queue_is_empty()) {
        printf("file vide");
        return;
    }
    QueueElement *temp=first;
    if (first==last) {
        first=NULL;
        last=NULL;
    }
    else
        first=first->next;
    free(temp);
    temp=NULL;
}

//-----------------------------------------------------------------------
void print_queue(void)
{
    if (queue_is_empty()) printf(" file vide");
    
    QueueElement *temp=first;
    while (temp!=NULL)
    {
        printf("[%s]",temp->NomIdf);
        temp=temp->next;
    }
    printf("\n");
}
//-----------------------------------------------------------------------
//routine sémantique
//-----------------------------------------------------------------------

 bool compatible_type(int type1,int type2){
    if(type1 != type2) {
        return false;
    } 
    return true;
}
//-----------------------------------------------------------------------
bool affectation_constant(char* nom){
    if(return_nature(nom)==1) return true;
    else return false;
}
