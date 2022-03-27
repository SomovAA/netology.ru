#!/usr/bin/env bash

while ((1==1))
do
        curl http://localhost:81
        if (($? != 0))
        then
                date >> curl.log
        else
                break
        fi
done