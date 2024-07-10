#!/bin/bash

# # run test.c if or <filename>
# if [ $# -eq 1 ]; then
#     new_name="$1"
#
#     find . -type f -name 's21_sttcat*' -exec bash -c 'cp "$0" "${0/s21_strcat/$new_name}"' {} \;
#     find . -type f -name '$new_name*' -exec sed -i 's/strcat/$new_name/g' {} +
#     find . -type f -name '$new_name*' -exec sed -i 's/STRING/STRCAT/g' {} +
#
# else echo "TI SHO EBLAN CHTOLI"
# fi
#
#!/bin/bash

# Check if new_val is provided as an argument
if [ -z "\$1" ]; then
    echo "Usage: \$0 <new_val>"
    exit 1
fi

new_val="$1"

# Copy files with replaced names
find . -type f -name 's21_strcat*' -exec bash -c 'cp "$0" "${0/s21_strcat/s21_'"$new_val"'}"' {} \;

# Change occurrences of old functions and substrings with new ones
find . -type f -name "s21_${new_val}*" -exec sed -i 's/strcat/'"$new_val"'/g' {} +
find . -type f -name "s21_${new_val}*" -exec sed -i 's/STRCAT/'"${new_val^^}"'/g' {} +
