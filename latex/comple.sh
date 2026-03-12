#!/bin/bash
#!/bin/bash
pdflatex -interaction=nonstopmode samplepaper.tex
bibtex samplepaper
pdflatex -interaction=nonstopmode samplepaper.tex
pdflatex -interaction=nonstopmode samplepaper.tex
