#!/bin/bash

# Process script inputs
name=$1
email=$2
message_title=$3

# Function to apply clang-format
apply_style(){
  find . -name '*.h' -or -name '*.hpp' -or -name '*.cpp' | xargs clang-format-10 -i -style=file --verbose $1
}

# Install packages
sudo apt-get update
sudo apt-get install -y clang-format-10 git

# Git configuration
sudo git config --global user.name "$name"
sudo git config --global user.email "$email"
sudo git config --global push.default current

# Apply clang-format
echo "======================="
echo "Applying style to files"
echo "======================="
apply_style

# Determine and print modified files
modified_files=$(sudo git diff --name-only | xargs)

if [[ $? == 0 ]]; then
  mod_files_message="Edited files:"
  read -rasplitLineIFS<<< "$modified_files"
  for file in "${splitLineIFS[@]}"; do
    echo $file
    mod_files_message+="\n- "
    mod_files_message+=$file
  done
  echo $mod_files_message

  echo
  echo "============================"
  echo "Committing to Current Branch"
  echo "============================"
  echo
  message+=$message_title
  message+="\n\n"
  message+=$mod_files_message
  sudo git commit -a -m "$message"
  sudo git push
else
  echo "No changes to commit"
fi
