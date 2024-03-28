#!/bin/bash

prayers="$HOME/.local/share/prayers.json"

# WARNING: THIS SCRIPTS REMOVES ALL JOBS IN QUEUE "P" SCHEDULED USING AT
# ADJUST ACCORDINGLY
if [[ "$(at -q p -l | wc -l)" != "0" ]]; then
    for i in $(at -q p -l | awk '{ print $1 }'); do
        atrm $i
    done
fi

day_idx=$(( $(date +%d | awk '/^0.*/ {sub("0","")}{print}') - 1 ))
fajr=$(date -d "$(jq ".data[$day_idx].timings.Fajr" $prayers | bc)" '+%H:%M %F')
dhuhr=$(date -d "$(jq ".data[$day_idx].timings.Dhuhr" $prayers | bc)" '+%H:%M %F')
asr=$(date -d "$(jq ".data[$day_idx].timings.Asr" $prayers | bc)" '+%H:%M %F')
maghrib=$(date -d "$(jq ".data[$day_idx].timings.Maghrib" $prayers | bc)" '+%H:%M %F')
isha=$(date -d "$(jq ".data[$day_idx].timings.Isha" $prayers | bc)" '+%H:%M %F')

fajr_cmd='[[ "$(notify-send "Fajr prayer 🕌" -t 10000)" ]]'
dhuhr_cmd='[[ "$(notify-send "Dhuhr prayer 🕌" -t 10000)" ]]'
asr_cmd='[[ "$(notify-send "Asr prayer 🕌" -t 10000)" ]]'
maghrib_cmd='[[ "$(notify-send "Maghrib prayer 🕌" -t 10000)" ]]'
isha_cmd='[[ "$(notify-send "Isha prayer 🕌" -t 10000)" ]]'

echo "$fajr_cmd" | at -q p "$fajr"
echo "$dhuhr_cmd" | at -q p "$dhuhr"
echo "$asr_cmd" | at -q p "$asr"
echo "$maghrib_cmd" | at -q p "$maghrib"
echo "$isha_cmd" | at -q p "$isha"
