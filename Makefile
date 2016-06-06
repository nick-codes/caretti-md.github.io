all: open

cv.pdf : cv.tex res.cls
	pdflatex cv.tex

open : cv.pdf
	open cv.pdf

clean:
	rm -f *.aux *.bbl *.blg *.idx *.lof *.toc *.lot
