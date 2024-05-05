use std::sync::Arc;

use celery::{task::TaskResult, Celery};

#[tokio::main]
async fn main() {
    color_eyre::install().expect("color_eyre");
    tracing_subscriber::fmt::init();

    run().await;
}

#[celery::task]
pub fn py_test_task(prompt: String) -> TaskResult<String> {
    unimplemented!()
}

pub async fn run() {
    let app: Arc<Celery> = celery::app!(
        broker = AmqpBroker { std::env::var("AMQP_ADDR").unwrap() },
        // broker = RedisBroker { std::env::var("REDIS_ADDR").unwrap() },
        backend = RedisBackend { std::env::var("REDIS_ADDR").unwrap() },
        tasks = [py_test_task],
        task_routes = [
            "py_test_task" => "python_queue",
        ],
    )
    .await
    .expect("app");

    let task = py_test_task::new("hello".to_string());
    let result = app.send_task(task).await.expect("send_task");
    let result = result.get().fetch().await.expect("fetch result");
    dbg!(result);

    app.close().await.expect("close");
}
