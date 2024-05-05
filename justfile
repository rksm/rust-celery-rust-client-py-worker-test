default:
    just --list

rust:
    cd rust && cargo run

py:
    python py/tasks.py

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# redis

redis-docker:
    docker run --rm -d -p 6379:6379 --name redis-celery-test redis/redis-stack

redis-docker-stop:
    docker stop redis-celery-test

redis-cli *args="":
    docker exec -it redis-celery-test redis-cli {{ args }}

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# rabbitmq

rabbitmq-docker:
    docker run --rm -d -p 5672:5672 -p 15672:15672 --name rabbitmq-celery-test rabbitmq:3-management

rabbitmq-docker-stop:
    docker stop rabbitmq-celery-test

rabbitmq-open:
    @echo "User: guest"
    @echo "Password: guest"
    xdg-open http://localhost:15672

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

docker-start:
    just redis-docker
    just rabbitmq-docker

docker-stop:
    just redis-docker-stop
    just rabbitmq-docker-stop
