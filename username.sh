#!/bin/bash

fil=/etc/passwd
uid=
f_lag=


for el in "$@"; do

    if [ "$el" == "-f" ]; then

        f_lag=1

        continue

    fi

    if [[ "$f_lag" ]]; then

        fil="$el"

        f_lag=

        continue

    fi

    uid="$el"

done

if [ ! -f "$fil" ]; then

  echo "Ошибка: файл не найден" >&2

  exit 1

fi

line=$(grep "x:$uid:" "$fil")

user=$(echo "$line" | cut -d: -f1)

if [ ! "$line" ]; then

  echo "Ошибка: пользователь не найден" >&2

  exit 1

fi

echo "$user"

exit 0
