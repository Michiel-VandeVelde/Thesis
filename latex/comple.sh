#!/bin/bash
#!/bin/bash

inkscape --export-type=pdf /img/*.svg

pdflatex --shell-escape -interaction=nonstopmode samplepaper.tex
bibtex samplepaper
pdflatex --shell-escape -interaction=nonstopmode samplepaper.tex
pdflatex --shell-escape -interaction=nonstopmode samplepaper.tex
