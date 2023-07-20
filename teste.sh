lista_branches=$(cat lista)
echo $lista_branches
lista_limpa=$(echo "$lista_branches" | tr ' ' '\n' | sort -u)
