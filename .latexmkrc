#
# latexmk config file for building entire thesis
#
# USAGE:  latexmk         - compiles whole project
#         latexmk -pvc    - run in continous file previewer mode
#         latexmk -c      - clean-up temporary files
#         latexmk -C      - clean-up also the output file
#

$recorder = 1;                   # Enable dependency recorder
$pdf_mode = 1;                   # Run pdflatex instead of latex

$pdf_previewer = "start evince"; # Set Evince as PDF viewer
$clean_ext = "bbl";              # Clean also bbl file

@default_files = ('diplomovka-prezentacia.tex');
