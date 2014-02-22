#!/usr/bin/awk -f

BEGIN{ FS = ":[ \t]+" }

/\[Events\]/{ events++ }
!events{ next }

$1 == "Format"{
	len = split($2, a, /, */)
	for(i = 1; i <= len; i++){
		if(a[i] ~ /^Start/) starti = i
		else if(a[i] ~ /^End/) endi = i
		else if(a[i] ~ /^Text/) texti = i
	}
}

$1 == "Dialogue"{
	split($2, a, /,/)
	sub(/\./, ",", a[starti])
	sub(/\./, ",", a[endi])
	sub(/^[0-9]:/, "0&", a[starti])
	sub(/^[0-9]:/, "0&", a[endi])

	for(i = 1; i < texti; i++) sub(/[^,]*,/, "")
	gsub(/\{[^}]*\}/, "")
	gsub(/\\[Nn]/, "\n")

	print ++n
	print a[starti] "0 --> " a[endi] "0"
	print
	print ""
}

