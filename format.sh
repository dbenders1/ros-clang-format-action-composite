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

# Determine modified files using Git
modified_files=$(sudo git diff --name-only | xargs)
exit_code=1

# If last command was executed successfully (exit status 0): print modified files, commit and push
if [[ $exit_code == 0 ]]; then
  message_mod_files="Edited files:"
  read -ramod_files<<< "$modified_files"
  for file in "${mod_files[@]}"; do
    message_mod_files+="
- $file"
  done

  echo
  echo "$message_mod_files"
  echo
  echo "============================"
  echo "Committing to Current Branch"
  echo "============================"
  echo

  sudo git commit -a -m "$message_title" -m "$message_mod_files"
  sudo git push
else
  echo "Running command 'modified_files=\$(sudo git diff --name-only | xargs)' was not successful and exited with code $exit_code"
  echo "Exiting"
  exit 1
fi
