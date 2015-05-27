for f in *; do mv "$f" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done
rename -v 's/ /_/g' *
for f in *; do mv "$f" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done	

