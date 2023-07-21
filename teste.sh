cat arthur.erro
if [[ "$?" != "0" ]]; then
    echo "Deu bom... Arquivo não existe"
else
    echo "Arthur existe"
fi
