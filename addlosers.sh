#!/usr/bin/env bash 

parse_email(){
	sed -rn 's/^([^\.]+)([a-z\.]+)@(.*)$/\1/p;' <<< $1 
	# | awk '{sub("\\.", "", $2); gsub("\\.", " ", $2); print $1,"\""$2"\"",$3}'
}

addnextuser(){
	declare -l cnt
	while [[ $(grep $1$cnt /etc/passwd) && $(( cnt++ )) ]]; do :; done;
	tee >(xargs -a <(cat) useradd -ms /bin/bash) <<< $1$cnt 
	#echo $1$cnt
}

delallusers(){
	awk -F: "/^$1[0-9]*:/ { system(\"userdel \" \$1) }" /etc/passwd
}

genpasswd(){
	tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w $1 | head -n 1
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] || return 0 
[[ $(id -u) ==  0 ]] &&	while read line; do
		echo $(tee >(chpasswd) <<< $(addnextuser $(parse_email ${line})):$(genpasswd 8))@$(hostname)
	done || echo "Must be root suckah" 1>&2 &&  exit 1 


