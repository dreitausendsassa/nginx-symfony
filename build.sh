#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$DIR"

docker build -t kempkensteffen/nginx-symfony:7.2-dev . && docker push kempkensteffen/nginx-symfony:7.2-dev