Example to test https://github.com/rusty-celery/rusty-celery/pull/372#issuecomment-2092433907.

If you have nix installed just run `direnv allow` to setup the python and rust dependencies. Otherwise make sure you have python and Rust and have the python dependencies installed (celery, redis, etc).

Start redis and rabbitmq: `just docker-start`.

Start the python worker: `just py`.

Start the rust client: `just rs`.

Afterwards stop docker with `just docker-stop`.
