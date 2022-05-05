#!/bin/bash

# Process script inputs
name=$2
email=$3
message_title=$4
if [[ $1 == 'check-only' ]]; then
  do_commit=0
  echo "Formatting and failing in case code is not properly formatted"
elif [[ $1 == 'commit' ]]; then
  do_commit=1
  echo "Formatting and, if necessary, committing and pushing code to the repository with:
- Author name: $name
- Author email: $email
- Commit message title: $message_title"
else
  echo "GitHub Action input 'check-only-or-commit' takes either of the following arguments: ['check-only', 'commit']!"
  echo "Exiting"
  exit 1
fi

# Function to apply clang-format
apply_style(){
  find . -name '*.h' -or -name '*.hpp' -or -name '*.cpp' | xargs clang-format -i -style=file --verbose $1
}

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
exit_code=$?

# If last command was executed successfully (exit status 0): print modified files, commit and push
if [[ $exit_code == 0 ]]; then
  message_mod_files="Modified files:"
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

  sudo git commit -a -m "$message_title" -m "$message_mod_files"
  sudo git push
# If last command failed (exit status != 0): print error message and exit
else
  echo "Running command 'modified_files=\$(sudo git diff --name-only | xargs)' was not successful and exited with code $exit_code!"
  echo "Exiting"
  exit 1
fi
