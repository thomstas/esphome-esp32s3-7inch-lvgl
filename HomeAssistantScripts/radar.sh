#!/bin/bash

OWM_API_KEY="your API key"
DIR="/config/www"

# --- FONT ---

FONT="$DIR/font.ttf"

# --- FILES FOR POLAND ---
MAPA_PL="$DIR/mapa_poludnie.png"
GOTOWY_PL="$DIR/gotowy_radar.png"
CHMURY_PL="$DIR/tmp_c_pl.png"
DESZCZ_PL="$DIR/tmp_r_pl.png"
PIORUNY_PL="$DIR/tmp_l_pl.png"

# --- FILES EUROPE ---
MAPA_EU="$DIR/mapa_europa.png"
GOTOWY_EU="$DIR/gotowy_radar_europa.png"
CHMURY_EU="$DIR/tmp_c_eu.png"
DESZCZ_EU="$DIR/tmp_r_eu.png"
PIORUNY_EU="$DIR/tmp_l_eu.png"

PUSTA="$DIR/pusta_warstwa.png"

# 1. Downloading metadata and time
RV_DATA=$(curl -s "https://api.rainviewer.com/public/weather-maps.json")
RV_PATH=$(echo "$RV_DATA" | jq -r '.radar.past[-1].path')
RV_L_PATH=$(echo "$RV_DATA" | jq -r '.lightning[-1].path')
TIME_UNIX=$(echo "$RV_DATA" | jq -r '.radar.past[-1].time')

# Saving time (HH:MM) to a text file (old method - leaving it, doesn't hurt)
date -d "@$TIME_UNIX" +"%H:%M" > "$DIR/radar_time.txt"

# Time format for FFmpeg (MUST HAVE "\" before the colon!)
TIME_FORMAT=$(date -d "@$TIME_UNIX" +"%H\:%M")

# ========================================================
# STEP 1: POLAND (ZOOM 7)
# ========================================================
for X in 70 71 72; do
    for Y in 42 43; do
        curl -s -f -o "$DIR/c_pl_${X}${Y}.png" "https://tile.openweathermap.org/map/clouds_new/7/${X}/${Y}.png?appid=$OWM_API_KEY" || cp "$PUSTA" "$DIR/c_pl_${X}${Y}.png"
        curl -s -f -o "$DIR/r_pl_${X}${Y}.png" "https://tilecache.rainviewer.com${RV_PATH}/256/7/${X}/${Y}/2/1_1.png" || cp "$PUSTA" "$DIR/r_pl_${X}${Y}.png"
        if [ "$RV_L_PATH" != "null" ]; then
            curl -s -f -o "$DIR/l_pl_${X}${Y}.png" "https://tilecache.rainviewer.com${RV_L_PATH}/256/7/${X}/${Y}/0/1_1.png" || cp "$PUSTA" "$DIR/l_pl_${X}${Y}.png"
        else
            cp "$PUSTA" "$DIR/l_pl_${X}${Y}.png"
        fi
    done
done

# Stitching Poland
ffmpeg -y -i "$DIR/c_pl_7042.png" -i "$DIR/c_pl_7142.png" -i "$DIR/c_pl_7242.png" -i "$DIR/c_pl_7043.png" -i "$DIR/c_pl_7143.png" -i "$DIR/c_pl_7243.png" -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[t];[3:v][4:v][5:v]hstack=inputs=3[b];[t][b]vstack=inputs=2,scale=800:480" -update 1 "$CHMURY_PL"
ffmpeg -y -i "$DIR/r_pl_7042.png" -i "$DIR/r_pl_7142.png" -i "$DIR/r_pl_7242.png" -i "$DIR/r_pl_7043.png" -i "$DIR/r_pl_7143.png" -i "$DIR/r_pl_7243.png" -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[t];[3:v][4:v][5:v]hstack=inputs=3[b];[t][b]vstack=inputs=2,scale=800:480" -update 1 "$DESZCZ_PL"
ffmpeg -y -i "$DIR/l_pl_7042.png" -i "$DIR/l_pl_7142.png" -i "$DIR/l_pl_7242.png" -i "$DIR/l_pl_7043.png" -i "$DIR/l_pl_7143.png" -i "$DIR/l_pl_7243.png" -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[t];[3:v][4:v][5:v]hstack=inputs=3[b];[t][b]vstack=inputs=2,scale=800:480" -update 1 "$PIORUNY_PL"

# Final Mix Poland (WITH TEXT AND DARKENED CLOUDS!)
ffmpeg -y -i "$MAPA_PL" -i "$CHMURY_PL" -i "$DESZCZ_PL" -i "$PIORUNY_PL" \
-filter_complex "[1:v]colorchannelmixer=rr=0.6:gg=0.6:bb=0.6:aa=1.5[chwz];[0:v][chwz]overlay=0:0[bg1];[bg1][2:v]overlay=0:0[bg2];[bg2][3:v]overlay=0:0,drawtext=text='RADAR PL\: $TIME_FORMAT':fontfile=$FONT:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.6:boxborderw=5:x=15:y=440" \
-pix_fmt rgba -update 1 "$GOTOWY_PL"

# ========================================================
# STEP 2: EUROPE (ZOOM 4)
# ========================================================
for X in 7 8 9; do
    for Y in 4 5; do
        curl -s -f -o "$DIR/c_eu_${X}${Y}.png" "https://tile.openweathermap.org/map/clouds_new/4/${X}/${Y}.png?appid=$OWM_API_KEY" || cp "$PUSTA" "$DIR/c_eu_${X}${Y}.png"
        curl -s -f -o "$DIR/r_eu_${X}${Y}.png" "https://tilecache.rainviewer.com${RV_PATH}/256/4/${X}/${Y}/2/1_1.png" || cp "$PUSTA" "$DIR/r_eu_${X}${Y}.png"
        if [ "$RV_L_PATH" != "null" ]; then
            curl -s -f -o "$DIR/l_eu_${X}${Y}.png" "https://tilecache.rainviewer.com${RV_L_PATH}/256/4/${X}/${Y}/0/1_1.png" || cp "$PUSTA" "$DIR/l_eu_${X}${Y}.png"
        else
            cp "$PUSTA" "$DIR/l_eu_${X}${Y}.png"
        fi
    done
done

# Stitching Europe
ffmpeg -y -i "$DIR/c_eu_74.png" -i "$DIR/c_eu_84.png" -i "$DIR/c_eu_94.png" -i "$DIR/c_eu_75.png" -i "$DIR/c_eu_85.png" -i "$DIR/c_eu_95.png" -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[t];[3:v][4:v][5:v]hstack=inputs=3[b];[t][b]vstack=inputs=2,scale=800:480" -update 1 "$CHMURY_EU"
ffmpeg -y -i "$DIR/r_eu_74.png" -i "$DIR/r_eu_84.png" -i "$DIR/r_eu_94.png" -i "$DIR/r_eu_75.png" -i "$DIR/r_eu_85.png" -i "$DIR/r_eu_95.png" -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[t];[3:v][4:v][5:v]hstack=inputs=3[b];[t][b]vstack=inputs=2,scale=800:480" -update 1 "$DESZCZ_EU"
ffmpeg -y -i "$DIR/l_eu_74.png" -i "$DIR/l_eu_84.png" -i "$DIR/l_eu_94.png" -i "$DIR/l_eu_75.png" -i "$DIR/l_eu_85.png" -i "$DIR/l_eu_95.png" -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[t];[3:v][4:v][5:v]hstack=inputs=3[b];[t][b]vstack=inputs=2,scale=800:480" -update 1 "$PIORUNY_EU"

# Final Mix Europe (WITH TEXT!)
ffmpeg -y -i "$MAPA_EU" -i "$CHMURY_EU" -i "$DESZCZ_EU" -i "$PIORUNY_EU" \
-filter_complex "[1:v]colorchannelmixer=aa=1.5[chwz];[0:v][chwz]overlay=0:0[bg1];[bg1][2:v]overlay=0:0[bg2];[bg2][3:v]overlay=0:0,drawtext=text='RADAR EU\: $TIME_FORMAT':fontfile=$FONT:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.6:boxborderw=5:x=15:y=440" \
-pix_fmt rgba -update 1 "$GOTOWY_EU"

# --- CLEANUP (Forced cleanliness) ---
rm -f "$DIR"/c_pl_*.png "$DIR"/r_pl_*.png "$DIR"/l_pl_*.png
rm -f "$DIR"/c_eu_*.png "$DIR"/r_eu_*.png "$DIR"/l_eu_*.png
rm -f "$CHMURY_PL" "$DESZCZ_PL" "$PIORUNY_PL"
rm -f "$CHMURY_EU" "$DESZCZ_EU" "$PIORUNY_EU"
