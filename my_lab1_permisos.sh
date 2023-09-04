#!/bin/bash

#Parte 1----Creación del archivo y sus permisos


get_file_permissions() {
    local file="$1"
    
#Sección donde se verifica si el archivo existe

    if [ ! -e "$file" ]; then
        echo "Hay un ERROR-el archivo querido '$file' no existe.-por favor intentarlo de nuevo"
        exit 1
    fi
    
#Sección para conseguir los permisos del archivo

    Vari01=$(stat -c "%A" "$file")

#Función para crear variables y tener permisos verbales

    get_permissions_verbose() {
        local perm_string="$1"
        per_usua=""
        per_grup=""
        per_otros_usua=""

#Creación de una cadena de permisos

        for ((i = 1; i <= 9; i++)); do
            perm="${perm_string:i-1:1}"
            case $((i % 3)) in
                1)
                    per_usua+=$(interpret_permission "$perm")
                    ;;
                2)
                    per_grup+=$(interpret_permission "$perm")
                    ;;
                0)
                    per_otros_usua+=$(interpret_permission "$perm")
                    ;;
            esac
        done

        echo "Permisos del usuario: $per_usua"
        echo "Permisos del grupo: $per_grup"
        echo "Permisos de otros: $per_otros_usua"
    }

#Se llama la función de permisos

    get_permissions_verbose "$Vari01"
}

#Se lee los permisos que se le otorgaron

interpret_permission() {
    case "$1" in
        "r")
            echo "read-leer"
            ;;
        "w")
            echo "write-escribir"
            ;;
        "x")
            echo "execution-ejecución"
            ;;
        *)
            echo "unknown-desconocido"
            ;;
    esac
}

#Parte 2----Limitación de permisos

limit_execution_permissions() {
    local username="Lemeche"
    local groupname="lab1"
    local new_username="dylanna"

#Confirmar si el usario existe

    if id "$username" &>/dev/null; then
        echo "El usuario '$username' existe"
    else

#Se hace un nuevo usuario con el nombre de Lemeche que es mi gato

        sudo useradd "$username"
        echo "Se creó el usuario '$username'"
    fi

#Se confirma si el grupo existe

    if grep -q "$groupname" /etc/group; then
        echo "El grupo '$groupname' existe"
    else
        # Crea un nuevo grupo con el nombre proporcionado
        sudo groupadd "$groupname"
        echo "Se creó el grupo '$groupname'"
    fi

#Se inscribe mi usuario dylanna al grupo

    sudo usermod -aG "$groupname" "$new_username"

#De la parte 1 ahora se aplica a los miembros del grupo 

    chmod 750 "$0"
    echo "Los permisos en este script solo son permitidos para el grupo '$groupname'"
}

#Se confirma se dió el nombre de archivo

if [ $# -eq 0 ]; then
    echo "ERROR- Facilete un archivo como argumento"
    exit 1
fi

#Comprobación de primer argumento

if [ "$1" == "--limitar" ]; then

#Si el primer argumento es "--limitar", ejecuta la función de limitar permisos

    limit_execution_permissions
else
# Si no, ejecuta la función de obtener permisos del archivo

    get_file_permissions "$1"
fi


