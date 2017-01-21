iec2utf
===========

This is simple convertor for files writen by LaTeX when `inputenc` package
with `utf8` option is used. All unicode characters with character code
greater than 127 are encoded as `\IeC{LICR code}`, this tool can translate
them to `utf8` codes.

Lua library and two sample scripts are provided. 


ieclib
------

Conversion library. 

### Functions

`process(string)`

conversion function, all `\IeC` codes are translated to `utf8`.

`load_enc(table with encodings)`

conversion is based on font encodings, you must specify font encodings
used in the document. For each of these encodings, file `<encname>enc.dfu`
must exist. In these files, conversion tables are provided. 

iec2utf.lua
-----------

    texlua iec2utf.lua "used fontenc" < filename > newfile

You must specify font encodings used in the document, default is `T1 T2A T2B T2C T3 T5 LGR`, which covers European languages with Latin and Cyrrilic alphabets, and Vietnamese.

### Example

For example, this sample:

    \documentclass{article}

    \usepackage[T1]{fontenc}
    \usepackage[utf8]{inputenc}
    \usepackage[]{makeidx}
    \makeindex
    \begin{document}
      Hello
      \index{Příliš}
      \index{žluťoučký}
      \index{kůň}
      \index{úpěl}
      \index{ďábelské}
      \index{ódy}
      \printindex
    \end{document}

produces this raw index file:

    \indexentry{P\IeC {\v r}\IeC {\'\i }li\IeC {\v s}}{1}
    \indexentry{\IeC {\v z}lu\IeC {\v t}ou\IeC {\v c}k\IeC {\'y}}{1}
    \indexentry{k\IeC {\r u}\IeC {\v n}}{1}
    \indexentry{\IeC {\'u}p\IeC {\v e}l}{1}
    \indexentry{\IeC {\v d}\IeC {\'a}belsk\IeC {\'e}}{1}
    \indexentry{\IeC {\'o}dy}{1}

When you try to process this index file with xindy (for correct utf8 
support with `xindy`, it is best to load language module with 
`-M lang/langname/utf8-lang`, in this case language is `czech`):

    texindy -M lang/czech/utf8-lang filename.idx

the result is incorrect:

      \item \IeC {\'o}dy, 1
      \item \IeC {\'u}p\IeC {\v e}l, 1
      \item \IeC {\v d}\IeC {\'a}belsk\IeC {\'e}, 1
      \item \IeC {\v z}lu\IeC {\v t}ou\IeC {\v c}k\IeC {\'y}, 1

      \indexspace

      \item k\IeC {\r u}\IeC {\v n}, 1

      \indexspace

      \item P\IeC {\v r}\IeC {\'\i }li\IeC {\v s}, 1

We must convert the `.idx` file to `utf8` encoding in order to be processed
correctly with `xindy`:

    texlua iec2utf.lua < filename.idx > new.idx
    mv new.idx filename.idx
    texindy -M lang/czech/utf8-lang

The result is now correct:

      \lettergroup{D}
      \item ďábelské, 1

      \indexspace

      \lettergroup{K}
      \item kůň, 1

      \indexspace

      \lettergroup{O}
      \item ódy, 1

      \indexspace

      \lettergroup{P}
      \item Příliš, 1

      \indexspace

      \lettergroup{U}
      \item úpěl, 1

      \indexspace

      \lettergroup{Ž}
      \item žluťoučký, 1

utftexindy.lua
--------------

To simplify process described above, script `utftexindy.lua` is provided. 
`ieclib` with `T1, T2A, T2B, T2C, T3, T5` and `LGR` font encoding is loaded,
all command line options are passed to `texindy`, with exception of the `-L` 
option for language, which is transformed to `-M lang/<langname>/utf8-lang`.
It is also possible to use the languages with multiple alphabet rule
variants, like `slovak-large`, `slovak-small`, `spanish-modern`,
`spanish-traditional`, ... that are correctly transformed into
`-M lang/<lang>/<variant>-utf8-lang`.

### Example:

	texlua utftexindy.lua -L czech filename.idx

This is equivalent to 

	texlua iec2utf.lua < filename.idx | texindy -i -M lang/czech/utf8-lang -o filename.ind

