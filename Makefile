all: open install

cv.pdf : cv.tex res.cls Makefile
	pdflatex cv.tex

cv.html : cv.tex pgfsys-tex4ht.def Makefile
	htlatex cv.tex
# Fix the image
	sed -i.bak 's|<object.*</object>|<img class="headshot" src="cv-image.jpg" alt="Picutre of Viola">|' cv.html
# Rip out the dots
	sed -i.bak 's|<tspan[^>]*>.</tspan>||g' cv.html
# Fix <tspan class="ptmr7t">(October 2015 - August</tspan><tspan class="ptmr7t">2019)</tspan>
	sed -i.bak 's|<tspan\([^>]*\)>(October 2015 - August</tspan>|<tspan class="right" \1>(October 2015 - August|' cv.html
	sed -i.bak 's|<tspan .*>2019)</tspan>| 2019)</tspan>|' cv.html
# Move the dates the right
	sed -i.bak 's|<tspan\([^>]*\)>(\(.*\))</tspan>|<tspan class="right" \1>(\2)</tspan>|' cv.html
# Fix the classes for fonts
	sed -i.bak 's|font-family=|class=|g' cv.html
# Remove useless tags
	sed -i.bak 's|font-size=""||g' cv.html
# Remove trailing whitespace
	sed -i.bak -E 's| +$$||' cv.html
# Condense classes
	sed -i.bak -E 's|class="([^"]+)" +class=\"|class="\1 |' cv.html
# Add required css
	echo "/* CUSTOM CSS */ " >> cv.css
	echo ".right { float: right;}" >> cv.css
	echo "table.section {width: 100%}" >> cv.css
	echo "table.section tbody tr td:first-child {font-weight: 900;}" >> cv.css
	echo ".linename { font-size: 36px; font-weight: 900; }" >> cv.css
	echo ".headshot { display:inline;position:absolute; }" >> cv.css
	echo "@media only screen and (max-width: 799px) {" >> cv.css
	echo "  .line-address { padding-top: 50px; height: 100px; }" >> cv.css
	echo "  .headshot { display:inline;position:absolute;height:150px;left:10px;top:75px; }" >> cv.css
	echo "}" >> cv.css
	echo "@media only screen and (max-width: 420px) {" >> cv.css
	echo "  .line-address { padding-top: 50px; height: 100px; }" >> cv.css
	echo "  .headshot { top:115px; }" >> cv.css
	echo "}" >> cv.css
	echo "@media only screen and (min-width: 800px) {" >> cv.css
	echo "  .headshot { height:200px;right:15px;top:120px; }" >> cv.css
	echo "}" >> cv.css
# Run some cleanup now
	rm cv.4tc cv.dvi cv.idv cv.lg cv.tmp cv.xref cv.4ct cv.html.bak cv-1.svg

open-pdf: cv.pdf
	open cv.pdf

open-html: cv.html
	open cv.html

open: open-pdf open-html

install: cv.pdf cv.html
	cp cv.pdf caretti-md.github.io/
	cp cv.html caretti-md.github.io/_includes/

clean:
	rm -f *.aux *.bbl *.blg *.idx *.lof *.toc *.lot *.4tc *.4tc *.dvi *.lg *.tmp *.xref cv.html cv.pdf cv.css cv-1.svg
