#!/bin/bash

# Arreglo
arr=('TiCentral' 'DocCentral' 'PABMI' 'PDRMYE' 'SICA' 'SICSA' 'SRPU' 'SIEDNL')

# Credenciales
user="root"
password="Rx7TqKzxvY6W"
host="localhost"

# Otras opciones, ruta en donde se almacenará el respaldo
date=$(date +"%d-%b-%Y-%H-%M-%S")

# Permisos de archivo
umask 177

# Recorriendo el arreglo con un ciclo for
for i in "${arr[@]}"
do
    backup_path="/home/DB/DEVDB/${i}/"  # Corregido aquí
    db_name=$i

    # Dump Base de datos
    mysqldump --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date-$i.sql

    # Comprimir el archivo
    tar -czvf $backup_path/$db_name-$date-$i.sql.tar.gz $backup_path/$db_name-$date-$i.sql

    # Eliminar el archivo SQL sin comprimir
    rm $backup_path/$db_name-$date-$i.sql
    # Imprimir el valor de $i
    echo "Se procesó la base de datos: $i"
    
    # Borrando registros con más de 30 días de antigüedad
    find $backup_path/* -mtime +30 -exec rm {} \;
done
