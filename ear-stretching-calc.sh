#!/bin/bash

if [ -z "$1" ]; then
  echo -e "\033[31mBitte gib die Stretching-Grösse als ersten Parameter an. \U1F644\033[0m"
  exit 1
else
  stretch_size=$1
fi

if [[ $stretch_size =~ ^[0-9]+mm$ ]]; then
  stretch_size=$(echo $stretch_size | tr -dc '0-9')
fi

if (( stretch_size < 2 || stretch_size > 50 )); then
  echo -e "\033[31mDie Stretching-Grösse muss zwischen 2 und 50 liegen. \U1F644\033[0m"
  exit 1
fi

current_size=$2

if [ -z "$current_size" ]; then
  current_size=0
fi

if [[ $current_size =~ ^[0-9]+mm$ ]]; then
  current_size=$(echo $current_size | tr -dc '0-9')
fi


if (( current_size < 0 || current_size > 50 )); then
  echo -e "\033[31mDie aktuelle Grösse muss zwischen 0 und 50 liegen. \U1F644\033[0m"
  exit 1
fi

if (( current_size > stretch_size )); then
  echo -e "\033[31mEar Stretching Verheilungen sind noch nicht unterstützt. \U1F644\033[0m"
  exit 1
fi

if (( current_size == stretch_size )); then
  echo -e "\033[31mDu möchtest also nichts tun? \U1F644\033[0m"
  exit 1
fi

step_time=$((4 * 7 * 24 * 60 * 60))

time_needed=$((($stretch_size - $current_size) * $step_time))

num_steps=$((($stretch_size - $current_size) / 2))

current_date=$(date +%s)
estimated_date=$(date -d "@$((current_date + time_needed))" +%d.%b\ %Y)

if [ "$current_size" -eq 0 ]; then
  time_in_weeks=$(( $num_steps * 4 + 4 ))
else
  time_in_weeks=$(( $num_steps * 4 ))
fi

if (( time_in_weeks > 52 )); then
  time_in_years=$(($time_in_weeks / 52))
  echo -e "Geschätzte Zeit: ~$time_in_years Jahr(e)"
else
  echo -e "Geschätzte Zeit: ~$time_in_weeks Woche(n)"
fi
echo -e "Geschätztes Datum: $estimated_date"
echo
echo -e "Anzahl der Dehnschritte: $num_steps"

for (( i=1; i<=$num_steps; i++ ))
do
  step_size=$(($current_size + $i * 2))
  step_time_needed=$((($step_size - $current_size) * $step_time))

  if [ "$i" -eq 1 ] && [ "$current_size" -eq 0 ]; then
    step_time_needed=$((step_time_needed + 4 * 7 * 24 * 60 * 60))
  fi

  step_date=$(date -d "@$((current_date + step_time_needed))" +%d.%b\ %Y)
  echo -e "\033[34mDehnschritt $i ($step_size mm): $step_date \U1F449\033[0m"
done

