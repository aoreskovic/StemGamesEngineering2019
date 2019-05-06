TEX = $(wildcard *.tex)
PDF = $(patsubst %.tex, %.pdf, $(TEX))
AUX = $(patsubst %.tex, %.aux, $(TEX))

FLAGS ?= "\input{$<}"

%.pdf : %.tex
	pdflatex $(FLAGS)
	#bibtex $(basename $< .aux)
	pdflatex $(FLAGS)
	pdflatex $(FLAGS)

all : $(PDF)

blind : $(TEX)
	make FLAGS=\"\\def\\blind{}\\input{$$\<}\"
	mv $(PDF) $(basename $(PDF))_blind.pdf 

clean :
	rm -f *.bbl *.blg *.aux *.pdf *.log *.lot *.lof *.toc *.glo *.gls *.glg *.ist *.out

