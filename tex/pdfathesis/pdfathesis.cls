%% Memorial University Thesis LaTex class definition.
%% Department of Mathematics and Statistics
%%
%%  Copyright (c) 2015, JC Loredo-Osti <jcloredoosti@mun.ca>
%%
%%  This file may be distributed and/or modified under the conditions
%%  of the LaTeX Project Public License, either version 1.2 of this
%%  license or (at your option) any later version.  The latest version
%%  of this license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%%  and version 1.2 or later is part of all distributions of LaTeX
%%  version 1999/12/01 or later.
%%
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pdfathesis}[2017/11/22 A thesis class to produce PDF/A-1b via Ghostscript]
%%
\newif\if@withhype \@withhypefalse
\DeclareOption{withhyperref}{
\@withhypetrue
}
%% Pass all other options to report.cls.
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[letterpaper,12pt,oneside]{report} 

% \author \title are defined in `report.cls'. 
% \degree, \documentyype, \datesubmitted \convocationyear,
% \university and \academicunit  are defined in `pdfathesis.sty' 
% here are the rest of the front matter defining macros.
% When used, they should be entred in the preamble.
% The defaults apply only to Memorial Univerisity. 
%
\def\UniversityAddress#1{\gdef\@uaddress{#1}}
\def\UniversityLogo#1{\gdef\@univlogo{#1}}
\def\GradSchool#1{\gdef\@sgs{#1}}
\def\@sgs{School of Graduate Studies}
\def\@uaddress{St. John's, \ Newfoundland and Labrador, \ Canada}
\def\@univlogo{MUNLogoRGB}
\global\let\@title\@empty
\global\let\@author\@empty
\if@withhype
\RequirePackage[withhyperref]{pdfathesis}
\else
\RequirePackage{pdfathesis}
\fi
\RequirePackage{setspace}
\RequirePackage{graphicx}
%%
\setlength{\hoffset}{0in}
\setlength{\voffset}{0in}
\setlength{\oddsidemargin}{10mm}
\setlength{\topmargin}{-20pt}
\setlength{\headheight}{12pt}
\setlength{\headsep}{20pt}
\setlength{\textheight}{219mm}
\setlength{\textwidth}{153mm}
\setlength{\marginparsep}{0in}
\setlength{\marginparwidth}{0in}
\setlength{\footskip}{10mm}

%\geometry{left=3.5cm,right=2cm,top=3cm,bottom=3cm}
%%
%%
% Define the page heading to be page number only.
\newcommand{\munpagestyle}{%
  \pagestyle{myheadings}\markboth{}{}\markright{}}
%%
\onehalfspacing
%%
%% Disallow page breaks at hyphens (this will give some underfull vbox's,
%% so an alternative is to use \brokenpenalty=100 and manually search
%% for and fix such page breaks)
\brokenpenalty=10000
%%
%%
\def\no@breaks#1{{\def\\{ \ignorespaces}#1}}% disallow explicit line breaks
%%
\def\frontpage{%
  \addcontentsline{toc}{chapter}{Title page}
  \if@withhype\relax\else\zerobookmark{Title page}{1}{0}\fi%
  \mbox{}\\[-15mm]
  \mbox{}\hfill\includegraphics[height=25mm]{\@univlogo}\\[15mm]
  \thispagestyle{empty}%
\begingroup
  \begin{onehalfspacing}
    \begin{center}
      {\hyphenpenalty=10000\bfseries\Large \ifx\@title\@empty\z@title\else\@title\fi}
    \end{center}
    \vskip10mm
    \begin{center}
      \normalsize
      by\vskip10mm
      \copyright\ {\large \bfseries \ifx\@author\@empty\z@author\else\@author\fi}
     \end{center}
    \vfill
    \begin{center}
      \begin{minipage}{95mm}
        A \MakeLowercase{\@documenttype} submitted to the \@sgs{} in partial
        fulfillment of the requirements for the degree of
        \@degree.
      \end{minipage} \mbox{}\\[20mm]
      {\large \@academicunit}\mbox{}\\[8pt]
      {\large \@university}\mbox{}\\[13mm]
      \@datesubmitted
    \end{center}
  \end{onehalfspacing}
  \mbox{}\vskip8mm%
  {\centering \@uaddress\mbox{}\\}%
\endgroup
  \cleardoublepage%
  \typeout{`\jobname'.tex front page processed.}%
}
%%
\def\chapappxlabel#1{%
  \if!\ifnum9<1#1!\fi
    Chapter #1\else Appendix #1\fi
}
%
\let\@stdchapter\chapter
\if@withhype
\renewcommand*\chapter{%
  \@ifstar{\@starchapter}{\@dblarg\@nostarchapter}}
\newcommand*\@starchapter[1]{\@stdchapter*{#1}
  \ifx\@praefationes\@empty\relax
  \else  
  \thispagestyle{empty}
  \fi
  \addcontentsline{toc}{chapter}{#1}
}
\def\@nostarchapter[#1]#2{\@stdchapter[{#1}]{#2}
  \thispagestyle{empty}
}
\else
\newwrite\@zeromarks
\immediate\openout\@zeromarks=\jobname.bmks
\newcount\@bmkabspage 
\def\zerobookmark#1#2#3{
\begingroup
\inputencoding{8bit}
\@bmkabspage=#2 \advance\@bmkabspage #3
\z@bookmatrue
\immediate\write\@zeromarks{[/Title (#1) /Page \the\@bmkabspage /OUT pdfmark}
\z@bookmafalse
\endgroup
}
\@zeromarkstrue
\renewcommand*\chapter{%
  \@ifstar{\@starchapter}{\@dblarg\@nostarchapter}}
\newcommand*\@starchapter[1]{\@stdchapter*{#1}
  \ifx\@praefationes\@empty
  \zerobookmark{#1}{0}{\the\value{page}}
  \else  
  \zerobookmark{#1}{\@praefationes}{\the\value{page}}
  \thispagestyle{empty}
  \fi
  \addcontentsline{toc}{chapter}{#1}
}
\def\@nostarchapter[#1]#2{\@stdchapter[{#1}]{#2}
  \zerobookmark{\chapappxlabel\thechapter\ #2}{\@praefationes}{\the\value{page}}
  \thispagestyle{empty}
}
\fi
%%
% Redefine \thebibliography to go to a new page and have an entry in the
% table of contents
\let\@ldthebibliography\thebibliography
\renewcommand{\thebibliography}[1]{%
  \cleardoublepage%
  \singlespace
  \normalsize
  \@ldthebibliography{#1}
%  \if@withhype\addcontentsline{toc}{chapter}{Bibliography}\fi
}
\let\@ldbibliography\bibliography
\renewcommand{\bibliography}[1]{\@ldbibliography{#1}}
%%
\renewcommand{\contentsname}{Table of contents}
\let\@ldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{
  \cleardoublepage
  \@ldtableofcontents
}
%%
\renewcommand{\listtablename}{List of tables}
\let\@ldlistoftables\listoftables
\renewcommand{\listoftables}{
  \cleardoublepage
  \@ldlistoftables
}
%%
\renewcommand{\listfigurename}{List of figures}
\let\@ldlistoffigures\listoffigures
\renewcommand{\listoffigures}{
  \cleardoublepage
  \@ldlistoffigures
}
%%
\AtEndDocument{
\if@withhype\relax\else\closeout\@zeromarks\fi
}

%% Front matter 
\newenvironment{prefatory}{%
  \pagenumbering{roman}%
  \pagestyle{plain}\begin{onehalfspacing}\begingroup%
  }%
  {\endoffrontmatter
  \cleardoublepage\pagenumbering{arabic}%
    \typeout{'\jobname.tex'  \@praefationes\space prefatory pages processed.}%
    \endgroup\end{onehalfspacing}%
  }
%%
%%
%%
\def\dedication{
  \newpage\normalsize\mbox{}\vspace*{1in}
}
\renewcommand{\abstract}{\chapter*{Abstract}}
\def\laysummary{\chapter*{Lay summary}}
\def\acknowledgements{\chapter*{Acknowledgements}}
\def\acknowledgement{\chapter*{Acknowledgement}}
\def\contribution{\chapter*{Statement of contribution}}
\def\contributions{\chapter*{Statement of contributions}}
\def\listofsymbols{\chapter*{List of symbols}}
\def\listofabbreviations{\chapter*{List of abbreviations}}
%%
%%
\newenvironment{symbols}{%
    \listofsymbols%
    \begin{singlespacing}\begin{tabular}{rl}%
    }{\end{tabular}\end{singlespacing}}
%%
\newenvironment{abbreviations}{%
    \listofabbreviations%
    \begin{singlespacing}\begin{tabular}{rl}%
    }{\end{tabular}\end{singlespacing}}
%%
% Start out normal
\munpagestyle
\endinput
%%
%%
%% End od file pdfathesis.cls
%%
