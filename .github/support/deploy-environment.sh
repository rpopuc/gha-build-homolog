#!/bin/bash
inputBranches=$1
git config --global user.email "robot@github.com"
git config --global user.name "Homolog Robot"
git fetch --all &> /dev/null
git checkout homolog &> /dev/null
lista_branches=''
if [[ -f homolog-branches ]]; then
  lista_branches=$(cat homolog-branches)
fi;
while read -r branch; do
  set +e
  git ls-remote --exit-code --heads origin $branch &> /dev/null
  if [[ "$?" != "0" ]]; then
    echo "Branch não existe: '$branch'"
    set -e
    exit 1
  fi
done <<< "$inputBranches"
lista_branches=`echo -e "$lista_branches\n$inputBranches" | tr ' ' '\n' | sort -u`
git checkout develop
git branch -D homolog
git checkout -b homolog develop
nova_lista=$lista_branches
echo "DEBUG: Entrando no loop"
while read -r branch; do
  set +e
  echo "DEBUG: Verifica se $branch existe"
  git ls-remote --exit-code --heads origin $branch &> /dev/null
  branch_exists=$?
  echo "DEBUG: Verificou se $branch $branch_exists"
  branch_merged=0
  if [[ "$branch_exists" == "0" ]]; then
    git checkout $branch
    git log --pretty=format:"%h" develop | grep `git log --pretty=format:"%h" -1 $branch` &> /dev/null
    branch_merged=$?
  fi
  if [[ "$branch_exists" == "0" ]] && [[ "$branch_merged" != "0" ]]; then
    set -e
    git rebase develop
    git checkout homolog
    git merge $branch --no-edit
  else
    set -e
    if [[ "$branch_exists" != "0" ]]; then
      echo "DEBUG: Branch $branch não existe!!"
    fi
    nova_lista="${nova_lista//$branch/}"
  fi
done <<< "$lista_branches"
echo "Preparando homolog"
git checkout homolog
echo $nova_lista | tr ' ' '\n' > homolog-branches
echo "Atualizando lista"
git add .
git commit -m "Atualizando homolog com $nova_lista"
git push --force origin homolog
