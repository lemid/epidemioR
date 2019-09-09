#!/bin/sh

echo "Deleta o ramo 'gh-pages' no GitHub."
git push --delete origin gh-pages

echo "Deleta o ramo 'gh-pages' local."
git branch --delete --force gh-pages

echo "Cria o ramo 'gh-pages'."
git checkout -b gh-pages
# git checkout gh-pages

echo "Deleta conteúdo versionado."
# git ls-files | xargs git rm --dry-run
git ls-files | xargs git rm

echo "Deleta conteúdo não versionado restante na raíz."
ls | grep -v '^_book$' | xargs rm -rfv

echo "Copia conteúdo em '_book/' para raíz."
# mv ./_book/* ./
# rm -r _book/
cp -r ./_book/* ./

echo "Adiciona e registra todo o conteúdo na raíz."
git add --all *
git rm --cached -r _book/
git commit -m "Update the 'epidemioR'!"

echo "Sobe conteúdo para o ramo 'gh-pages' no GitHub."
# git ls-files
# tree -L 1 -F
git push -q origin gh-pages

echo "Retorna para o ramo 'master'."
git checkout --force master

echo "Abre o site para verificar o conteúdo publicado."
firefox https://lemid.github.io/epidemioR/
