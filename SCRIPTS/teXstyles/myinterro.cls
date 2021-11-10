%%======================================================================
%% Copyright 2013-2014 by Nicolas Mesnier <nicolas.mesnier@gmail.com>
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
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myinterro}
              [2014/07/26 v0.3
 myinterro LaTeX document class]
%=======================================================================
% *** 
\newif\if@poly\@polyfalse
\newif\if@polyTD\@polyTDfalse
\newif\if@TD\@TDtrue
\newif\if@DS\@DSfalse
\newif\if@cours\@coursfalse
\newif\if@prof\@proftrue
\newif\if@print\@printfalse

% *** options
\DeclareOption{eleve}{%
	\let\if@prof\iffalse
}
\DeclareOption{print}{%
	\let\if@print\iftrue
}

\ProcessOptions\relax
\LoadClass[a4paper,10pt,final,french]{article}
%-----------------------------------------------------------------------
% *** packages
\RequirePackage{mypackages}

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
\newcommand*{\@inum}{}%
\newcommand{\inum}[1]{\gdef\@inum{#1}}
\newcommand*{\@subtitle}{}%
\newcommand*{\subtitle}[1]{\gdef\@subtitle{#1}}
\newcommand\titre{}
%-----------------------------------------------------------------------
% *** page size
%-----------------------------------------------------------------------
\RequirePackage[pdftex,textwidth=170mm,textheight=247mm,centering]{geometry}
%-----------------------------------------------------------------------
% *** redefine title
\newcommand{\chapter}[1]{\gdef\@title{#1}}
\def\maketitle{%
%	\thispagestyle{empty}
	\begingroup
	\let\footnoterule\relax
	\let \footnote \thanks
	\null%
	\vspace*{1em}
	\centerline{\Large\bf Interrogation de cours de SII \no{}\@inum}%
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
\let\titre\maketitle


%-----------------------------------------------------------------------
% *** redefine title
\def\maketitleinfo{%
%	\thispagestyle{empty}
	\begingroup
	\let\footnoterule\relax
	\let \footnote \thanks
	\null%
	\vspace*{1em}
	\centerline{\Large\bf Interrogation de cours d'info \no{}\@inum}%
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
\let\titre\maketitleinfo

%-----------------------------------------------------------------------
% *** toc
%-----------------------------------------------------------------------
\RequirePackage{mdframed} % << NOT ROBUST IN TWOSIDE MODE
% *** tocBox
\newmdenv[
	frametitle={\colorbox{white}{\space\large Table des matières\space}},
	innertopmargin=0pt,
	frametitleaboveskip=-\ht\strutbox,
	frametitlealignment=\center,
]{tocBox}
% *** redefinition of toc
\def\tableofcontents{%
	\begin{tocBox}%
	  \@starttoc{toc}
	  \medskip
	\end{tocBox}
}
\let\sommaire\tableofcontents
%-----------------------------------------------------------------------
% *** hyperlinks
%-----------------------------------------------------------------------
\RequirePackage[colorlinks=true]{hyperref}
\if@print
  \hypersetup{linkcolor=black,urlcolor=black,citecolor=black}
\else
  \hypersetup{linkcolor=red,urlcolor=blue,citecolor=blue}
\fi

%-----------------------------------------------------------------------
% *** specific packages
%-----------------------------------------------------------------------
\RequirePackage{mySII}
\RequirePackage{mycommands}
\RequirePackage{myenvironments}
\makeatother
%====================================================================eof
