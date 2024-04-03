#!/bin/bash

prayers_json="$HOME/.local/share/prayers.json"
day_idx=$(($(date +%-d) - 1))
declare -A hijri
hijri=(
        ['today_ar']=$(jq -r ".data[$day_idx].date.hijri.weekday.en" "$prayers_json")
        ['daynumber']=$(jq -r ".data[$day_idx].date.hijri.day" "$prayers_json")
        ['month_ar']=$(jq -r ".data[$day_idx].date.hijri.month.en" "$prayers_json")
        ['year']=$(jq -r ".data[$day_idx].date.hijri.year" "$prayers_json")
)

timeof() {
        [[ "$#" -ne "1" ]] && echo "exactly 1 argument is needed" && return 1
        echo -n "$(date -d "$(jq -r ".data[$day_idx].timings.$1" "$prayers_json")" '+%I:%M')"
}

print() {
        echo -en "📅 ${hijri[today_ar]},\n ${hijri[daynumber]}-${hijri[month_ar]}-${hijri[year]} \n ۞ Fajr\t\t\t\t$(timeof Fajr) \n ۞ Sunrise\t\t\t$(timeof Sunrise) \n ۞ Dhuhr\t\t\t$(timeof Dhuhr) \n ۞ Asr\t\t\t\t$(timeof Asr) \n ۞ Maghrib\t\t\t$(timeof Maghrib) \n ۞ Isha\t\t\t\t$(timeof Isha)"
}

yad-text() {
        echo -en "📅 ${hijri[today_ar]},\n ${hijri[daynumber]}-${hijri[month_ar]}-${hijri[year]} \n ۞ Fajr\t\t\t\t$(timeof Fajr) \n ۞ Sunrise\t\t\t$(timeof Sunrise) \n ۞ Dhuhr\t\t\t$(timeof Dhuhr) \n ۞ Asr\t\t\t\t$(timeof Asr) \n ۞ Maghrib\t\t\t$(timeof Maghrib) \n ۞ Isha\t\t\t\t$(timeof Isha)"
}

yad-toggle() {
    yad --no-buttons --text-width=10 --text "$(yad-text)" --title "Prayers"
}

case "$1" in
yad)
        yad-toggle
        ;;
*)
        print
        ;;
esac
