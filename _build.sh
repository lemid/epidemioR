#!/bin/bash

OPTIONS=$@
OPTNUM=$#

_usage() {
    cat <<EOF
./_build.sh $OPTIONS
$*
    Usage:    ./_build.sh <[options]>

    Options:

      -h --help     Show this message.
      -o --output   Output format for preview_chapter() or
                    render_book(). Values are: gitbook, pdf_book,
                    html_book and epub_book. If a file is passed,
                    preview_chapter() is used with the file instead of
                    render_book() with the index.Rmd file.
      -c --clean    Runs the clean_book(TRUE).

    Examples:

      ./_build.sh -h
      ./_build.sh -o gitbook
      ./_build.sh -o pdf_book
      ./_build.sh -o gitbook chapter-01.Rmd
      ./_build.sh -c

    Author: Walmes Zeviani <walmeszeviani@gmail.com>.

EOF
}

if [ $# = 0 ]
then
    _usage
    exit 1
fi

TEMP=`getopt -o ho:c --long help,output:,clean -n './_build.sh' -- "$@"`

if [ $? != 0 ]
then
    echo "Aborting." >&2
    exit 1
fi

eval set -- "$TEMP"

case "$1" in
    -h | --help )
        _usage
        exit 1
        ;;
    -o | --output )
        if [ -z "$4" ]
        then
            echo "Running:"
            echo "R> bookdown::render_book(input = 'index.Rmd', output_format = 'bookdown::$2')"
            Rscript -e "bookdown::render_book(input = 'index.Rmd', output_format = 'bookdown::$2')"
        else
            echo "Running:"
            echo "R> bookdown::preview_chapter(input = '$4', output_format = 'bookdown::$2')"
            Rscript -e "bookdown::preview_chapter(input = '$4', output_format = 'bookdown::$2')"
        fi
        ;;
    -c | --clean )
        echo "Running:"
        echo "R> bookdown::clean_book(clean = TRUE)"
        Rscript -e "bookdown::clean_book(clean = TRUE)"
        ;;
    * )
        _usage
        exit 1
        ;;
esac
