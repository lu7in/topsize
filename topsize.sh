#!/bin/bash

N=999999999999999
minsize=1
format=
sep=
directories=()  # Текущий каталог по умолчанию

while [[ $# -gt 0 ]]; do  # Количество аргументов > 0

    case "$1" in

        --) 
            if [[ $sep -eq 0 ]]; then 

            	shift

                while IFS= read -r line; do

                    directories+=( "$line" ) 

                done < <( find "$1" -type d )

                break

        	fi

            ;;

        --help)

            if [[ ! "$sep" ]]; then

          		echo "topsize.sh [--help] [-h] [-N] [-s minsize] [--] [dir...]"

                exit 0

            fi

                ;;

        -s)
            if [[ ! "$sep" ]]; then
            
                shift

                minsize="$1"
            fi

            ;;

        -h)
            if [[ ! "$sep" ]]; then

                format="-h"

            fi

            ;;

        -*)
            if [[ ! "$sep" ]]; then
            
                if ! [[ "${1:1}" =~ ^[0-9]+$ ]]; then

                    echo "Опции $1 не существует" >&2
            
                    exit 1      

                else
                    
                    N="${1:1}"

                fi
            fi

            ;;

        *)	
        	if [[ -z $(find "$1" -type d) ]]; then

			    echo "Каталог $1 не существует" 

			    exit 1


		    else

			    while IFS= read -r line; do

                    directories+=( "$line" ) 

                done < <( find "$1" -type d )

                shift

		    fi  

            ;;
    esac

    shift

done

find "${directories[@]}" -type f -size +"$minsize"c -exec du -b "$format" {} + | sort -rh | head -n "$N" 

