#!/bin/bash

rofi -show calc \
    -modi calc \
    -calc-command "echo -n '{result}' | xclip"

