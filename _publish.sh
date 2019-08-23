#!/bin/sh

echo "Deleta o ramo 'gh-pages' no GitHub."
git push --delete origin gh-pages

echo "Deleta o ramo 'gh-pages' local."
git branch --delete --force gh-pages

echo "Cria o ramo 'gh-pages'."
git checkout -b gh-pages

echo "Deleta conteúdo versionado e não versionado da raíz."
git ls-files | xargs rm
rm -rf config/
rm -f *

echo "Copia conteúdo em '_book/' para raíz."
cp -r ./_book/* ./

echo "Adiciona e registra todo o conteúdo na raíz."
git add --all *
git rm --cached -r _book/
git commit -m "Update the 'epidemioR'!"

echo "Sobe conteúdo para o ramo 'gh-pages' no GitHub."
git push -q origin gh-pages

echo "Retorna para o ramo 'master'."
git checkout --force master

echo "Abre o site para verificar o conteúdo publicado."
firefox https://lemid.github.io/epidemioR/
