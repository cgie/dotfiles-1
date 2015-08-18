#! /bin/sh
for file in *.ogg
	do
		  ogg123 -d raw -f - "$file" |
		    lame -h -m s -b 192 - "$(basename "$file" .ogg).mp3"
			done
