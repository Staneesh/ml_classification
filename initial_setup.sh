#!/bin/sh

apt-get update && apt-get install -y python3.8 python3-pip python3.8-venv vim

python3.8 -m venv env && . env/bin/activate

pip install -r requirements.txt

mkdir output

pip freeze > output/requirements.txt

