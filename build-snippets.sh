#!/bin/bash

# helper function
function contains() {
	# from http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
	local n=$#
	local value=${!n}
	for ((i=1;i < $#;i++)) {
		if [ "${!i}" == "${value}" ]; then
			echo "y"
			return 0
		fi
	}
	echo "n"
	return 1
}

# prepare the filename template
filename='snippets/lodash-@type-modules-@kebabPath.sublime-snippet'

# prepare the list of native methods
native=("isFinite" "isNaN")

# use lodash-cli to build the list of methods
./node_modules/.bin/lodash modularize

# remove the files that we don't care about
rm -f modularize/*.js
rm -rf modularize/internal

# read in the snippets
esSnippet=$(cat './snippet-es.xml')
cjsSnippet=$(cat './snippet-cjs.xml')

# and let 'er rip!
for path in modularize/**/*.js; do
	# remove the .js from the filename
	path=$(echo "$path" | cut -d'.' -f1)

	# 'path' looks like 'modularize/array/chunk'
	# the 'collection' is the second folder name -- field 2
	collection=$(echo "$path" | cut -d'/' -f2)
	# the 'method' is the third folder name -- field 3
	method=$(echo "$path" | cut -d'/' -f3)

	# if the method is in the array of native functions, then put an
	# underscore in front of it.
	safeMethod=$method
	if [ "$(contains "${native[@]}" "$method")" == "y" ]; then
		safeMethod="_$method"
	fi

	# compute the destination filename
	dest=$(echo $filename | sed s/'@kebabPath'/"$collection-$method"/)

	# output the commonjs snippet for this method
	commonjsDest=$(echo "$dest" | sed s/'@type'/"cjs"/)
	echo "$cjsSnippet" \
		| sed s/'@var'/"$safeMethod"/g \
		| sed s/'@method'/"$method"/g \
		| sed s/'@collection'/"$collection"/g \
		> "$commonjsDest"

	# output the es2015 snippet for this method
	esDest=$(echo "$dest" | sed s/'@type'/"es"/)
	echo "$esSnippet" \
		| sed s/'@var'/"$safeMethod"/g \
		| sed s/'@method'/"$method"/g \
		| sed s/'@collection'/"$collection"/g \
		> "$esDest"
done
