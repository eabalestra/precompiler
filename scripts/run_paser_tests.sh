for input_file in inputs/*.txt; 
do
    echo "Running test with input file: $input_file"
    ./a.out "$input_file"
done