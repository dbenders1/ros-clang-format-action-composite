#!/bin/bash

name=$INPUT_AUTHOR_NAME
email=$INPUT_AUTHOR_EMAIL
message=$INPUT_COMMIT_MESSAGE

echo $name
echo $email
echo $message

apply_style(){
  find . -name '*.h' -or -name '*.hpp' -or -name '*.cpp' | xargs clang-format-10 -i -style=file --verbose $1
}

sudo apt-get update
sudo apt-get install -y clang-format-10 git

echo "======================="
echo "Applying style to files"
echo "======================="
sudo apply_style

sudo git config --global user.name "$name"
sudo git config --global user.email "$email"
sudo git config --global push.default current

modified_files=$(sudo git status | grep modified)

if [[ $? == 0 ]] ;then
  echo $modified_files
  echo
  echo "============================"
  echo "Committing to Current Branch"
  echo "============================"
  sudo git commit -a -m "$message"
  sudo git push
else
  echo "No changes to commit"
fi
