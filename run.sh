#!/bin/bash
set -x

#enable i2c interface
#dtparam i2c_arm=on
modprobe i2c-dev

#enable spi interface
#dtparam spi=on
sleep 1

mod_dir="/app/modules"

modprobe snd-soc-simple-card-utils
insmod $mod_dir/snd-soc-seeed-voicecard.ko
insmod $mod_dir/snd-soc-ac108.ko
insmod $mod_dir/snd-soc-wm8960.ko

sleep 1

hw=$(aplay -l | grep seeed2micvoicec | awk '{print $2}' | sed 's/://')

cp /etc/voicecard/asound_2mic.conf /etc/asound.conf

echo "get old hw number"
old=$(cat /etc/asound.conf | grep hw: | awk 'NR==1 {print $2}' | sed 's/\"//g')

echo "replace new hw:${hw},0"
sed -i -e "s/${old}/hw:${hw},0/g" /etc/asound.conf

cp /etc/voicecard/wm8960_asound.state /var/lib/alsa/asound.state

alsactl restore

#Fore 3.5mm ('headphone') jack
amixer cset numid=3 1 

# start our node app...
npm start
