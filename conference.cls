\RequirePackage{expl3}
\ProvidesExplClass{conference}{2013/05/13}{0.1}{Conference Schedule Class}

%\LoadClass{scrartcl}
\LoadClass{article}

\RequirePackage{xparse,l3sort,multirow,typearea,hyperref,tabularx}

\areaset{160mm}{270mm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title set up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\tl_new:N \g_title_tl
\tl_new:N \g_institute_tl
\tl_new:N \g_dates_tl
\tl_new:N \g_venue_tl
\tl_new:N \g_website_tl

\NewDocumentCommand{\SetTitle}{m}{
  \tl_gset:Nn \g_title_tl {#1}
}

\NewDocumentCommand{\SetInstitute}{m}{
  \tl_gset:Nn \g_institute_tl {#1}
}

\NewDocumentCommand{\SetDates}{m}{
  \tl_gset:Nn \g_dates_tl {#1}
}

\NewDocumentCommand{\SetWebsite}{m}{
  \tl_gset:Nn \g_website_tl {#1}
}

\NewDocumentCommand{\SetVenue}{m}{
  \tl_gset:Nn \g_venue_tl {#1}
}

\NewDocumentCommand{\MakeTitle}{}{
  \begin{center}
    {\Large \bfseries \tl_use:N \g_title_tl}\\[1em]
    {\large\itshape \tl_use:N \g_institute_tl}\\[1em]
    {\expandafter\url{\tl_use:N\g_website_tl}}\\[1em]
    {\itshape \tl_use:N \g_venue_tl}
  \end{center}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\seq_new:N \g_names_seq
\tl_new:N \l_thedate_tl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The AddTalk macro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time, Name, Title
\NewDocumentCommand{\PrintTalk}{mmmm}{
  \emph{#1} &  \textbf{#2} &  #3 \\
}

% Sort, Name, Title, Time, Abstract
\NewDocumentCommand{\AddTalk}{mmmm+m}{
  \tl_new:c {l_#1_name_tl}
  \tl_gset:cn {l_#1_name_tl} {#2}
  \tl_new:c {l_#1_title_tl}
  \tl_gset:cn {l_#1_title_tl} {#3}
  \tl_new:c {l_#1_time_tl}
  \tl_gset:cn {l_#1_time_tl} {#4}
  \tl_new:c {l_#1_abstract_tl}
  \tl_gset:cn {l_#1_abstract_tl} {#5}
  \tl_new:c {l_#1_date_tl}
  \tl_gset_eq:cN {l_#1_date_tl} \l_thedate_tl
  \seq_gput_right:Nn \g_names_seq {#1}
  \PrintTalk{#4}{#2}{#3}{#1}
}

\NewDocumentCommand{\AddBreak}{mm}{
  && \\
  \emph{#1} &
  \multicolumn{2}{c}{
    \textbf{#2}
}
\\
&&\\
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Day environment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
  \textbf{\tl_use:c{l_#1_title_tl}},~
  \emph{\tl_use:c{l_#1_name_tl}},~
  \tl_use:c{l_#1_date_tl},~ \tl_use:c{l_#1_time_tl}.~
  \tl_use:c{l_#1_abstract_tl} \\[1em]\par
}

\NewDocumentCommand{\ListAbstracts}{}{
  \begin{center}
    \textbf{Abstracts}
  \end{center}

  \setlength\parindent{0pt}
  \seq_map_inline:Nn \g_names_seq {\PrintAbstract{##1}}
}
