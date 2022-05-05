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
  message_mod_files="Edited files:"
  read -rasplitLineIFS<<< "$modified_files"
  for file in "${splitLineIFS[@]}"; do
    # message_mod_files+="\n- "
    message_mod_files+="
- $file"
  done
  echo $message_mod_files

  echo
  echo "============================"
  echo "Committing to Current Branch"
  echo "============================"
  echo
  # message+=$message_title
  # message+=$message_mod_files
  sudo git commit -a -m "$message_title" -m "$message_mod_files"
  sudo git push
else
  echo "No changes to commit"
fi
