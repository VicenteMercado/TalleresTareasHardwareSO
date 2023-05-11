
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>

//identificaciones

sem_t sem_printf;
sem_t *sem_espera;
sem_t *sem_barbero;

void* atender(void* args){
    return NULL;
}

int main(){
    
    /*
    Lectura de archivos
    */
    int sillasEspera = 1;
    sem_espera = calloc(sizeof(sem_t)*sillasEspera);
    
    //Inicializar semáforos.
    for(int i = 0; i< sillasEspera; i++){
        sem_init(*sem_espera+i,0,1);
    }
    
    sem_init(&sem_printf,0,1);
    
    //Barberos y clientes como hebras.
    pthread_t *barberos, *clientes;
    barberos = malloc(sizeof(pthread_t)*nBarberos);
    
    for(int i = 0; i<nBArberos; i++){
     
     pthread_create(barberos+i, NULL, atender, NULL);
     
    }
    
    for(int i = 0; i<nBArberos; i++){
     
     pthread_join(barberos+i,NULL);
     
    }
    
    for(int i = 0; i< sillasEspera; i++){
        sem_destroy(*sem_espera+i);
    }
    
}