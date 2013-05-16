  %% conference.cls
  %% Copyright 2013 Seamus Bradley
  %
  % This work may be distributed and/or modified under the
  % conditions of the LaTeX Project Public License, either version 1.3
  % of this license or (at your option) any later version.
  % The latest version of this license is in
  %   http://www.latex-project.org/lppl.txt
  % and version 1.3 or later is part of all distributions of LaTeX
  % version 2005/12/01 or later.
  %
  % This work has the LPPL maintenance status `author-maintained'.
  % 
  % The Current Maintainer of this work is Seamus Bradley
  % tex@seamusbradley.net
  %
  % This work consists of the files conference.cls
  % and README.


\RequirePackage{expl3}
\ProvidesExplClass{conference}{2013/05/13}{0.2}{Conference Schedule Class}

\LoadClass[fontsize=14pt]{scrartcl}
%\LoadClassWithOptions{article}[12pt]

\RequirePackage{xparse,l3sort,multirow,typearea,hyperref,tabularx,array}

\areaset{160mm}{270mm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title set up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We set up a property list that holds all the relevant information for the title block
\prop_new:N \g_titleblock_prop

% We generate some document commands that allow the user to set the parts of the title block

\NewDocumentCommand{\SetTitle}{m}{
  \prop_gput:Nnn \g_titleblock_prop {title} {#1}
}

\NewDocumentCommand{\SetInstitute}{m}{
  \prop_gput:Nnn \g_titleblock_prop {institute} {#1}
}

\NewDocumentCommand{\SetDates}{m}{
  \prop_gput:Nnn \g_titleblock_prop {dates} {#1}
}

\NewDocumentCommand{\SetWebsite}{m}{
  \prop_gput:Nnn \g_titleblock_prop {website} {#1}
}

\NewDocumentCommand{\SetVenue}{m}{
  \prop_gput:Nnn \g_titleblock_prop {venue} {#1}
}

% Finally, we define a document command to print the title block.
% Currently, rather crude.

\NewDocumentCommand{\MakeTitle}{}{
  \begin{center}
    {\Large \bfseries \prop_get:Nn \g_titleblock_prop {title} }\\[1em]
    {\large\itshape \prop_get:Nn \g_titleblock_prop {institute} }\\[1em]
    {\url{\prop_get:Nn \g_titleblock_prop {website} }}\\[1em]
    {\itshape \prop_get:Nn \g_titleblock_prop {venue} }
  \end{center}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We setup a sequence that holds the sort names (defined by the first option of the \AddTalk macro).
% We also need a variable that holds the current date.

\seq_new:N \g_names_seq
\tl_new:N \l_thedate_tl
\tl_new:N \l_tmpnote_tl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The AddTalk macro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time, Name, Title
\NewDocumentCommand{\PrintTalk}{mmmm}{
  \emph{#1} &  \textbf{#2} &  #3  \\
}

% Sort, Name, Title, Time, Abstract
\NewDocumentCommand{\AddTalk}{mmmm+m o}{
  \prop_new:c {g_#1_prop}
  \prop_gput:cnn {g_#1_prop} {name} {#2}
  \prop_gput:cnn {g_#1_prop} {title} {#3}
  \prop_gput:cnn {g_#1_prop} {time} {#4}
  \prop_gput:cnn {g_#1_prop} {abstract} {#5}
  \prop_gput:cnn {g_#1_prop} {date} {\l_thedate_tl}
  \seq_gput_right:Nn \g_names_seq {#1}
  \IfNoValueTF{#6}{
      \PrintTalk{#4}{#2}{#3}{#1}
  }{
    \prop_gput:cnn {g_#1_prop} {note} {#6}
    \PrintTalk{#4}{#2}{#3~ [#6]}{#1}
  }

}

\NewDocumentCommand{\AddBreak}{mm}{
  && \\
  \emph{#1} &
  \multicolumn{2}{c}{
    \textbf{#2}\hspace*{5em}
}
\\
&&\\
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Day environment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setlength\extrarowheight{0.5em}
\NewDocumentEnvironment{Day}{m}{
  \tl_set:Nn \l_thedate_tl {#1}
  \begin{center}
    \textbf{#1}
  \end{center}
  \begin{tabular}{l>{\raggedright}p{15em}p{20em}}
}{
    \end{tabular}
}

\NewDocumentCommand{\PrintAbstract}{m}{
  \hspace{-2em}
  \textbf{\prop_get:cn {g_#1_prop} {title}},~
  \emph{\prop_get:cn {g_#1_prop} {name}},~
  \prop_get:cn {g_#1_prop} {date},~ \prop_get:cn {g_#1_prop} {time}.~
  \prop_get:cnNTF {g_#1_prop} {note} \l_tmpa_tl {\emph{[\tl_use:N \l_tmpa_tl]}.~}{}
  \prop_get:cn {g_#1_prop} {abstract}\\[1em]\par
}

\NewDocumentCommand{\ListAbstracts}{}{
  \begin{center}
    \textbf{Abstracts}
  \end{center}

  \setlength\parindent{0pt}
  \seq_map_inline:Nn \g_names_seq {\PrintAbstract{##1}}
}
