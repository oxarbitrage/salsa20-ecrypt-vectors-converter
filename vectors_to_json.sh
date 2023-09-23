# Convert a trimmed version of the Salsa20 ECRYPT test vectors of 128 or 256 key bits to JSON. 

tmpfile="ecrypt.tmp"

function usage()
{
    echo "Usage:"
    echo "$0 128/256 ecrypt-test-vectors-file output-json-file"
}

if [ $# -lt 3 ]; then
	usage
    exit 1
fi

re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
	echo "Not a number"
   	exit 1
fi

if [ $1 -ne 128 ] && [ $1 -ne 256 ]; then
	echo "Invalid $1. Must be 128 or 256"
	exit 1
fi

cat "$2" | grep -v -e "^====" -e "Test" -e "^$" | while read name; do
	read key1
	if [ $1 = 256 ]; then
		read key2
	fi
	read iv
	read stream1part1; read stream1part2; read stream1part3; read stream1part4
	read stream2part1; read stream2part2; read stream2part3; read stream2part4
	read stream3part1; read stream3part2; read stream3part3; read stream3part4
	read stream4part1; read stream4part2; read stream4part3; read stream4part4
	read xorpart1; read xorpart2; read xorpart3; read xorpart4

	name2=$(echo $name | tr -cd '[:alnum:]')

	index1=$(echo "$stream1part1" | awk -F. '{print $1}' | awk -F'[' '{print $2}')
	index2=$(echo "$stream2part1" | awk -F. '{print $1}' | awk -F'[' '{print $2}')
	index3=$(echo "$stream3part1" | awk -F. '{print $1}' | awk -F'[' '{print $2}')
	index4=$(echo "$stream4part1" | awk -F. '{print $1}' | awk -F'[' '{print $2}')

	args=(
		--arg key1 "$(echo $key1 | awk '{print $NF}')"
		$(if [ $1 = 256 ]; then echo "--arg key2 $(echo $key2 | awk '{print $NF}')"; fi)
		--arg iv "$(echo $iv | awk '{print $NF}')"
		--argjson stream1index "$(echo $index1)"
		--arg stream1expected "$(echo $stream1part1 | awk '{print $NF}')$(echo $stream1part2)$(echo $stream1part3)$(echo $stream1part4)"
		--argjson stream2index "$(echo $index2)"
		--arg stream2expected "$(echo $stream2part1 | awk '{print $NF}')$(echo $stream2part2)$(echo $stream2part3)$(echo $stream2part4)"
		--argjson stream3index "$(echo $index3)"
		--arg stream3expected "$(echo $stream3part1 | awk '{print $NF}')$(echo $stream3part2)$(echo $stream3part3)$(echo $stream3part4)"
		--argjson stream4index "$(echo $index4)"
		--arg stream4expected "$(echo $stream4part1 | awk '{print $NF}')$(echo $stream4part2)$(echo $stream4part3)$(echo $stream4part4)"
		--arg xordigest "$(echo $xorpart1 | awk '{print $NF}')$(echo $xorpart2)$(echo $xorpart3)$(echo $xorpart4)"
	)

    jq -n "${args[@]}" '{"'$name2'":$ARGS.named}'

done > $tmpfile

cat $tmpfile | jq -s '.' > $3
rm $tmpfile
