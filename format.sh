#!/bin/bash

name=$1
email=$2
message=$3

apply_style(){
  find . -name '*.h' -or -name '*.hpp' -or -name '*.cpp' | xargs clang-format-10 -i -style=file --verbose $1
}

sudo apt-get update
sudo apt-get install -y clang-format-10 git

echo "======================="
echo "Applying style to files"
echo "======================="
apply_style

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
