#! /usr/bin/env python3
#  coding: utf-8
#
#  Copyright (c) 2017-2020 by Nicolas Mesnier <nmesnier@free.fr>
# 
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 3 or
#  above as published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#=======================================================================
"""Compile a teX file with `teXstyles` bundle.

description:
    Python script to compile a LaTeX documents for lecture notes
    from a teX file and an header file if it exists.

examples:
    $ %(prog)s -d
    $ %(prog)s --corr
"""

__version__   = "0.1.1"
__homepage__  = "teXstyles home page: <http://nmesnier.free.fr/teXstyles.html>"
__author__    = "Nicolas Mesnier <nmesnier@free.fr>"
__copyright__ = "Copyright (c) 2020 by "+__author__
__bugs__      = "Email bug reports to "+__author__+"."
__license__="""\
There is NO warranty. Redistribution of this software is covered
by the terms the GNU General Public License version 3 or above."""

#
#  Parameters
#  ----------
#
data = {
    "teXstylesPATH":"/media/Placard/Boulot/LaTex/PACKAGES_RAF/SCRIPTS/teXstyles/",
    "author":"Raphaël ALLAIS",
    "matiere":"Sciences industrielles de l'ingénieur en PTSI",
    "prefix":"SII",
    "URL":"http://ptsi.geiffel.free.fr/sii/ptsi2/",
    "title":"",
    "headerfile":"header.json",
    # default document
    "doctype": "cours",
    "docvers": "prof",
    "docdest": "web",
    "docclass": "ptsi",
    # file name
    "teXfile": None,
    "TMPfile": "teXdoc",
    "QRfile": "QRcode",
    "debug": False,
}
#
#  Dependencies
#  ------------
#
#   - python standard library:
#
try:
    import os, sys, time        # system
    import subprocess           # os subprocess management
    import shutil               # file operations
    import glob                 # Unix style pathname pattern expansion
    import re                   # Regular expression operations
    import argparse             # Parser for CLI arguments and options
    import datetime             # Basic date and time types
    import textwrap             # Text wrapping and filling
    import json                 # JSON encoder and decoder
    import binascii             # Convert between binary and ASCII
except ImportError:
    # Checks the installation of the necessary python modules
    print((os.linesep * 2).join(["An error found importing one module:",
          str(sys.exc_info()[1]), "You need to install it", "Exit..."]))
    sys.exit(-2)
#
#   - external executables:
#       Latex & Co.: to compile *.tex documents
#       GPL Ghostscript: to make "safe" pdf and edit pdf tags
# 
EXE = {
    "latex": ["latex"],
    "pdflatex": ["pdflatex", "--shell-escape"],
    "dvips": ["dvips", "-q"],    
    "ps2pdf": ["ps2pdf"],
    "gs": ["gs","-dSAFER","-dBATCH","-dNOPAUSE",
        "-sDEVICE=pdfwrite","-dCompatibilityLevel=1.4",
        "-dPDFSETTINGS=/printer",
        "-dNOPLATFONTS", "-dSubsetFonts=true", "-dEmbedAllFonts=true"
        ],
    }
# 
#  Installation
#  ------------
#     - make as executable width "$ chmod +x teXstyles.py"
#     - copy file to "/home/$(whoami)/bin"
#
#  History
#  --------
# 
#     0.1.0 - 22/02/2017 (first release)
#             
# 
#  TO DO
#  -----
#     - supprimer le fichier temp permettant d'éditer les tags
#     - supprimer dir gnuplot
#
#  Any feedback is very welcome.
#  If you find problems, please submit bug reports/patches via email.
#  You can always get the latest version of this module at:
#
#  If that URL should fail, try contacting the author.
#
#
#=======================================================================
# *** documents
#=======================================================================
# types de documents [type, needHeader, needQR, shortoption, help message]
documents=[
    ["cours",    True,  True ,  None,   "Type: cours (default)"],
    ["TD",       True,  False,  None,   "Type: TD"],
    ["polyTD",   True,  True ,  None,   "Type: poly de TD"],
    ["TP",       True,  False,  None,   "Type: TP"],
    ["DS",       True,  False,  None,   "Type: DS"],
    ["interro",  False, False,  "-r",   "Type: interrogation de cours"],
    ["colle",    False, False,  "-c",   "Type: sujet de colle"],
    ["document", False, False,  "-i",   "Type: document"],
    ["pres",     True,  False,  "-b",   "Type: presentation"]
    ]
# types de versions [type, shortoption]
versions=[
    ["prof",  None, "Version: prof (default)"],
    ["eleve", "-e", "Version: eleve"],
    ["corr",  "-o", "Version: correction"]
    ]
# types de destinations [type, shortoption]
destinations=[
    ["web",    None, "Destination: web (default)"],
    ["print",  "-p", "Destination: print"],
    ["screen", "-s", "Destination: screen"]
    ]
# classes
classes=[
    ["ptsi", "Classe: PTSI (default)"],
    ["mpsi", "Classe: MPSI"],
    ["pcsi", "Classe: PCSI"]
    ]
compilteX=True

#=======================================================================
# *** Generic functions (not teXstyles dependant)
#=======================================================================

def PurgeEmptyStr(L):
    """
    Remove empty string of a list.
    """
    N=[]
    for n in L:
        if n:
            N.append(n)
    return(N)

def WriteFile(file, contents):
    """
    Write text file "file" from a list "contents"
    where each item is a line.
    """
    f = open(file,'w')
    for l in contents:
        f.writelines(l+'\n')
    f.close()

def RemoveFiles(pattern):
    """
    Remove files with pattern, e.g.: "*.toc" or "teXdoc.*".
    """
    for file in glob.glob(pattern):
        if os.path.isfile(file):
            os.remove(file)

def RemoveFilesBut(pattern1, pattern2):
    """
    Remove files with pattern1, which have not pattern2.
    Example:
      >>> RemoveFilesBut("tmpfile.*",[".tex","*.pdf"])
      remove all "tmpfile.*" but not "tmpfile.tex" and "tmpfile.pdf".
    """
    L1=glob.glob(pattern1)
    if type(pattern2)==list:
        L2=[]
        for p in pattern2:
            L2=L2+glob.glob(p)
    else:
        L2=glob.glob(pattern2)
    for file in L1:
        if os.path.isfile(file) and file not in L2:
            os.remove(file)

def TimeStamp():
    """
    Make a time stamp with UTC ref of the form YYYYMMDDHHmmSS+02'00'.
    """
    a=int(datetime.datetime.now().strftime("%H"))
    b=int(datetime.datetime.utcnow().strftime("%H"))
    return(datetime.datetime.now().strftime("%Y%m%d%H%M%S")\
        +"+"*((a-b)>=0)+"{0:02d}".format(a-b)+"'00'")
    
def ExtCommand(cmd, args, quiet=True):
    """
    Run an external command defined as a string with arguments
    given as a string or list of strings.
    """
    if type(args)==list:
        l=cmd+args
    else:
        l=cmd+[args]
    if quiet:
        subprocess.call(l, stdout=open(os.devnull, 'wb'))
    else:
        os.system(" ".join(l))
    
def SupprimerAccents2(c):
    """
    Permet de remplacer les accents d'une chaîne de caractères.
    """  
# {á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
# {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
# {à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
# {À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
# {ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
# {Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
# {â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
# {Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
# {œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
# {ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
# {ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
# {€}{{\EUR}}1 {£}{{\pounds}}1
# {°}{{\degres{}}}1
#     
    la={"â":"a","à":"a","ç":"c","é":"e","è":"e","ê":"e","ë":"e",\
        "î":"i","ï":"i","ô":"o","ö":"o","û":"u","ü":"u","ù":"u",\
        "æ":"ae","œ":"oe"}
    # ajout des majuscules
    for k in list(la.keys()).copy():
        la[k.upper()]=la[k].upper()
    # remplacement des lettres accentuées
    z=c
    for k in la.keys():
        z=z.replace(k,la[k])
    return(z)

def JsonRead(infile):
    with open(infile,'r') as f:
        data = json.load(f)
    return(data)

def JsonWrite(data, oufile):
    with open(oufile,'w') as f:
        f.writelines(json.dumps(data, sort_keys=True, indent=4))

#=======================================================================
## *** Fonctions
#=======================================================================

def MakeHeader(headerfile):
    """
    make header file
    """
    print("Create header file")
    # type de document
    print(" *** Types de document :")
    for i,d in enumerate(doctypes):
        print("\t"+"{0:2d}".format(i)+" : "+d)
    t=-1
    while 0>t or t>len(doctypes):
        t=int(input(" >> Type de document ? "))
        choix1=doctypes[t]
    # fichier teX
    print(" *** fichier teX source :")
    fichiersdispo=glob.glob("*.tex")
    for i,f in enumerate(fichiersdispo):
        print("\t"+"{0:2d}".format(i)+" : "+f)
    t=-1
    while 0>t or t>len(fichiersdispo):
        t=int(input(" >> Fichier teX ? "))
        teXfile=fichiersdispo[t]
    # write header file
    data={
        "doctype":choix1,
        "teXfile":teXfile,
        "docname":os.path.basename(os.getcwd()),
        }
    # read teX file to get title and author mad merge dico
    data = { **data, **GetMeta(teXfile)}
    # WriteFile(headerfile, contents)
    JsonWrite(data, headerfile)

def ReadHeader(headerfile):
    """
    read header file 
    """
    if os.path.isfile(headerfile):
        data = JsonRead(headerfile)
        return(data)
    else:
        print("Header file does not exists!")
        MakeHeader(headerfile)
        data = ReadHeader(headerfile)
        return(data)

def GetMeta(teXfile):
    """
    Get title and author from teX file.
    """
    # read teX file to get title and author
    data ={}
    file=open(teXfile,'r')
    for i,line in enumerate(file):
        l=line.strip().strip('\n').strip('\t').strip(' ')
        if re.search("^\\\\title(\[{1}[^\]]*\]{1})?\{",l) or re.search("^\\\\chapter(\[{1}[^\]]*\]{1})?\{",l):
            z=re.sub("^\\\\title(\[{1}[^\]]*\]{1})?\{","",l)
            z=re.sub("^\\\\chapter(\[{1}[^\]]*\]{1})?\{","",z).strip('}')
            z=re.sub('\\\,',' ',z)
            z=re.sub('\\\\','',z)
            data["title"]=z
        elif re.search("^\\\\author[\[\{]",l):
            data["author"]=l.split("{")[1].strip("}").replace('\\','')
        elif re.search("^\\\\maketitle",l) or re.search("^\\\\titlepage",l):
            break
    file.close()
    return(data)

def SuppressUnit(s):
    """
    Supress a string unit and convert it on inch.
    """
    if s[-2:]=="in":
        z=float(s[:-2])
    elif s[-2:]=="cm":
        z=float(s[:-2])*2.54
    elif s[-2:]=="mm":
        z=float(s[:-2])*25.4    
    else:
        z=1.
    return(str(z))

def MakeQR(URL, QRfile, size=('1in','1in')):
    """
    generate QR code
    """
    # fichier teX
    c=[]
    c.append("\\batchmode")
    c.append("\\documentclass[a4paper,10pt]{article}")
    c.append("\\usepackage[utf8]{inputenc}")
    c.append("\\usepackage{color,calc,graphicx,pstricks,pst-barcode}")
    c.append("\\usepackage[paperwidth="+size[0]+",paperheight="+size[1]+\
        ",textwidth="+size[0]+",textheight="+size[1]+",centering]{geometry}")
    c.append("\\begin{document}")
    c.append("\\noindent")
    c.append("\\begin{pspicture}("+size[0]+","+size[1]+")")
    t = [SuppressUnit(e) for e in size]
    c.append("\\psbarcode[linecolor=black]{"+URL+"}{width="+t[0]+\
        " height="+t[1]+"}{qrcode}%")
    c.append("\\end{pspicture}")
    c.append("\\end{document}")
    # écriture du fichier
    WriteFile(QRfile+".tex",c)
    # compilation
    ExtCommand(EXE["latex"], QRfile+".tex")
    ExtCommand(EXE["dvips"], QRfile+".dvi")
    ExtCommand(EXE["ps2pdf"], QRfile+".ps")
    # purge all but pdf
    RemoveFilesBut(QRfile+".*","*.pdf")
    
def MakeTeX(data):
    """
    make LateX main document (with options)
    """
    # fichier teX
    c=[]
    c.append("%"+71*"=")
    if sys.argv[0]!="":
        c.append("% *** This is an autogenerated file by python script '"+os.path.basename(sys.argv[0])+"'. ***")
    else:
        c.append("% *** This is an autogenerated file. ***")
    c.append("% *** DO NOT EDIT ***")
    c.append("%"+71*"=")
    if not data['debug']:
        c.append("\\batchmode")
    c.append("\\makeatletter\\def\\input@path{{"+data['teXstylesPATH']+"/},{img/}}\\makeatother")
    if data['doctype']=="pres":
        c.append("\\documentclass["+data['docclass']+"]{mypresentation}")
    else:
        c.append("\\documentclass["+data['doctype']+","+data['docvers']+","+data['docdest']+","+data['docclass']+"]{teXstyles}")
    c.append("\\graphicspath{{"+data['teXstylesPATH']+"/licence/},{"+data['teXstylesPATH']+"/img/},{img/}}")
    if data['doctype']!="interro":
        c.append("\\hypersetup{%\n"+\
            "    pdftitle={"+data['title']+"},%\n"+\
            "    pdfauthor={"+data['author']+"},%\n"+\
            "    pdfsubject={"+data['matiere']+"},%\n"+\
            "}")
    c.append("\\usepackage{import}%\n")
    c.append("\\begin{document}")
    
    # date automatique pour les présentations
    if data['doctype']=="pres":
        if datetime.datetime.now().month <= 7:
            c.append("\\date{"+str(datetime.datetime.now().year-1)+"\\textendash "+str(datetime.datetime.now().year)+"}")
        else:
            c.append("\\date{"+str(datetime.datetime.now().year)+"\\textendash "+str(datetime.datetime.now().year+1)+"}")

    if data['doctype']!="pres" and data['doctype']!="interro":
        c.append("\\doc{"+data['webfile']+".pdf}")
    c.append("\\input{"+data['teXfile']+"}")
    c.append("\\end{document}")
    c.append("%"+68*"="+"eof")
    # écriture du fichier
    WriteFile(data['TMPfile']+".tex",c)

def PurgeDir(dir):
    for file in os.listdir(dir):
        if os.path.isfile(os.path.join(dir, file)):
            os.unlink(os.path.join(dir, file))

def CreateOrPurgeDir(dir):
    if not os.path.isdir(dir):
        os.mkdir(dir)
    else:
        PurgeDir(dir)

def PurgeAndRemoveDir(dir):
    PurgeDir(dir)
    if os.path.isdir(dir):
        os.rmdir(dir)

def TeXCompilation(data, n=3):
    """
    LateX compilation
    """
    # compilation
    if data['debug']:
        ExtCommand(EXE["pdflatex"], data["TMPfile"]+".tex", quiet=False)
    else:
        for k in range(n):
            ExtCommand(EXE["pdflatex"], data["TMPfile"]+".tex")
        # *** set pdf tags
        tagsFile = data["TMPfile"]+".tags"
        pdf_SetTags(data, tagsFile)
        # *** format layout
        if data["doctype"]!="pres":    
            if data["docdest"]=="print":
                pdf_2up(data["TMPfile"]+".pdf", data["TMPfile"]+"_2up.pdf")
                pdf_safe_tags(data["TMPfile"]+"_2up.pdf", tagsFile, data["docname"])
            elif data["docdest"]=="web" or data["docdest"]=="screen":
                pdf_safe_tags(data["TMPfile"]+".pdf", tagsFile, data["docname"])
#                pdf_safe_tags(data["TMPfile"]+".pdf", tagsFile, data["docname"].lower())
        else:
            if data["docdest"]=="print":
                pdf_4up(data["TMPfile"]+".pdf", data["TMPfile"]+"_4up.pdf")
                pdf_safe_tags(data["TMPfile"]+"_4up.pdf", tagsFile, data["docname"])
            elif data["docdest"]=="web":
                pdf_safe_tags(data["TMPfile"]+".pdf", tagsFile, data["docname"])
#                pdf_safe_tags(data["TMPfile"]+".pdf", tagsFile, data["docname"].lower())

def PurgeTeX(TMPfile):
    """
    Purge teX temp files.
    """
    for extension in ["aux","bbl","blg","dvi","log","mtc*",",nav","out",
        "ptc*","snm","spl","toc","~"]:
        RemoveFiles(TMPfile+"."+extension)

def PurgeTMPfile(TMPfile):
    """
    Purge temp files.
    """
    RemoveFiles(TMPfile+"*")
    
#=======================================================================
## *** pdf manipulations
#=======================================================================

#-----------------------------------------------------------------------
# *** to compose pdf (like pdfjam)
#-----------------------------------------------------------------------

def pdf_compose(infile, mode, outfile=None, paper="a4paper", landscape=False):
    """
    Simplified python fork of the `pdfjam` shell-script interface to the
    `pdfpages` LaTeX package.
    """
    # paper size
    if paper[:2].lower() not in ["a3","a4","a5"]:
        papersize="a4paper"
    else:
        papersize=paper[:2].lower()+"paper"
    # composition mode
    if mode=="2up":
        documentOptions=papersize+",twoside"
        includepdfOptions="nup=2x1,scale=1,pages=-"
    elif mode=="4up":
        documentOptions=papersize+",twoside"
        includepdfOptions="nup=2x2,scale=.95,frame=true,delta=1.2cm 0.5cm,pages=-"        
    elif mode=="booklet":
        documentOptions=papersize+",twoside"
        includepdfOptions="booklet,scale=1,pages=-"
    # outfile name
    if outfile==None:
        outfile=infile[:-4]+"_"+mode+".pdf"
    # layout
    if ( (mode=="2up" or mode=="booklet") and not(landscape)) \
        or ( mode=="4up" and landscape) :
        documentOptions+=",landscape"
    # teX file
    c=[]
    c.append("\\batchmode")
    c.append("\\documentclass["+documentOptions+"]{article}")
    c.append("\\usepackage{color}")
    c.append("\\usepackage["+documentOptions+"]{geometry}")
    c.append("\\usepackage[utf8]{inputenc}")
    c.append("\\usepackage{hyperref}")
    c.append("\\usepackage{pdfpages}")
    c.append("\\usepackage{import}")
    if mode=="booklet":
        c.append("\\usepackage{everyshi}")
        c.append("\\makeatletter")
        c.append("\\EveryShipout{\\ifodd\\c@page\\pdfpageattr{/Rotate 180}\\fi}")
        c.append("\\makeatother")
    c.append("\\begin{document}")
    c.append("\\includepdf["+includepdfOptions+"]{"+infile+"}")
    c.append("\\end{document}")
    # write teX file
    WriteFile(outfile[:-4]+".tex",c)
    ExtCommand(EXE["pdflatex"], outfile[:-4]+".tex")

def pdf_2up(infile, outfile):
    """
    to set 2x1 pdf file (such as lpr -o number-up=2)
    """
    pdf_compose(infile, "2up", outfile)
        
def pdf_4up(infile, outfile, landscape=True):
    """
    to set 2x2 pdf file
    """
    pdf_compose(infile,"4up", outfile, landscape=landscape)

def pdf_booklet(infile, outfile, paper="a4paper"):
    """
    compose A* booklet
    """
    pdf_compose(infile, "booklet", outfile, paper)

#-----------------------------------------------------------------------
# *** to produce print safe with tags
#-----------------------------------------------------------------------

def pdf_safe(infile, outfile=None):
    """
    to get safe pdf
    """
    if outfile==None:
        outfile=infile[:-4]+"_safe.pdf"
    ExtCommand(EXE["gs"],["-sOutputFile="+outfile, infile])

def pdf_safe_tags(infile, tagsFile, outfile=None):
    """
    to get safe pdf with tags
    """
    if outfile==None:
        outfile=infile[:-4]+"_safe.pdf"
    # edit pdf tags
    ExtCommand(EXE["gs"],["-dDOPDFMARKS", "-sOutputFile="+outfile, infile, tagsFile])

def pdfTag(c):
    """
    Edit pdf tags to handle UTF-8 (accents).
    """
    # if not ascii, change encoding
    if False in [ord(k)<128 for k in c]:
        return(' <FEFF'+str(binascii.hexlify(c.encode('UTF-16BE')))[2:-1].upper()+">")
    else:# ascii
        return(" ("+c+")")

def pdf_SetTags(data, tagsFile):
    """
    Set pdf tags "InfoKey:InfoValue".
    """
    tags={
        "Title": data["title"],
        "Author": data["author"],
        "Subject": data["matiere"],
        "CreationDate": 'D:'+TimeStamp(),
        "ModDate": 'D:'+TimeStamp(),
        "Producer": "pdfTeX 1.40.17 + GPL Ghostscript 9.20",
        "Creator": "LaTeX with teXstyles "+__version__,
        "Keywords": data["doctype"],
        }
    c=["[ "]
    for i,t in enumerate(tags.keys()):
        if tags[t]!="":
            if i==0:
                c[-1]+="/"+t+pdfTag(tags[t])
            else:
                c.append("  /"+t+pdfTag(tags[t]))
    c.append("  /DOCINFO pdfmark")
    WriteFile(tagsFile,c)

#======================================================================
## *** standalone program
#=======================================================================

doctypes=[d[0] for d in documents]
docversions=[v[0] for v in versions]
docdestionations=[d[0] for d in destinations]
needHeader={}
needQR={}
shortoptions={}
for d in documents:
    needHeader[d[0]]=d[1]
    needQR[d[0]]=d[2]
    if d[3]!=None:
        shortoptions[d[3]]=d[0]
for d in versions+destinations:
    if d[1]!=None:
        shortoptions[d[1]]=d[0]

shortoptions['-h']='help'
shortoptions['?']='help'


if __name__ == '__main__':# and sys.argv[0]!='' and len(sys.argv)>0:
    """
    Standalone program
    """
    try:
        # command-line arguments and options       
        parser = argparse.ArgumentParser(
                        prog=os.path.basename(sys.argv[0]),
                        formatter_class=argparse.RawDescriptionHelpFormatter,
                        description=__doc__,
                        epilog=textwrap.dedent("\n".join([__homepage__,"\n",__bugs__ ]))
                        )
        # *** document type
        doctype_group = parser.add_mutually_exclusive_group(required=False)
        for d in documents:
            if d[3]!=None:
                doctype_group.add_argument(
                                '--'+d[0], d[3],
                                default=None,
                                nargs=1,
                                metavar='<inputfile>',
                                dest=d[0],
                                action='store',
                                help=d[4])
            else:
                doctype_group.add_argument(
                                '--'+d[0],
                                default=None,
                                nargs=1,
                                metavar='<inputfile>',
                                dest=d[0],
                                action='store',
                                help=d[-1])
        # *** version
        docvers_group = parser.add_mutually_exclusive_group(required=False)
        for d in versions:
            if d[1]!=None:
                docvers_group.add_argument(
                                '--'+d[0], d[1],
                                default=d[0],
                                const=d[0],
                                action='store_const',
                                dest='docvers',
                                help=d[-1])
            else:
                docvers_group.add_argument(
                                '--'+d[0],
                                default=d[0],
                                const=d[0],
                                action='store_const',
                                dest='docvers',
                                help=d[-1])
        # *** destination
        docdest_group = parser.add_mutually_exclusive_group(required=False)
        for d in destinations:
            if d[1]!=None:
                docdest_group.add_argument(
                                '--'+d[0], d[1],
                                default=d[0],
                                const=d[0],
                                action='store_const',
                                dest='docdest',
                                help=d[-1])
            else:
                docdest_group.add_argument(
                                '--'+d[0],
                                default=d[0],
                                const=d[0],
                                action='store_const',
                                dest='docdest',
                                help=d[-1])
        # *** classe
        docclass_group = parser.add_mutually_exclusive_group(required=False)
        for d in classes:
            docclass_group.add_argument(
                            '--'+d[0],
                            default=d[0],
                            const=d[0],
                            action='store_const',
                            dest='docclass',
                            help=d[-1])
        # *** compilation mode (dev)
        parser.add_argument(
                        '-d', '--debug',
                        default=False,
                        action='store_true',
                        dest='debug',
                        help="Development mode")                     

        parser.add_argument(
                        '-v', '--version',
                        default=False,
                        action='version',
                        version=textwrap.dedent("\n".join([
                            '%(prog)s '+__version__,
                            __copyright__,__license__])),
                        help="Print version information and exit.")
        
        # read command-line arguments and options 
        args = parser.parse_args()
        needHeader=True
        for d in documents:
            if eval('args.'+d[0]):
                data["doctype"]=d[0]
                data["teXfile"]=eval('args.'+d[0]+'[0]')
                needHeader=False
                break
        
        for arg in ["docvers", "docdest", "docclass", "debug"]:
            if eval('args.'+arg):
                data[arg]=eval('args.'+arg)
        
        # if data["teXfile"] and data["doctype"]:
        if not needHeader:
            if data["doctype"] in ["TD", "pres"]:
                data["docname"]=os.path.basename(os.getcwd())
            else:
                data["docname"]=os.path.basename(data["teXfile"])[:-4]
            # read teX file to get title and author and merge dico
            data = { **data, **GetMeta(data["teXfile"])}
        else:
            # read header JSON file and merge dico
            data = { **data, **ReadHeader(data['headerfile'])}
        # *** debug
        # print(data)
        # ***
        data["prefix"] = data["prefix"]+"-"+data["docclass"].upper()
        if data["docclass"].lower() == "pcsi":
            data['URL'] = "https://sites.google.com/site/pcsijeanperrin/sii/"
        elif data["docclass"].lower() == "mpsi":
            data['URL'] = "http://mpsi.jplyon.free.fr/sii/"
        # document names
        data["webfile"]="-".join(PurgeEmptyStr([data["prefix"], data["docname"]]))
        # document name
        data["docname"]="".join(PurgeEmptyStr([
            "_".join(PurgeEmptyStr([
                "-".join(PurgeEmptyStr([data["prefix"], data["docname"]])),
                "pres"*(data["doctype"]=="pres"),
                "corr"*(data["docvers"]=="corr"),
                "".join([
                    "e"*(data["docvers"]=="eleve"),
                    "print"*(data["docdest"]=="print"),
                    ]),
                ])),
            ".pdf"
            ]))
        if data["docvers"]=="corr":
            data["teXfile"]=data["teXfile"][:-4]+"_corr.tex"
        # *** debug
#         compilteX=False
        # ***
        # write main teX file
        MakeTeX(data)
        # Check if QR exists if needed, otherwise create it.
        if needQR[data['doctype']] and not(os.path.isfile(data['QRfile']+".pdf")):
#            MakeQR(data['URL']+data['webfile'].lower()+".pdf", data['QRfile'])
            MakeQR(data['URL']+data['webfile']+".pdf", data['QRfile'])
        if compilteX:           
            CreateOrPurgeDir("gnuplot")
            if not data['debug']:
                TeXCompilation(data)
                PurgeTMPfile(data["TMPfile"])
                PurgeAndRemoveDir("gnuplot")
                PurgeTMPfile(data['QRfile'])
            else:
                TeXCompilation(data, 1)

    except KeyboardInterrupt:
        print("\n! Emergency stop. Shutdown requested...exiting")
        sys.exit(2)

#====================================================================eof

