sudo avrdude -F -C /Applications/Arduino.app/Contents/Java/hardware/tools/avr/etc/avrdude.conf -p m328p -c stk500v1 -b 115200 -P /dev/cu.usbmodem1411 -U flash:w:serial-write.hex
