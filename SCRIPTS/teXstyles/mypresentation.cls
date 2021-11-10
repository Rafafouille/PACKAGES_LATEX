%%======================================================================
%% Copyright 2013-2017 by Nicolas Mesnier <nicolas.mesnier@gmail.com>
%%
%% This file may be distributed and/or modified
%% 1. under the LaTeX Project Public License and/or
%% 2. under the GNU Public License.
%% See the file doc/licenses/LICENSE for more details.
%%
%% Unlimited copying and redistribution of this file are permitted as
%% long as this file is not modified.  Modifications, and distribution
%% of modified versions, are permitted, but only if the resulting file
%% is renamed.
%-----------------------------------------------------------------------
\ProvidesClass{mypresentation}
              [2014/07/26 v0.2
 Modified Standard LaTeX document class]
%=======================================================================
\newif\if@poly\@polyfalse
\newif\if@TD\@polyfalse
\newif\if@cours\@coursfalse
\newif\if@prof\@proftrue
\newif\if@print\@printfalse

\DeclareOption{eleve}{%
	\let\if@prof\iffalse
}
\DeclareOption{print}{%
	\let\if@print\iftrue
}
\ProcessOptions\relax

%=======================================================================
% *** load class
%=======================================================================
\if@print
  \LoadClass[10pt,mathserif,utf8,frenchb,transparent,xcolor=table,gray,hyperref={pdfa}]{beamer}
  \usetheme{LJF}
  \setbeamercovered{transparent}

\else
  \LoadClass[10pt,mathserif,utf8,frenchb,xcolor=table,hyperref={pdfa}]{beamer}
  \usetheme{LJF}
\fi
%-----------------------------------------------------------------------
%========================== P A C K A G E S ============================
\RequirePackage{etex}
\RequirePackage[utf8]{inputenc}
\RequirePackage[french]{babel}
\RequirePackage[autolanguage]{numprint}
\RequirePackage{%
	setspace,color,calc,graphicx,multicol,% << style
	amsmath,amssymb,amsfonts,amstext,amsthm,stmaryrd,% << maths
	mathtools,% << for left side subs
%	thmtools,% << for customize theorem
	mathrsfs, % << some math fonts
%	enumitem,% << lists
	longtable,colortbl,multirow,array,% << tabular
	marvosym,% << symbols
	tikz,pgf,pgfcore,pgfplots,% << graphics
	schemabloc,% << shémas-blocs, include tikz & pgf
%	float,wrapfig, % << to wrap fig !
%	pdfpages,%
	framed,%mdframed,% << for frame
	verbatim,% << comments
%	lastpage,% << to get total nb of pages
%	csquotes,%
%	pdflscape,% << swith to landscape
%	subfigure,% << for \subfigure[]{}
	ifthen,%
	pifont,% for \ding{}
	epstopdf,
%    colortbl,%
}

% *** fonts
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}
\RequirePackage{lmodern}
\RequirePackage[babel]{microtype}

% *** pgf/tikz library
\usepgflibrary{arrows}
\usetikzlibrary{calc,automata,er,fadings,decorations,shadows,shapes,%
	topaths,positioning,matrix,patterns,intersections,%
	babel,% pour préserver les caractères actifs
}

% *** enumitem options
%\setlist{noitemsep}

\makeatletter
\newcommand*{\@header}{}%
\newcommand{\header}[1]{\gdef\@header{#1}}
\newcommand*{\@CI}{}%
\newcommand{\CI}[1]{\gdef\@CI{#1}}
%-----------------------------------------------------------------------
% *** 
%-----------------------------------------------------------------------
% *** multicols
\columnseprule0.4pt
%\columnseprulecolor{red}
%\multicolsep25pt
\columnsep1cm
% *** text spacing
%\RequirePackage{setspace}
%\setstretch{1.08}

% *** page style
%\pagestyle{plain}
%\pagestyle{headings}

%-----------------------------------------------------------------------
% *** environment
\theoremstyle{theorem}
\newtheorem{Btheorem}{Théorème}%[section]
\newtheorem{Bcorollary}{Corollaire}
\newtheorem{Blemma}[theorem]{Lemme}
\newtheorem{Bproposition}{Proposition}
\newtheorem{Bconjecture}{Conjecture}
\theoremstyle{example}
\newtheorem{Bexample}{Exemple}[section]
\renewenvironment{example}[1]{\begin{Bexample}#1}{\end{Bexample}}
%
\newtheorem*{Bproblem}{Problème}

\theoremstyle{definition}
\newtheorem{Bdefinition}[theorem]{Définition}
\newtheorem*{Bremark}{Remarque}



\newtheorem*{Bnotation}{Notation}
% *** remark
\makeatletter
\def\th@remark{%
    \normalfont % body font
    \def\inserttheoremblockenv{alertblock}
  }
\makeatother
\theoremstyle{remark}
\newtheorem*{remark}{Remarque}

\theoremstyle{definition}
\newtheorem{property}[theorem]{Propriété}

\renewenvironment{definition}[1]{\begin{Bdefinition}#1}{\end{Bdefinition}}
\renewenvironment{theorem}[1]{\begin{Btheorem}#1}{\end{Btheorem}}
\newenvironment{proposition}[1]{\begin{Bproposition}#1}{\end{Bproposition}}

%-----------------------------------------------------------------------
% *** code python
%-----------------------------------------------------------------------
\usepackage{listings}
%\lstset{
%	upquote=true,
%	columns=flexible,
%	basicstyle=\ttfamily,
%	language=Python,
%	keywordstyle=\color{blue},
%	identifierstyle=\color{black},
%	commentstyle=\color{orange},
%	% *** style
%	frame=leftline,%
%	framerule=3pt,%
%	rulecolor=\color{black!20},%
%	framesep=1em,%
%	xleftmargin=2em,%
%	% code
%	showstringspaces=false,
%%	texcl=True,% to activate teX code
%	literate=%
%{á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
%{Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
%{à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
%{À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
%{ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
%{Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
%{â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
%{Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
%{œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
%{ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
%{ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
%{€}{{\EUR}}1 {£}{{\pounds}}1
%{°}{{\degres{}}}1
%}
\lstset{literate=%
{á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
{Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
{à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
{À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
{ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
{Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
{â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
{Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
{œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
{ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
{ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
{€}{{\EUR}}1 {£}{{\pounds}}1
{°}{{\degres{}}}1
}
\lstset{
	inputencoding=utf8,% pour les accents
	extendedchars=true,
	upquote=true,
	columns=flexible,
	basicstyle=\ttfamily,
	language=Python,
	keywordstyle=\color{blue},
	identifierstyle=\color{black},
	commentstyle=\color{orange},%
	% *** style
	frame=leftline,%
	framerule=3pt,%
	rulecolor=\color{black!20},%
	framesep=1em,%
	xleftmargin=2em,%
}
\input{arduinoLanguage.tex}







%-----------------------------------------------------------------------
% *** pkg perso
%\RequirePackage{myenvironments}
\RequirePackage{mycommands}
\RequirePackage{LJF-SII_pedagogie}
%-----------------------------------------------------------------------
% *** pkg pour frequentiel
\RequirePackage{atbegshi} 
\RequirePackage{mybodegraph}
% *** pkg pour elec
\RequirePackage[european]{circuitikz}
\RequirePackage{myelec}

%-----------------------------------------------------------------------
% *** new commands 
%-----------------------------------------------------------------------
\newcommand\Sitem[1]{%
	{\Large\textcolor{mydarkblue}{$\blacksquare$}~#1}%
}
\newcommand\Bitem[1]{%
	{\Large\textcolor{mydarkblue}{\LARGE$\bullet$}~#1}%
}

%-----------------------------------------------------------------------
% caption outside a figure environment
\newcommand\captionfig[1]{\refstepcounter{figure}%
	\textsc{Figure \thefigure} \textendash{} #1}
\newcommand\captiontab[1]{\refstepcounter{table}%
	\textsc{Table \thetable} \textendash{} #1}

%-----------------------------------------------------------------------
% *** info environment
%-----------------------------------------------------------------------
\newsavebox{\boiteinfo}
\newenvironment{info}{\medskip%
	\setbox\boiteinfo=\vbox\bgroup%
	\hsize\textwidth\addtolength{\hsize}{-6em}\parindent0pt%
	\vspace*{5pt}}%
	{\vspace*{5pt}\par\egroup%
	\noindent\parbox[b][\heightof{\usebox{\boiteinfo}}][c]{4em}{\centering\huge\Info}%
	\rule{1pt}{\heightof{\usebox{\boiteinfo}}}\hskip1em%
	\parbox[b][\heightof{\usebox{\boiteinfo}}][c]{\textwidth-6em}{\usebox{\boiteinfo}}
	\par\medskip
}

%-----------------------------------------------------------------------
\makeatother
%-----------------------------------------------------------------------
\author[SII \textendash{} PTSI]{V.~Lacharnay}
\institute{Lycée Gustave Eiffel, Dijon}
\date{2021\textendash 2022}