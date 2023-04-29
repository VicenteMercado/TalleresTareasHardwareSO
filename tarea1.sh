#!/bin/bash
# Vicente Martin Mercado Meza - 21.151.511-2

cd /proc
procesoInfo(){

    printf "%s%15s%15s%15s\t%s\n" "UID" "PID" "PPID "STATUS "CMD"

    for carpeta in *; do {
        dir="/proc/$carpeta/status"
        if [ -f $dir ]; then
           uid=$(cat /proc/$carpeta/status | grep "Uid" | awk '{print $2}')
           pid=$(cat /proc/$carpeta/status | grep --max-count=1 "Pid" | awk '{print $2}')
           ppid=$(cat /proc/$carpeta/status | grep --max-count=1 "PPid" | awk '{print $2}')
           status=$(cat /proc/$carpeta/status | grep "State" | awk '{print $3}')

           dircmd="/proc/$carpeta/cmdline"
           if [ -z "$dircmd" ]; then
                cmd=$(cat /proc/$carpeta/cmdline | awk '{print $1}')
           else
                cmd=$(cat /proc/$carpeta/comm | awk '{print $1}')
           fi
           
           printf "%s%15s%15s%15s\t%s" $uid $pid $ppid $status $cmd
           echo "\n"
        fi 

    } done

}

if [ -z $1 ]; then #Opción 1
    cat /proc/cpuinfo | grep --max-count=1 "model name" | awk '{print "ModelName:", $4,$5,$6,$7,$8,$9}'
    cat /proc/version | grep "Linux version" | awk '{print "KernelVersion:", $3}'
    cat /proc/meminfo | grep "MemTotal" | awk '{print "Memory (kB):", $2,$3}'
fi 

case $1 in
-ps)
     procesoInfo;;

-m)
    printf '%10s %10s\n' 'TOTAL' 'AVAILABLE'    
    cat /proc/meminfo | grep "MemTotal" | awk '{printf "%10.1f", $2/1024/1024}'
    cat /proc/meminfo | grep "MemAvailable" | awk '{printf "%10.1f\n", $2/1024/1024}'
    ;;
-tcp)

    printf "%20s%20s%10s\n" "SOURCE:PORT" "DESTINATION:PORT" "STATUS"

    cat /proc/net/tcp | grep "$x: " | while read -r line ; do
        source=$(cat /proc/net/tcp | grep "$x: " | awk '{printf "%s", $2}')
        ip=$(echo $source | awk -F ":" '{printf "%s", $1}')
        A=$(echo $ip | awk '{print (substr($0,7,2))}')
        A=$(echo "ibase = 16; $A" | bc)
        B=$(echo $ip | awk '{print (substr($0,5,2))}')
        B=$(echo "ibase = 16; $B" | bc)
        C=$(echo $ip | awk '{print (substr($0,3,2))}')
        C=$(echo "ibase = 16; $C" | bc)
        D=$(echo $ip | awk '{print (substr($0,1,2))}')
        D=$(echo "ibase = 16; $C" | bc)
        PORT=$(echo $ip | awk -F ":" '{printf "%s", $2}')
        PORT=$(echo "ibase = 16; $PORT" | bc)

        printf "%20s" $(printf "%d.%d.%d.%d:%d" $A $B $C $D $PORT)
        
        destination=$(cat /proc/net/tcp | grep "$x: " | awk '{printf "%s", $3}')
        ip=$(echo $destination | awk -F ":" '{printf "%s", $1}')
        A=$(echo $ip | awk '{print (substr($0,7,2))}')
        A=$(echo "ibase = 16; $A" | bc)
        B=$(echo $ip | awk '{print (substr($0,5,2))}')
        B=$(echo "ibase = 16; $B" | bc)
        C=$(echo $ip | awk '{print (substr($0,3,2))}')
        C=$(echo "ibase = 16; $C" | bc)
        D=$(echo $ip | awk '{print (substr($0,1,2))}')
        D=$(echo "ibase = 16; $C" | bc)
        PORT=$(echo $ip | awk -F ":" '{printf "%s", $2}')
        PORT=$(echo "ibase = 16; $PORT" | bc)

        printf "%20s" $(printf "%d.%d.%d.%d:%d" $A $B $C $D $PORT)
        
        #cat /proc/net/tcp | grep "$x: " | awk '{printf "%s",$4}'
        case $(cat /proc/net/tcp | grep --max-count=1 "$x: "  | awk '{printf "%s",$4}') in
            01) printf "%20s" TCP_ESTABLISHED;;
			02) printf "%20s" TCP_SYN_SENT;;
			03) printf "%20s" TCP_SYN_RECV;;
			04) printf "%20s" TCP_FIN_WAIT1;;
			05) printf "%20s" TCP_FIN_WAIT2;;
			06) printf "%20s" TCP_TIME_WAIT;;
			07) printf "%20s" TCP_CLOSE;;
			08) printf "%20s" TCP_CLOSE_WAIT;;
			09) printf "%20s" TCP_LAST_ACK;;
			0A) printf "%20s" TCP_LISTEN;;
			0B) printf "%20s" TCP_CLOSING;;
			0C) printf "%20s" TCP_NEW_SYN_RECV;;
            *) ;;


        esac
        echo
        x=$(( $x+1 ))
    done
    ;;

-tcpStatus)
    printf "%20s%20s%10s\n" "SOURCE:PORT" "DESTINATION:PORT" "STATUS"

    for i in 01 02 03 04 05 06 07 08 09 0A 0B 0C; do
        cat /proc/net/tcp | grep " $i " | while read -r line ; do
            source=$(echo $line | awk '{printf "%s", $2}')
            ip=$(echo $source | awk -F ":" '{printf "%s", $1}')
            A=$(echo $ip | awk '{print (substr($0,7,2))}')
            A=$(echo "ibase = 16; $A" | bc)
            B=$(echo $ip | awk '{print (substr($0,5,2))}')
            B=$(echo "ibase = 16; $B" | bc)
            C=$(echo $ip | awk '{print (substr($0,3,2))}')
            C=$(echo "ibase = 16; $C" | bc)
            D=$(echo $ip | awk '{print (substr($0,1,2))}')
            D=$(echo "ibase = 16; $C" | bc)
            PORT=$(echo $ip | awk -F ":" '{printf "%s", $2}')
            PORT=$(echo "ibase = 16; $PORT" | bc)

            printf "%20s" $(printf "%d.%d.%d.%d:%d" $A $B $C $D $PORT)
        
            destination=$(echo $line | awk '{printf "%s", $3}')
            ip=$(echo $destination | awk -F ":" '{printf "%s", $1}')
            A=$(echo $ip | awk '{print (substr($0,7,2))}')
            A=$(echo "ibase = 16; $A" | bc)
            B=$(echo $ip | awk '{print (substr($0,5,2))}')
            B=$(echo "ibase = 16; $B" | bc)
            C=$(echo $ip | awk '{print (substr($0,3,2))}')
            C=$(echo "ibase = 16; $C" | bc)
            D=$(echo $ip | awk '{print (substr($0,1,2))}')
            D=$(echo "ibase = 16; $C" | bc)
            PORT=$(echo $ip | awk -F ":" '{printf "%s", $2}')
            PORT=$(echo "ibase = 16; $PORT" | bc)

            printf "%20s" $(printf "%d.%d.%d.%d:%d" $A $B $C $D $PORT)
        
            case $(echo $line | awk '{printf "%s",$4}') in
                01) printf "%20s" TCP_ESTABLISHED;;
                02) printf "%20s" TCP_SYN_SENT;;
                03) printf "%20s" TCP_SYN_RECV;;
                04) printf "%20s" TCP_FIN_WAIT1;;
                05) printf "%20s" TCP_FIN_WAIT2;;
                06) printf "%20s" TCP_TIME_WAIT;;
                07) printf "%20s" TCP_CLOSE;;
                08) printf "%20s" TCP_CLOSE_WAIT;;
                09) printf "%20s" TCP_LAST_ACK;;
                0A) printf "%20s" TCP_LISTEN;;
                0B) printf "%20s" TCP_CLOSING;;
                0C) printf "%20s" TCP_NEW_SYN_RECV;;
                *) ;;
            esac
            echo
        done
    done
    ;;

-help)
    echo "Para este programa, las opciones disponibles son:"
    echo
    echo "sin parámetros : Muestra por pantalla el procesador, version del kernel y la cantidad de memoria del sistema (en kB)."
    echo "-ps : Muestra el UID, PID, PPID, STATUS y CMD de cada proceso."
    echo "-m : Muestra la cantidad total de memoria RAM y la cantidad disponible de memoria RAM, ambos en formato GB."
    echo "-tcp : Muestra la información de las conexiones TCP (dirección IP orígen, puerto orígen, dirección IP destino, puerto destino y estado de conexión)."
    echo "-tcpStatus : Muestra la información de las conexiones TCP, agrupadas por estado de conexión."
    echo "-help : Muestra información acerca de los comandos disponibles para este programa."

esac
