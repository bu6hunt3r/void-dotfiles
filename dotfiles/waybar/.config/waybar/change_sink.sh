#!/bin/sh

default_sink=$(pw-metadata 0 "default_audio_sink" | grep 'vallue')

echo "default sink: $default_sink"
