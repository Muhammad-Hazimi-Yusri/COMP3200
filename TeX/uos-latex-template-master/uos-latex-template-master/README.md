# University Of Southampton LaTeX documents
LaTeX Documents for the University of Southampton. Mainly for Thesis and project reports

For slides with Beamer, please see https://git.soton.ac.uk/sw2f11/latex-slides-template

## FAQ
#### Q: How do I install and use the templates?
See the [Install](#install-instructions) section below.

#### Q: How do I include an "Accessed on", "Visited on", "Date last Accessed" or "Last visited" note for urls?
The bibliography is formatted by the `natbib` package that does not support the `urldate` field in `.bib` files.
As a work around, add a `note={Accessed on 2020-01-01}` to the relevant bib entry.

For more info, see [this Stack Exchange question](https://tex.stackexchange.com/questions/103133/problems-with-natbib-strange-url-format-and-urldate-not-shown).

#### Q: How do I fix a bib entry with special characters (`&%`)?
You may get an error like "Paragraph ended before \\BR@@bibitem was complete"
or there may be a cascade of errors because of an unclosed `\begin` statement.

The short term solution is to manually "escape" special characters in the `.bib` url fields,
i.e. `url = {http://www.somesite.com/8%20report}` => `url = {http://www.somesite.com/8\%20report}`.

Unfortunately, the longer term solution requires editing some source files.
Locate the `plainnat.bst` (or `biblatex.bst` file, if using `biblatex`)
and add the following in the file at the end of `FUNCTION {begin.bib}`
```
    "\providecommand{\BIBdecl}{\relax}"
    write$ newline$
    "\BIBdecl"
    write$ newline$
```
Then add ``\newcommand{\BIBdecl}{\catcode`\%=12 }`` before `\begin{document}` in your `.tex` document source.

[Stack Exchange Source](https://tex.stackexchange.com/questions/140143/hyperref-with-pagebackref-requires-manual-escaping-of-percentage-signs-in-urls)

#### Q: Can I use `biblatex` instead of `natbib`?
Yes, you can. Since this template has existed longer than `biblatex` it uses the older `natbib`.
there are good reasons to change to `biblatex` but `natbib` is still preferred by journals,
so using `natbib` will mean that source material from papers will not need to be modified.

# Install instructions
This is if you do not want to use a service like Overleaf or want to use a different template other than the uosthesis class provided.
If you want to compile documents on your own machine, first you must install a LaTeX distribution.
Either TeXLive or MikTeX will work. For TeXLive, you do not need a full installation (which is huge).

For detailed LaTeX Installation help please look at the [detailed template instructions](https://git.soton.ac.uk/el7g15/uos-latex-template-instructions/-/blob/master/README.pdf)
## For preparing a single document - just one Thesis, Dissertation or Final project report
This is if you will only need to use one template, and works on Overleaf too. Go to the [Releases page](https://git.soton.ac.uk/el7g15/uos-latex-template/-/releases) and download the relevant quickstart package. Unzip and start editing the `Thesis.tex`,`Progress.tex`,`GDP.tex` file as appropriate for the report you are doing. This should compile straight away from an editor like TeXstudio, or from the Overleaf workspace.

## For multiple use - for Progress reports, Thesis and more frequent use
Given you will use the template more than once, this is definitely the preferred option.
Download the `Source Code` from the [Releases page](https://git.soton.ac.uk/el7g15/uos-latex-template/-/releases) and extract it to the `{TEXMF}` folder (see below).
### Your `{TEXMF}` root subdirectory
For Tex Live: This whole folder can be moved into the `~/texmf` directory to begin using the class files.

For MikTeX: It is platform dependent, See `UserInstall` from (https://miktex.org/kb/texmf-roots).
You may need to register your directories: https://docs.miktex.org/manual/localadditions.html.
You will need to update the filename database (FNDB) (MiKTeX Console -> Tasks -> Refresh file name database), see https://docs.miktex.org/manual/configuring.html#fndbupdate. You can do this in the command line with the `initexmf -u` command.

### The folder post install
If using the zip download, there may be one or two containing directories before the actual
folders that need copying. Once the folder has been extracted your `{TEXMF}` directory should
look like so.

```
+-{TEXMF}
    +-bibtex
    |  +-bib
    |      +-uosdocs
    +-doc
    |  +-latex
    |      +-uosdocs
    +-templates
    |  +-latex
    |      +-uosdocs
    +-tex
    |  +-latex
    |      +-uosdocs
    +-source
       +-docstrip
           +-uosdocs
```

### Using the template
Now copy the contents of the `templates/latex/uosdocs` directory into your working directory.

In the working directory, open the relevant copied root `tex` file, i.e. `Thesis.tex` etc. and begin your masterpiece.

More info can be found in the [Instructions](https://git.soton.ac.uk/el7g15/uos-latex-template-instructions/-/blob/master/README.pdf).

## Updating
Repeat the installation step and it will overwrite the existing files.

# About this package
Created with docstrip `.ins` and `.dtx` files in the source directory. See the [Instructions](https://git.soton.ac.uk/el7g15/uos-latex-template-instructions/-/blob/master/README.pdf) for more info about usage and building.

The version hosted on https://git.soton.ac.uk/el7g15/uos-latex-template is kept up to date with the University of Southampton template. The version hosted on GitHub may diverge from that.
