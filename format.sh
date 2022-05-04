#!/bin/bash

echo "format.sh"

# name=$INPUT_AUTHOR_NAME
# email=$INPUT_AUTHOR_EMAIL
# message=$INPUT_COMMIT_MESSAGE

# apply_style(){
#   find . -name '*.h' -or -name '*.hpp' -or -name '*.cpp' | xargs clang-format-10 -i -style=file --verbose $1
# }

# apt-get update
# apt-get install -y clang-format-10 git

# echo "======================="
# echo "Applying style to files"
# echo "======================="
# apply_style

# git config --global user.name "$name"
# git config --global user.email "$email"
# git config --global push.default current

# modified_files=$(git status | grep modified)

# if [[ $? == 0 ]] ;then
#   echo $modified_files
#   echo
#   echo "============================"
#   echo "Committing to Current Branch"
#   echo "============================"
#   git commit -a -m "$message"
#   git push
# else
#   echo "No changes to commit"
# fi
