#!/bin/bash

# Process script inputs
name=$1
email=$2
message_title=$3
if [[ $4 == 'check-only' ]]; then
  do_commit=0
  echo
  echo "Action input 'check-only-or-commit' set to 'check-only': formatting and failing in case code is not properly formatted"
elif [[ $4 == 'commit' ]]; then
  do_commit=1
  echo
  echo "Action input 'check-only-or-commit' set to 'commit': formatting and, if necessary, committing and pushing code to the repository with:
- Author name: $name
- Author email: $email
- Commit message title: '$message_title'"
else
  echo
  echo "Action input 'check-only-or-commit' takes either of the following arguments: ['check-only', 'commit']!"
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
echo
echo "======================="
echo "Applying style to files"
echo "======================="
apply_style

# Determine modified files using Git
modified_files=$(sudo git diff --name-only | xargs)
exit_code=$?

# If last command was executed successfully (exit status 0): check modified files (do_commit=0) or commit and push modified files (if do_commit=1)
if [[ $exit_code == 0 ]]; then
  if [[ $modified_files ]]; then
    message_mod_files="Modified files:"
    read -ramod_files<<< "$modified_files"
    for file in "${mod_files[@]}"; do
      message_mod_files+="
- $file"
    done

    echo
    echo "$message_mod_files"

    if [[ $do_commit -eq 0 ]]; then
      echo
      echo "Files modified after formatting"
      echo "Please format code before pushing to the repository"
      echo "CHECK FAILED"
      exit 1

    elif [[ $do_commit -eq 1 ]]; then
      echo
      echo "============================"
      echo "Committing to Current Branch"
      echo "============================"

      sudo git commit -a -m "$message_title" -m "$message_mod_files"
      sudo git push
    fi

  else
    echo
    echo "No modified files after formatting"
    echo "CHECK PASSED"
    exit 0
  fi

# If last command failed (exit status != 0): print error message and exit
else
  echo "Running command 'modified_files=\$(sudo git diff --name-only | xargs)' was not successful and exited with code $exit_code!"
  echo "Exiting"
  exit $exit_code
fi
