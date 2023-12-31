#!/usr/bin/bash
#

no_file () {
	count=`ls -1 "$1" 2>/dev/null | wc -l`
	return $count
}

# htmlheader ------------------------------------------------------

htmlheader () {
echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"
>
<html>
	<head>
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />
		<title>Movies, Series and Documentaries</title>
		<style>
			td {
			text-align: left;
			border-bottom: 1px solid #ddd;
			}
			th {
			text-align: center;
			background-color: #d0d0d0;
			border-bottom: 1px solid #ddd;
			}
			tr:hover {
			background-color: #ffff99;
			}
		</style>
	</head>
	<body>
"
}

# tablebody <tablename> <tablepath> -------------------------------

tablebody () {
echo "
	<h2>$1</h2>
	<table class=\"sortable\">
		<thead>
			<tr>
			<th>len</th>
			<th>WdthHght</th>
			<th>Title / Filename</th>
			<th>Mlen</th>
			<th>sub</th>
			</tr>
		</thead>
		<tbody>
"
cd $2
# the following find need to be modify according to the type of media we are looking for
find -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) -printf '%CY%Cm%Cd\t%p\n'|sort -r -n|cut -c 12- > /tmp/$1

while read file; do
	perl ${BASEPRGM}/mediainfo.pl "$file" "$1" "$BASEHTML" $SRVRINFO
done < /tmp/$1

echo "
		</tbody>
	</table>
"
}

# htmlfooter ------------------------------------------------------

htmlfooter () {
echo "
	<script src="tablesort/sort-table.js"></script>
	</body>
</html>
"
}

# section ---------------------------------------------------------
# if need be second param could be a function and the call would be done on the name

section () {
	if [ ! -f /tmp/${1}.html ]
	then
		if [ -d ${BASEHTML}/sub/$1 ]
		then
			if no_file ${BASEHTML}/sub/${1}/*.html
			then
				echo "empty sub"
			else
				echo "erasing old sub content"
				rm ${BASEHTML}/sub/${1}/*.html
			fi
		else
			mkdir ${BASEHTML}/sub/$1
		fi

		tablebody "$1" "${BASEDATA}/$1" > /tmp/${1}.html
	fi
}

# main ------------------------------------------------------------

BASEHTML="/srv/www/htdocs/Media"
BASEDATA="/srv/exthd/media/DATA/Media"
BASEPRGM="/root/work2"
SRVRINFO="http://192.168.101.228/Media"
SECTIONS="Movies Series Divers ARTE YT"

TARGET="$1"

if [ ! -d ${BASEHTML}/sub ]
then
	mkdir ${BASEHTML}/sub
fi

if [ ! -z $1 ]
then
	if [ -f /tmp/$1 ]
	then
		rm /tmp/$1
	fi

	if [ -f /tmp/${1}.html ]
	then
		rm /tmp/${1}.html
	fi
fi


htmlheader > ${BASEHTML}/movies.html

for sect in $SECTIONS
do
#	generate sections
	section $sect
#	assemble sections
	cat /tmp/${sect}.html >> ${BASEHTML}/movies.html
done

htmlfooter >> ${BASEHTML}/movies.html

