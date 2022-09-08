#!/bin/sh

# Pega chamadas como: library(pacote, lib.loc = ...), require(pacote).
loaded_packages () {
    file=$1
    grep -hE '\b(require|library)\([\.a-zA-Z0-9]+.*\)$' "$file" | \
        sed '/^[[:space:]]*#/d' | \
        sed -E 's/.*\(([\.a-zA-Z0-9]+).*\).*/\1/' | \
        sort -uf
}

# Pega chamadas como: pacote::funcao() ou pacote:::funcao().
namespace_packages () {
    file=$1
    grep -hE '\b[\.a-zA-Z0-9]+:::?[\.a-zA-Z0-9]+' "$file" | \
        sed '/^[[:space:]]*#/d' | \
        sed -E 's/.*\b([\.a-zA-Z0-9]+):::?[\.a-zA-Z0-9]+.*/\1/' | \
        sort -uf
}

# Lista os arquivos de extensão relevante.
source_files=`git ls-files '*.Rmd' '*.R'`
# echo "$source_files"

# Apaga arquivo se existir.
[ -e DEPENDS ] && rm DEPENDS

# Varre os arquivos extraindo os pacotes usados.
for file in $source_files; do
    # echo "$file"
    pkg=$(loaded_packages "$file")
    for p in $pkg; do
        echo "$file;" "$p" >> DEPENDS
    done
    pkg=$(namespace_packages "$file")
    for p in $pkg; do
        echo "$file;" "$p" >> DEPENDS
    done
done

# Cria arquivo com os pacotes mencionados no código.
[ -e aux ] && rm aux
cat DEPENDS | sort | uniq > aux
mv aux DEPENDS
echo "------------------------------------------------------------------"
echo "O arquivo DEPENDS contém os pacotes mencionados e arquivos."
echo
cat DEPENDS
echo "------------------------------------------------------------------"
echo

# Extrai p 2º campo e formata para vetor em R.
echo "------------------------------------------------------------------"
echo "Para instalar os pacotes com o R, use o vetor abaixo:"
echo
awk '{ print $2 }' DEPENDS | sort | uniq | \
    awk '{ printf "\"%s\", ", $1 }' | \
    awk '{print "c(" $0 ")"}' | \
    awk '{ gsub(", )", ")", $0); print $0 }'
echo "------------------------------------------------------------------"
echo
