#!/bin/bash

echo 
echo --------------------------------------------------------------------------------
echo --------- Setting up Python Virtual Environment -------------
echo --------------------------------------------------------------------------------
echo 

# create a .env file from .env-template file
if [ -f ".env-template" ] && [ ! -f ".env" ]; then
    cp .env-template .env
fi

# create a virtual environment named .venv
if [ ! -d ".venv" ]; then
	python3 -m venv .venv
fi

# activate the newly created virtual environment
source .venv/bin/activate

# upgrade .venv python-pip
python -m pip install --upgrade pip

# install pipenv
pip install pipenv

if [[ "$1" == "--dev" ]]; then
	pipenv install --dev
    
    # uncomment to use detect-secrets pre-commit hook
	# if [ ! -f ".secrets.baseline" ]; then
	# 	detect-secrets scan >.secrets.baseline
	# fi
	# pre-commit install

else
	pipenv install
fi