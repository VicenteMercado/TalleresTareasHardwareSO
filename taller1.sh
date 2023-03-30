#!/bin/bash

lectura(){
    for carpeta in *; do {
        if [ -d $carpeta ]; then
           echo "Se ha detectado la carpeta $carpeta"
           cd $carpeta
           lectura
        else echo "$carpeta no es una carpeta."

        fi 

    } done

    cd ..
}


for carpeta in *; do { 

    if [ -d $carpeta ]; then
        echo "Se ha detectado la carpeta $carpeta"
        cd $carpeta
        lectura
    else echo "$carpeta no es una carpeta."
    
    fi
    
} done