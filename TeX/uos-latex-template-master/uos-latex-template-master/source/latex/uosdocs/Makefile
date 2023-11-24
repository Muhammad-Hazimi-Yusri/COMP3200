#*=============================================================================
# Makefile for uosdocs LaTeX Style
# Date: 11/05/2002
# Author: Steve Gunn
# Use for rebuilding class files when the original dtx source has been changed
# Change TEXMF to represent the installation directory of texlive (or MiKTeX)
# The style is the name of the style for these templates.
# Date: 30/01/2019
# Author: Edward Longman
# Rebuild and change name to uosdocs
# make
#	     all - creates all the necessary files to install the class
#      install - moves all of the created files into the specified TEXMF directory
#*======================BUILD AND INSTALL NAMES================================

TEXMF      = C:\Users\<username>\texmf
STYLE      = uosdocs

#*====================DEFINE EXPECTED OUTPUT FILES=============================

CLSFILES   = uosthesis.cls \
             uosminithesis.cls \
             uosprogress.cls \
             uosproject.cls \
             uosreport.cls \
             uosarticle.cls \
             uosgdp.cls \
             uosgdpsummary.cls \
             UoSLogo.pdf

TPLFILES   = AppendixA.tex \
             Article.tex \
             Conclusions.tex \
             Definitions.tex \
             GDP.tex \
             GDPSummary.tex \
             Introduction.tex \
             MiniThesis.tex \
             Progress.tex \
             Project.tex \
             Report.tex \
             Thesis.tex

EPSFILES   = figure.eps

DOCFILES   = uosdocs.pdf

BIBFILES   = UOS.bib

TESTFILES  = Article.pdf \
             GDP.pdf \
             GDPSummary.pdf \
             MiniThesis.pdf \
             Progress.pdf \
             Project.pdf \
             Report.pdf \
             Thesis.pdf

SRCFILES   = $(STYLE).dtx \
             $(STYLE).ins \
             UoSLogo.pdf \
	     			 Makefile

GENFILES   = $(CLSFILES) \
             $(TPLFILES) \
             $(EPSFILES) \
             $(BIBFILES)

CLSDIR     = "$(TEXMF)/tex/latex/$(STYLE)"
TPLDIR     = "$(TEXMF)/templates/latex/$(STYLE)"
DOCDIR     = "$(TEXMF)/doc/latex/$(STYLE)"
BIBDIR     = "$(TEXMF)/bibtex/bib/$(STYLE)"
SRCDIR     = "$(TEXMF)/source/latex/$(STYLE)"

TEMPLATEDEPS = figure.eps UOS.bib
ARTICLEDEPS = uosarticle.cls Article.tex $(TEMPATEDEPS)
BOOKDEPS = $(TEMPATEDEPS) Definitions.tex Introduction.tex Conclusions.tex AppendixA.tex
GDPDEPS = uosgdp.cls GDP.tex $(BOOKDEPS)
GDPSUMMARYDEPS = uosgdpsummary.cls GDPSummary.tex $(TEMPATEDEPS)
MINITHESISDEPS = uosminithesis.cls MiniThesis.tex $(BOOKDEPS)
PROGRESSDEPS = uosprogress.cls Progress.tex $(BOOKDEPS)
PROJECTDEPS = uosproject.cls Project.tex $(BOOKDEPS)
REPORTDEPS = uosreport.cls  Report.tex $(BOOKDEPS)
THESISDEPS = uosthesis.cls Thesis.tex UoSLogo.pdf $(BOOKDEPS)

#*====================== LATEX INSTALLATION CONFIG ==========================

LATEX      = pdflatex
PDFTEXIFY  = texify --pdf
MAKEINDEX  = makeindex
ZIP = 7z a -tzip
UNZIP = 7z e

#*==================== DIFFERENT MAKE CONFIGURATIONS ========================

all: $(GENFILES) $(DOCFILES)

dist: $(STYLE).zip
test: $(GENFILES) $(TESTFILES)
UNZIPFILES = $(patsubst %, unzipped/%, $(TESTFILES))
ziptest: $(UNZIPFILES)

#* .SECONDARY used to stop it building repeatedly
#* https://stackoverflow.com/questions/2973445/
#* gnu-makefile-rule-generating-a-few-targets-from-a-single-source-file
$(GENFILES): $(STYLE).intermediate;
.SECONDARY: $(STYLE).intermediate
$(STYLE).intermediate: $(STYLE).dtx $(STYLE).ins Makefile
	$(LATEX) $(STYLE).ins

$(DOCFILES): $(STYLE).dtx
	$(LATEX) $(STYLE).dtx
	$(MAKEINDEX) -s gind.ist -o $(STYLE).ind $(STYLE).idx
	$(MAKEINDEX) -s gglo.ist -o $(STYLE).gls $(STYLE).glo
	$(LATEX) $(STYLE).dtx

%.pdf: %.tex
	$(PDFTEXIFY) $*.tex
unzipped/%.pdf: %.zip
	$(UNZIP) -obuild/ $*.zip
	$(PDFTEXIFY) build/$*.tex -output-directory="build/" --quiet
	grep "2021/06/08 v1.5" build/$*.log
	cp build/$*.pdf unzipped/$*.pdf
	rm build/*
#*========================== ZIP REQUIREMENTS ===============================

Article.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(ARTICLEDEPS)
GDP.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(GDPDEPS)
GDPSummary.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(GDPSUMMARYDEPS)
MiniThesis.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(MINITHESISDEPS)
Progress.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(PROGRESSDEPS)
Project.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(PROJECTDEPS)
Report.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(REPORTDEPS)
Thesis.zip: $(GENFILES) $(DOCFILES)
	$(ZIP) $@ $(THESISDEPS)

#*============================= CLEAN TYPES =================================
clean:
	-$(RM) *.aux *.log *.ind *.idx *.glo *.gls *.ilg *.toc *.bak *.lol *.lot *.out *.lof *.bbl *.blg

veryclean: clean
	-$(RM) *.pdf

distclean: veryclean
	-$(RM) *.cls *.tex *.eps *.bib *.bst *.zip

#*======================= INSTALL INTO TEXMF DIRECTORY ======================

install: $(GENFILES) $(DOCFILES)
	install -d $(CLSDIR)
	install $(CLSFILES) $(CLSDIR)
	install -d $(TPLDIR)
	install $(TPLFILES) $(TPLDIR)
	install $(EPSFILES) $(TPLDIR)
	install -d $(DOCDIR)
	install $(DOCFILES) $(DOCDIR)
	install -d $(BIBDIR)
	install $(BIBFILES) $(BIBDIR)
	install -d $(SRCDIR)
	install $(SRCFILES) $(SRCDIR)
	$(MAKE) clean

#*===========================================================================
