#!/bin/sh

default_sink_name=$(pw-metadata 0 'default.audio.sink' | grep 'value' | sed "s/.* value:'//;s/' type:.*$//;" | jq .name)
default_sink_id=$(pw-dump Node Device | jq '.[].info.props|select(."node.name" == '" $default_sink_name "')|."object.id"')
other_sink_id=$(pw-dump Node Device | jq '.[].info.props|select(."api.alsa.pcm.stream" == "playback")|select(."node.name" != '" $default_sink_name "') | ."object.id"')

echo $default_sink_id
echo $other_sink_id
wpctl set-default $other_sink_id
notify-send "Changed default audio sink to $other_sink_id"
