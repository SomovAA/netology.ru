#!/usr/bin/env python3

import random
import time
import sentry_sdk

sentry_sdk.init(
    dsn="https://37c3f089043d431ca312e020444833ff@o4504998120521728.ingest.sentry.io/4504998136184832",
    environment="test",
    release="1.0.0"
)

if __name__ == "__main__":
    while True:
        number = random.randrange(0, 4)

        if number == 0:
            division_zero = 1/0
        elif number == 1:
            raise Exception('exception')
        elif number == 2:
            open("log.json", "r")
        elif number == 3:
            print('success')

        time.sleep(1)
