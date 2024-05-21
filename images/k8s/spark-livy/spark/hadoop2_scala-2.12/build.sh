#!/bin/bash

docker build -t spark-livy/builder:hadoop2 . $@
