#!/bin/bash

# Функция для ожидания доступности порта
wait_for_port() {
    local host=$1
    local port=$2
    local timeout=10  
    local start_time=$(date +%s)

    local nc_command="nc"
    type $nc_command >/dev/null 2>&1 || nc_command="ncat"

    while ! $nc_command -z "$host" "$port" >/dev/null 2>&1; do
        sleep 1
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        echo "trying to connect to pg via $host:$port"

        if [[ $elapsed -ge $timeout ]]; then
            echo "Unable to connect to pg"
            exit 1
        fi
    done
}


# Ожидание доступности порта
wait_for_port "localhost" 5432

# Запуск Django приложения
python manage.py runserver 0.0.0.0:8000
