#!/usr/bin/env python3

import logging
import random
import time

# logging.basicConfig(format='{"name":"%(name)s","level":"%(levelname)s","message:"%(message)s"}')
while True:

    number = random.randrange(0, 4)

    if number == 0:
        logging.info('Hello there!!')
    elif number == 1:
        logging.warning('Hmmm....something strange')
    elif number == 2:
        logging.error('OH NO!!!!!!')
    elif number == 3:
        logging.exception(Exception('this is exception'))

    time.sleep(1)