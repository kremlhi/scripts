#!/bin/sh

while sleep 1; do date +%T; done \
| awk 'BEGIN{ FS=":" }
{
	h = $1
	m = $2
	s = $3
	c = "%%"
	xs = 21
	xt = 40
	ys = 12
	yt = 13
	pi2 = 2*3.14

	printf "\033[2J\033[1;1;H" $0
	for(i = 0; i < pi2; i += 0.08) {
		x = int(xt + xs*cos(i))
		y = int(yt + ys*sin(i))
		printf "\033[" y ";" x "H" c
	}
	for(p = 0; p < ys; p++) {
		x = int(xt + (p*0.8)*cos(h*pi2/24 - pi2/4))
		y = int(yt + (p*0.6)*sin(h*pi2/24 - pi2/4))
		printf "\033[" y ";" x "H" c
	}
	for(p = 1; p < ys; p++) {
		x = int(xt + (p*1.3)*cos(m*pi2/60 - pi2/4))
		y = int(yt + (p*0.8)*sin(m*pi2/60 - pi2/4))
		printf "\033[" y ";" x "H" c
	}
	for(p = 1; p < ys; p++) {
		x = int(xt + (p*1.6)*cos(s*pi2/60 - pi2/4))
		y = int(yt + (p*0.9)*sin(s*pi2/60 - pi2/4))
		printf "\033[" y ";" x "H" c
	}
	fflush stdout
}'

