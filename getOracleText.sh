
tmp=$(mktemp)
curl "$1" | html2text > $tmp
# read from beginning of the variable text
for i in {44..66}; do if [ "$(cat $tmp | awk NR==$i | grep -o "removed or deprecated")" == "removed or deprecated" ]; then 
	beginningText=$i; break; fi; done
# to the end
for i in {58..9999}; do if [ "$(cat $tmp | awk NR==$i | grep -o "«_Previous • Trail • Next_»")" == "«_Previous • Trail • Next_»" ]; then 
	endText=$i; break; fi; done
	filename=$(basename $1 | cut -d . -f1)
cat $tmp | awk "NR>$beginningText && NR<$endText" > $filename
echo "controll: line 1 && last line"
lastLine=$(cat $filename | wc -l)
cat $filename | awk "NR==1 || NR==$lastLine"
wc -l $filename
