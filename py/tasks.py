import argparse
import os
import sys
import time

from celery import Celery
from celery.bin.celery import main as _main


my_app = Celery("celery", broker=os.environ.get("AMQP_ADDR", "amqp://127.0.0.1:5672"))
my_app.conf.update(
    result_backend="redis://localhost:6379/",
    # task_ignore_result=True,
    task_routes=(
        [
            ("py_test_task", {"queue": "python_queue"}),
            ("test_task", {"queue": "rust_queue"}),
            ("*", {"queue": "celery"}),
            # ("*", {"queue": "python_queue"}),
        ]
    ),
)


@my_app.task(name="py_test_task")
def py_test_task(prompt):
    print("WAS HERE?")
    return "Answer!"



if __name__ == "__main__":
#    main()
    sys.argv = [
        "celery",
        "--app=py.tasks",
        "worker",
        "--queues=python_queue",
        "--loglevel=info",
    ]
    _main()

