%%======================================================================
\ProvidesClass{teXstyles}[2016/08/24 v0.2 Bundle of LaTeX document class]
%%
%% Copyright 2013-2016 by Nicolas Mesnier <nicolas.mesnier@gmail.com>
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
%%======================================================================
%=======================================================================
% *** options
%=======================================================================
% *** document type
\newif\if@cours\@coursfalse
\newif\if@TD\@TDfalse
\newif\if@polyTD\@polyTDfalse
\newif\if@TP\@TPfalse
\newif\if@interro\@interrofalse
\newif\if@colle\@collefalse
\newif\if@DS\@DSfalse
\newif\if@doc\@docfalse
\newif\if@poly\@polyfalse
\newif\if@coverpage\@coverpagefalse
\newif\ifCORR\CORRfalse
% à mettre en "\corrtrue" pour l'utiliser
% \ifcoor
% truc à faire si corrigé
% \fi
%
\DeclareOption{cours}{%
	\let\if@cours\iftrue%
	\let\if@coverpage\iftrue%
}
\DeclareOption{TD}{%
	\let\if@TD\iftrue%
}
\DeclareOption{polyTD}{%
	\let\if@polyTD\iftrue
	\let\if@coverpage\iftrue%
}
\DeclareOption{TP}{%
	\let\if@TP\iftrue%
	\let\if@uneppf\iftrue%
}
\DeclareOption{interro}{%
	\let\if@interro\iftrue%
	\let\if@uneppf\iftrue%
}
\DeclareOption{colle}{%
	\let\if@colle\iftrue%
	\let\if@uneppf\iftrue%
}
\DeclareOption{doc}{%
	\let\if@doc\iftrue%
	\let\if@coverpage\iftrue%
}
\DeclareOption{DS}{%
	\let\if@DS\iftrue%
}
\DeclareOption{poly}{%
	\let\if@poly\iftrue%
}
% *** document version
\newif\if@prof\@proftrue
%
\DeclareOption{eleve}{\let\if@prof\iffalse}
\DeclareOption{prof}{\let\if@prof\iftrue}
% *** document destination
\newif\if@print\@printfalse
%
\DeclareOption{print}{\let\if@print\iftrue}
\DeclareOption{web}{\let\if@print\iffalse}
%
% *** layout
\newif\if@uneppf\@uneppffalse
\DeclareOption{uneppf}{\let\if@uneppf\iftrue}

\ProcessOptions\relax
%=======================================================================
% *** load class
%=======================================================================
\if@uneppf
  \LoadClass[a4paper,10pt,final,french]{article}
\else
  \LoadClass[a4paper,12pt,final,french]{article}
\fi


%=======================================================================
% *** packages
%=======================================================================
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
	enumitem,% << lists
	longtable,colortbl,multirow,array,% << tabular
	marvosym,% << symbols
	tikz,pgf,pgfcore,pgfplots,% << graphics
	schemabloc,% << shémas-blocs, include tikz & pgf
	float,wrapfig, % << to wrap fig !
	pdfpages,%
	framed,%mdframed,% << for frame
	verbatim,% << comments
	lastpage,% << to get total nb of pages
	csquotes,%
%	pdflscape,% << swith to landscape (lscape for print)
%	subfigure,% << for \subfigure[]{}
	ifthen,%
	pifont,% for \ding{}
}
\usetikzlibrary{circuits.ee.IEC}
\usetikzlibrary{positioning}
%\usepackage{animate}
%\usepackage{graphicx}
\usepackage{stringstrings}
%\usepackage{ascii}
\usepackage{afterpage} % to change pagestyle
\usepackage{verbatim} % Table de programmation
\usepackage[os=mac, mackeys=symbols]{menukeys} % Syymbole touche mac
% *** fonts
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}
\RequirePackage{lmodern}
% *** microtype
\RequirePackage[babel,final]{microtype}% final for less badbox
%\RequirePackage[babel=true,kerning=french]{microtype}
\DeclareMicrotypeAlias{lmr}{cmr}

% *** pgf/tikz library
\usepgflibrary{arrows}
\usetikzlibrary{calc,automata,er,fadings,decorations,shadows,shapes,%
	topaths,positioning,matrix,patterns,intersections,%
	babel,% pour préserver les caractères actifs
}


%=======================================================================
% *** layout
%=======================================================================

% *** enumitem options
\setlist{noitemsep}


%-----------------------------------------------------------------------
% *** colors
%-----------------------------------------------------------------------
\definecolor{myblack}{HTML}{000000}
\definecolor{myblue}{HTML}{006699}
\definecolor{mydarkblue}{HTML}{216EAD}
\definecolor{myDarkblue}{HTML}{283859}
\definecolor{mylightblue}{HTML}{0099d5}
\definecolor{mygreen}{HTML}{008542}
\definecolor{myorange}{HTML}{E37222}
\definecolor{myred}{HTML}{CC0033}
\definecolor{mygray}{HTML}{686868}
\definecolor{mylightgray}{HTML}{eeeeee}


%-----------------------------------------------------------------------
% *** figures
%-----------------------------------------------------------------------
\def\fnum@figure{{\scshape\figurename\nobreakspace\thefigure}}
\renewenvironment{figure}[1][htbp]%
               {\@float{figure}[#1]}
               {\end@float}
% caption
\long\def\@makecaption#1#2{
   \vskip 10pt
   \setbox\@tempboxa\hbox{{\scshape #1} \textendash{} #2}
   \ifdim \wd\@tempboxa >\hsize % if longer than one line
       {\scshape #1} \textendash{} #2\par
     \else % else centered
       \hbox to\hsize{\hfil\box\@tempboxa\hfil}
   \fi}

%-----------------------------------------------------------------------
% caption outside a figure environment
\newcommand\captionfig[1]{\par\refstepcounter{figure}%
	\textsc{Figure \thefigure} \textendash{} #1}
\newcommand\captiontab[1]{\par\refstepcounter{table}%
	\textsc{Table \thetable} \textendash{} #1}

%-----------------------------------------------------------------------
% *** labels of description
\def\descriptionlabel#1{\hspace\labelsep {\bfseries#1}\hfil}
% adjusted environment "description"
% if an optional parameter (at the first two levels of lists)
% is present, its width is considered to be the widest mark
% throughout the current list.
\def\description{\@ifnextchar[{\@describe}{\list{}{\labelwidth\z@
          \itemindent-\leftmargin \let\makelabel\descriptionlabel}}}
\let\enddescription\endlist

%-----------------------------------------------------------------------
% *** layout
%-----------------------------------------------------------------------
% *** sections style
\setcounter{secnumdepth}{3}
% *** toc deph
\setcounter{tocdepth}{2}
% *** page style
\pagestyle{plain}
% *** text spacing
%\RequirePackage{setspace}
%\setstretch{1.08}

\makeatletter
\newcommand*{\@header}{}%
\newcommand{\header}[1]{\gdef\@header{#1}}
\newcommand*{\@CI}{}%
\newcommand{\CI}[1]{\gdef\@CI{#1}}
\newcommand*{\@serieTP}{}%
\newcommand{\serieTP}[1]{\gdef\@serieTP{#1}}
\newcommand*{\@subtitle}{}%
\newcommand*{\subtitle}[1]{\gdef\@subtitle{#1}}
\newcommand\titre{}

%\newcommand{\urlPTSI}{http://ptsi.jfversailles.free.fr/IMG/pdf}
\newcommand{\urlPTSI}{http://ptsi.jfversailles.free.fr/sii/ptsi1}
\newcommand*{\@doc}{}%
\newcommand{\doc}[1]{\gdef\@doc{#1}}

%-----------------------------------------------------------------------
% *** page size
%-----------------------------------------------------------------------
%% >> ISO canons
%%	textwidth=120mm,textheight=170.3mm,%<< A5
%%	textwidth=125mm,textheight=177mm,
%%	textwidth=130mm,textheight=183mm,
%%	textwidth=135mm,textheight=191mm,
%%	textwidth=140mm,textheight=198mm,
%%	textwidth=150mm,textheight=212mm,
%%	textwidth=160mm,textheight=226.3mm,%<< A4
%%	textwidth=170mm,textheight=240mm,
%%	textwidth=180mm,textheight=254mm,
\if@print
\RequirePackage[pdftex,%
	textwidth=160mm,textheight=226.3mm,%
	footskip=2em,twoside,%includefoot,%
	marginratio=2:3,%
	hmarginratio=3:2,%
	paperwidth=186.95mm,paperheight=264.4mm,% 12pt a4 -> 9.5pt a5
	truedimen,%
	]{geometry}
\else
\RequirePackage[pdftex,%
	textwidth=160mm,textheight=226.3mm,%
	centering,
%	footskip=3.5\baselineskip,
    top=30mm,
%	includefoot,
	a4paper,
	]{geometry}%

\fi

% *** header
\usepackage{fancyhdr}
\pagestyle{fancy} 
\fancyhf{}
\fancyhead{}
\fancyfoot[c]{\thepage}
\if@cours
\if@print
	\fancyfoot[lo,re]{V. Lacharnay PTSI -- Eiffel Dijon}
\else
	\fancyfoot[r]{V. Lacharnay PTSI -- Eiffel Dijon}
\fi
\fi

\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\pagestyle{fancy}

%=======================================================================
% *** title
%=======================================================================
%-----------------------------------------------------------------------
% *** redefine title
\newcommand{\chapter}[1]{\gdef\@title{#1}}
\def\maketitle{%
	\if@coverpage\thispagestyle{empty}\else\thispagestyle{plain}\fi
	\begingroup
	\null%
	\ifx\@header\@empty
		\ifx\@CI\@empty\else%
			\header{\SIIPTSI{} / \@CI}%
		\fi\else%
	\fi
	\if@TD\vspace*{-1.5em}\fi
	\if@TP\header{\SIIPTSI{} /  TP -- Série \no{}\@serieTP\\[1ex] \@CI}\fi
	\begin{center}
	\if@TP
	  \parbox{\linewidth}{\centering\ifx\@header\@empty\phantom{X}\else\small\@header\fi}
	\else
	  \parbox{10cm}{\centering\ifx\@header\@empty\phantom{X}\else\small\@header\fi}
	\fi
	\vskip2.5em
	\if@TD
	  \parbox{14cm}{\centering\setstretch{1.05}%  
	    {\LARGE\bfseries\@title\par}%
	    \ifx\@subtitle\@empty
            \else\vskip .5em{\Large\itshape\@subtitle}\fi
	  }
	\else
	  \parbox{12cm}{\centering\setstretch{1.05}%  
	    {\LARGE\bfseries\@title\par}%
	    \ifx\@subtitle\@empty
            \else\vskip1.5em{\Large\itshape\@subtitle}\fi
	  }
	\fi
        \end{center}%
	\if@TD\else\vskip2.5em\fi
	\@thanks
	\endgroup
	\null%
	\setcounter{footnote}{0}%
	\global\let\thanks\relax
	\global\let\maketitle\relax
	\global\let\@thanks\@empty
}
\let\titre\maketitle

%=============================================================\begin{TD}

\if@TD
% *** sections style
\RequirePackage[small,bf]{titlesec}
\fi


%=========================================================\begin{polyTD}
% *** polyTD
\if@polyTD

%\renewcommand\section{\@startsection {section}{1}{\z@}%
%                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
%                                   {5.3ex \@plus.2ex}%
%                                   {\normalfont\Large\bfseries}}
\newcommand\exercice[1]{%
	\refstepcounter{section}
	\setcounter{subsection}{0}
	\setcounter{question}{0}
	\setcounter{figure}{0}
	\setcounter{table}{0}
	\newpage%
	\begin{center}
	  {\large\scshape \textemdash{}~Exercice\space\thesection~\textemdash{}}
	  \par\nobreak
	  \vskip 5\p@
	  \interlinepenalty\@M
	  \Large\bfseries #1
	\end{center}
	\vskip 10\p@
	\addcontentsline{toc}{section}{%
	\protect\numberline{Exercice\space\hb@xt@1em{\hss\thesection\hss}\space\textendash{}~}#1%
	}%
}

\setcounter{tocdepth}{1}
\renewcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip .5ex \@plus\p@
    \setlength\@tempdima{6.5em}%
    \begingroup\normalsize
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode %\bfseries
      \advance\leftskip\@tempdima 
      \advance\leftskip 1.2em
      \hskip -\leftskip
      #1\nobreak\dotfill \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi
}

\renewcommand\thefigure
     {\ifnum \c@section>\z@ \thesection.\fi \@arabic\c@figure}


\newcommand*{\@auteur}{}%
\newcommand{\auteur}[1]{\gdef\@auteur{#1}}
%\ifx\@auteur\@empty\else
\ifCORR

\else
\fancyfoot[r]{\@auteur}
%\fancyfoot[l]{\includegraphics[height=1.2em]{By-nc-sa_plain.pdf}}
\fi

\fi
%==================================================================colle
% *** colle
\if@interro
\newcommand*{\@inum}{}%
\newcommand{\inum}[1]{\gdef\@inum{#1}}
\geometry{textwidth=170mm,textheight=247mm,centering}
\def\maketitle{%
	\begingroup
	\let\footnoterule\relax
	\let \footnote \thanks
	\null%
	\vspace*{1em}
	\centerline{\Large\bf Interrogation de cours \no{}\@inum}%
	\centerline{\small ---~\@date~---}
	\vskip1em
	\par
	\endgroup
	\@thanks
	\null%
	\setcounter{footnote}{0}%
	\global\let\thanks\relax
	\global\let\maketitle\relax
\begin{tikzpicture}[remember picture,overlay]
\draw (current page.north west)+(15mm,-20mm) 
node[color=black,rectangle,right]{NOM: \rule[-2pt]{4cm}{.5pt}};
\draw (current page.north east)++(-15mm,-15mm) rectangle ++(-25mm,-15mm);
\draw (current page.north east)++(-19mm,-18mm) -- ++(-8mm,-10mm);
\draw (current page.north east)++(-15mm,-28mm) node[above left]{\LARGE 20};
\end{tikzpicture}
}

\fi
%==================================================================colle
% *** colle
\if@colle
\newgeometry{textwidth=160mm,textheight=247mm,%
	centering,includefoot}
\RequirePackage[small,bf]{titlesec}
%-----------------------------------------------------------------------
% *** redefine title
\newcommand\colle[1]{%
	\begingroup
	\let\footnoterule\relax
	\let \footnote \thanks
	\null%
	\ifx\@header\@empty
		\ifx\@CI\@empty\else%
			\header{\SIIPTSI{} / \@CI}%
		\fi%
	\fi
	\vspace*{-1.5em}
	\begin{center}
	\parbox{10cm}{\centering\ifx\@header\@empty\phantom{X}\else\small\@header\fi}
	\vskip1.5em
        \parbox{14cm}{\centering\setstretch{1.05}%  
	    {\LARGE\bfseries#1\par}%
	  }
	\end{center}%
	\vskip2.5em
	\endgroup
	\@thanks
	\null%
	\setcounter{footnote}{0}%
	\global\let\thanks\relax
	\global\let\maketitle\relax
}
% *** exercice
\newcounter{exercice}%[colle]
\newcommand\exercice[1]{%
	\refstepcounter{exercice}%
	\subsection*{Exercice~\theexercice~(#1)}%
}%

\fi
%====================================================================doc
% *** doc
\if@doc
%\geometry{textwidth=160mm,textheight=247mm,%
%	centering,includefoot}
\RequirePackage[small,bf]{titlesec}
%-----------------------------------------------------------------------
% *** redefine title
\def\maketitle{%
	\if@coverpage\thispagestyle{empty}\else\thispagestyle{plain}\fi
	\begingroup
	\null%
	\ifx\@header\@empty
		\ifx\@CI\@empty\else%
			\header{\SIIPTSI{} / \@CI}%
		\fi\else%
	\fi
	\begin{center}
        \parbox{10cm}{\centering\ifx\@header\@empty\phantom{X}\else\small\@header\fi}
	\vskip2.5em
	  \parbox{12cm}{\centering\setstretch{1.05}%  
	    {\LARGE\bfseries\@title\par}%
	    \ifx\@subtitle\@empty
            \else\vskip1.5em{\Large\itshape\@subtitle}\fi
	    \vskip 2em%
	    {\large\@author}%
	    \vskip 1em%
	    {\normalsize \@date}%
	  }
        \end{center}%
	\vskip2.5em
	\@thanks
	\endgroup
	\null%
	\setcounter{footnote}{0}%
	\global\let\thanks\relax
	\global\let\maketitle\relax
	\global\let\@thanks\@empty
}

\newcommand{\licence}{%
\begin{center}
\noindent\parbox[m]{3cm}{\href{http://creativecommons.org/licenses/by-nc-sa/3.0/deed.fr}%
{\includegraphics[width=\linewidth]{By-nc-sa_plain}}}
\end{center}
}
\newcommand{\licenceGPL}{%
\begin{center}
%\href{http://creativecommons.org/licenses/by-nc-sa/3.0/deed.fr}%
%{\includegraphics[height=3em]{By-nc-sa_plain}}\hspace*{1em}
\href{https://www.gnu.org/licenses/gpl-3.0.html}%
{\includegraphics[height=3em]{gpl}}
\end{center}
}

\fi
%-----------------------------------------------------------------------
% *** toc
%-----------------------------------------------------------------------
\RequirePackage{mdframed}

% *** tocBox

\if@polyTD
	\newmdenv[
		frametitle={\colorbox{white}{\space\large Exercices\space}},
		innertopmargin=0pt,
		frametitleaboveskip=-\ht\strutbox,
		frametitlealignment=\center,
	]{tocBox}
\else
	\newmdenv[
		frametitle={\colorbox{white}{\space\large Table des matières\space}},
		innertopmargin=0pt,
		frametitleaboveskip=-\ht\strutbox,
		frametitlealignment=\center,
	]{tocBox}
\fi



% *** redefinition of toc
\def\tableofcontents{%
	\begin{tocBox}%
	  \@starttoc{toc}
	  \medskip
	\end{tocBox}
}
\let\sommaire\tableofcontents

%-----------------------------------------------------------------------
% *** toc page (cours)
%-----------------------------------------------------------------------
\author{Virgile~Lacharnay }
\if@cours
	\if@print
		\newcommand{\licence}{%
		\noindent\parbox[m]{3cm}{\includegraphics[width=\linewidth]{By-nc-sa_plain}}
		\hfill\parbox[m]{90mm}{\small\centering
		\@author\\
		Lycée Gustave Eiffel, Dijon\\
		Compléments \& mises à jour sur le site des PTSI\\
		\url{http://ptsi.geiffel.free.fr/}
		}%
		\hfill\parbox[m]{3cm}{\raggedleft\includegraphics[height=2cm]{QRcode}}
		}

	\else
		\newcommand{\licence}{%
		\noindent\parbox[m]{3cm}{\href{http://creativecommons.org/licenses/by-nc-sa/3.0/deed.fr}%
		{\includegraphics[width=\linewidth]{By-nc-sa_plain}}}
		\hfill\parbox[m]{90mm}{\small\centering
		\@author\\
		Lycée Gustave Eiffel, Dijon\\
		Compléments \& mises à jour sur le site des PTSI\\
		\url{http://ptsi.geiffel.free.fr/}\\
		{\textemdash{} Version du \today{} \textemdash{}}}
		\hfill\parbox[m]{3cm}{%
		\retokenize[e]{\@doc}% voir paquet "stringstrings"
		\caselower[e]{\thestring}
		\retokenize[e]{\thestring}%
		\raggedleft\href{\urlPTSI/\thestring}{\includegraphics[height=2cm]{QRcode}}}
		}

	\fi
	\def\tocpage{\newpage\thispagestyle{empty}~\vfill\tableofcontents%
	\vfill~\licence\newpage}
\fi

%-----------------------------------------------------------------------
% *** hyperlinks
%-----------------------------------------------------------------------
\RequirePackage[colorlinks=true]{hyperref}
\if@print
  \RequirePackage{lscape}
  \hypersetup{linkcolor=black,urlcolor=black,citecolor=black}
\else
  \RequirePackage{pdflscape}
  \hypersetup{linkcolor=red,urlcolor=blue,citecolor=blue}
\fi

%-----------------------------------------------------------------------
% *** code python
%-----------------------------------------------------------------------
\usepackage{listings}
\lstset{
	upquote=true,
	columns=flexible,
	basicstyle=\ttfamily,
	language=Python,
	keywordstyle=\color{blue},
	identifierstyle=\color{black},
	commentstyle=\color{orange},
	% *** style
	frame=leftline,%
	framerule=3pt,%
	rulecolor=\color{black!20},%
	framesep=1em,%
	xleftmargin=2em,%
	% code
	showstringspaces=false,
%	texcl=True,% to activate teX code
	literate=%
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

%-----------------------------------------------------------------------
% *** specific packages
%-----------------------------------------------------------------------
\RequirePackage{mySII}
\RequirePackage{mycommands}
\RequirePackage{myenvironments}





% ---------------------------------
% *** AJOUTÉ PAR RAF
% ---------------------------------

\newcommand{\rappelCompetences}
{
\noindent
\href[pdfnewwindow=true]{http://enseignement.allais.eu/comp-SII}{
\tikz\node at (0,0)[rectangle,fill=black!10,rounded
corners]{\parbox{\linewidth}{
    \vspace{-0.3cm}
        \begin{center}
            \begin{tabular}{m{2cm}m{10cm}}
                \begin{center}
                    \includegraphics[height=0.7cm]{checklist.png}
                \end{center}
                &
                N'oubliez pas de compléter les compétences à la fin du TP !
            \end{tabular}
        \end{center}
    \vspace{-0.5cm}
}}}
}



\makeatother
%====================================================================eof
