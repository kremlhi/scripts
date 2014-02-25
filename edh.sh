#!/bin/sh

# http://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange#Explanation_including_encryption_mathematics

lm='function pow(x, y){
	for(res=1; y; ){
		if(y%2 == 1) res *= x
		y /= 2
		x *= x
	}
	return res
}'

mkfifo pipe

awk "$lm"'
BEGIN{
	name = "bob"
	b = 15
}
{ print name, "<", $0 > "/dev/stderr" }
$1 == "p"{ p = $2 }
$1 == "g"{ g = $2 }
$1 == "A"{
	A = $2 
	B = pow(g, b)%p
	s = pow(A, b)%p
	print "B", B
	print name, ":", "s", s > "/dev/stderr"
	fflush(stdout)
}' <pipe \
| awk "$lm"'
BEGIN{
	name = "alice"
	a = 6
	p = 23
	g = 5
	print "p", p
	print "g", g
	A = pow(g, a)%p
	print "A", A
	fflush(stdout)
}
{ print name, "<", $0 > "/dev/stderr" }
$1 == "p"{ p = $2 }
$1 == "g"{ g = $2 }
$1 == "B"{
	B = $2
	s = pow(B, a)%p
	print name, ":", "s", s > "/dev/stderr"
	exit(0)
}' >pipe

rm pipe

