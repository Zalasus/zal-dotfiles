#!/bin/bash

rofi -show drun \
    -modi drun,,run \
    -run-command "/bin/bash -i -c '{cmd}'"

