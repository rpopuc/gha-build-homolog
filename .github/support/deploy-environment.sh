#!/bin/bash
lista_branches=$1
git config --global user.email "robot@github.com"
git config --global user.name "Homolog Robot"
git checkout develop &> /dev/null
git branch -D homolog &> /dev/null
git checkout -b homolog develop &> /dev/null
nova_lista=$lista_branches
while read -r branch; do
  set +e
  git ls-remote --exit-code --heads origin $branch &> /dev/null
  branch_exists=$?
  branch_merged=0
  if [[ "$branch_exists" == "0" ]]; then
    git checkout $branch &> /dev/null
    git log --pretty=format:"%h" develop | grep `git log --pretty=format:"%h" -1 $branch` &> /dev/null
    branch_merged=$?
  fi
  if [[ "$branch_exists" == "0" ]] && [[ "$branch_merged" != "0" ]]; then
    set -e
    git rebase develop &> /dev/null
    git checkout homolog &> /dev/null
    git merge $branch --no-edit &> /dev/null
  else
    set -e
    nova_lista="${nova_lista//$branch/}"
  fi
done <<< "$lista_branches"
git checkout homolog &> /dev/null
echo $nova_lista | tr ' ' '\n' > homolog-branches
git add .
git commit -m "Atualizando homolog com $nova_lista" &> /dev/null
git push --force origin homolog &> /dev/null
echo "sucesso"