#!/bin/bash
pip install --upgrade pip==20.1
pip install virtualenv
virtualenv rsvpapp --system-site-packages -v
source rsvpapp/bin/activate
pip install -r requirements.txt
pytest tests/test_rsvpapp.py
