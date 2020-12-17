#!/bin/bash

docker stop $(docker ps -qa)

docker-compose build

echo "#####################";
echo "##### JSON API ######";
echo "#####################";

cp .env.example .env

docker-compose up -d

docker exec jsonapi_php composer install
docker exec jsonapi_php php artisan migrate:fresh
docker exec jsonapi_php php artisan migrate:fresh --env testing
docker exec jsonapi_php chmod -R 775 storage
docker exec jsonapi_php chown -R 1000:www-data storage bootstrap/cache
docker exec jsonapi_php php artisan storage:link
docker exec jsonapi_php php artisan key:generate

##### START SERVICES #####
docker-compose down
docker-compose up -d
