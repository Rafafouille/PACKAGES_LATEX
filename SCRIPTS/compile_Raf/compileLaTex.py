#!/usr/bin/env python3
# -*- coding: utf-8 -*-



import sys
import getopt
import re
import os

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)


COMPILE_PROF = False;
COMPILE_ELEVE = False;
COMPILE_SIMPLE = True; # Un simple pdflatex sur le fichier principal
TYPE = ""
UNIQUE = False; # Si on fait une seule compile au lieu de 2
VISUALISE = False; #Si on veut ouvrir le PDF apres la compile
NETTOIE = False ; #Si on veut virer les fichiers temporaires

rouge = "\033[91m"
vert = "\033[92m"
reset = "\033[0m"
jaune = "\033[93m"
italic = "\033[3m"

# GESTION DES ARGUMENTS ==================================================

arg_passes = sys.argv[1:]  #On enleve le nom du script de la liste des arguments passes

def usage():
	print("""\nusage : """+italic+"""compileLaTex [-h|-e|-p|-u|-c] fichier.tex"""+reset+"""
-h, --help :\taide
-e, --eleve :\tMode 'eleve' (sans les corrections)
-p, --prof :\tMode 'prof' (avec les corrections)
-u, --unique :\tUne seule compilation (risque de ne pas avoir le toc complet...)
-c, --cours :\tType de document : 'cours'
-d, --td :\tType de document : 'TD'
-t, --tp :\tType de document : 'TP'
-s, --ds :\tType de document : 'DS'
-m, --dm :\tType de document : 'DM'
-k, --kholle :\tType de document : 'Khôlle"
-n, --nettoie :\tNettoie la(les) compilation(s) de ses fichiers temporaires
-v, --visualise :\tOuvre le lecteur PDF à la fin (Okular)""")


try:
	opts, args = getopt.getopt(arg_passes, "hepucdtsmknv", ["help", "eleve", "prof","unique","cours","td","tp","ds","dm","kholle","nettoie","visualise"]) # On récupère les options
except getopt.GetoptError:  
	print(rouge+"Erreur de syntaxe"+reset)        
	usage()                         
	sys.exit(2)
	
for opt, arg in opts: # Pour chaque option passées ("-arg","valeur du parametre additionnel")
	if opt in ("-h","--help"):
		usage()
		sys.exit()
	if opt in ("-e", "--eleve"):
		COMPILE_ELEVE = True;
		COMPILE_SIMPLE = False;
		print(" -> Version élève demandée")
	if opt in ("-p", "--prof"):
		COMPILE_PROF = True;
		COMPILE_SIMPLE = False;
		print(" -> Version prof demandée")
	if opt in ("-u", "--unique"):
		UNIQUE = True
	if opt in ("-v","--visualise"):
		VISUALISE = True
	if opt in ("-n","--nettoie"):
		NETTOIE = True
	if opt in ("-c", "--cours"):
		TYPE = "cours"
	if opt in ("-d", "--td"):
		TYPE = "td"
	if opt in ("-r", "--tp"):
		TYPE = "tp"
	if opt in ("-s", "--ds"):
		TYPE = "ds"
	if opt in ("-m", "--dm"):
		TYPE = "dm"
	if opt in ("-k", "--kholle"):
		TYPE = "kholle"
if len(args)==0:
	print(rouge+"Il manque le nom du fichier : "+italic+"compileLaTex monFichier.tex"+reset)
	sys.exit(2)
nomFichier = args[0] # Nom du fichier d'entrée

# Test ouverture fichier ==================================================
try:
    with open(nomFichier, 'r') as f:
       pass
except FileNotFoundError as e:   
	print(rouge+"Le fichier '"+nomFichier+"' n'a pas été trouvé."+reset)
	sys.exit(2)
except IOError as e:
	print(rouge+"Erreur d'ouverture du fichier."+reset)
	sys.exit(2)

# On sépare le nom du fichier de son extensions
partiesNom = nomFichier.split(".")
nomSansExt = "".join(partiesNom[:-1])
nomExt = partiesNom[-1]



# FONCTION DE COMPILATIONS ==================================================

fichier = open(nomFichier,"r")
lignes = fichier.readlines()

# texte est liste de ligne. Mode = "prof" ou "eleve"
def generePageFormatee(texte,mode=""):
	output = ""
	for ligne in lignes :
		if re.search('\\\\version\s*\{\s*prof\s*\}',ligne) and not COMPILE_SIMPLE: # S'il y a déjà un mode, et qu'on est pas en compile simple : on supprime le mode
			print(" -> "+jaune+"Un ancien mode de version a été trouvé dans le fichier source, et ignoré."+reset)
		elif (re.search('\\\\makePageDeGarde',ligne) or re.search('\\\\makeEnteteDM',ligne) or re.search('\\\\makeEnteteTD',ligne) or re.search('\\\\makeEnteteColle',ligne)) and TYPE!="": # S'il y a déjà un mode, et qu'on est pas en compile simple : on supprime le mode
			print(" -> "+jaune+"Le type initial a été ignoré au profit du type demandé : "+TYPE+reset)
		else :
			if(re.search('\\\\begin\s*\{\s*document\s*\}',ligne)):
				if(mode=="eleve"):
					output+="\\version{eleve}\n\n"
				elif(mode=="prof"):
					output+="\\version{prof}\n\n"
			output += ligne
			
			if(re.search('\\\\begin\s*\{\s*document\s*\}',ligne)):
				if TYPE=="cours":
					output += "\\makePageDeGarde\n"
				elif TYPE=="td":
					output += "\\makeEnteteTD\n"
				elif TYPE=="tp":
					"a faire"
				elif TYPE=="ds":
					"a faire"
				elif TYPE=="dm":
					output += "\\makeEnteteDM\n"
				elif TYPE=="kholle":
					output += "\\makeEnteteColle\n"
				
	return output
	
	
# COMPILATION =========================================

def compileLaTex(contenu,nomSansExt):
	fichier = open(nomSansExt+".tex","w")
	fichier.write(contenu)
	fichier.close()
	os.system("pdflatex -quiet -interaction=nonstopmode "+nomSansExt+".tex")
	if(not UNIQUE): #Seconde compilation
		os.system("pdflatex -quiet -interaction=nonstopmode "+nomSansExt+".tex")
	if(VISUALISE):
		os.system("okular "+nomSansExt+".pdf&")

def nettoie(nomSansExt,deleteSource=False):
	if(deleteSource):
		os.remove(nomSansExt+".tex")
	os.remove(nomSansExt+".aux")
	os.remove(nomSansExt+".out")
	os.remove(nomSansExt+".toc")
	os.remove(nomSansExt+".log")
	
if COMPILE_ELEVE:
	output = generePageFormatee(lignes,"eleve")
	nomFichierELEVEsansExt = nomSansExt+"_ELEVE"
	compileLaTex(output,nomFichierELEVEsansExt)
	if(NETTOIE):
		nettoie(nomFichierELEVEsansExt,True)
if COMPILE_PROF:
	output = generePageFormatee(lignes,"prof")
	nomFichierPROFsansExt = nomSansExt+"_PROF"
	compileLaTex(output,nomFichierPROFsansExt)
	if(NETTOIE):
		nettoie(nomFichierPROFsansExt,True)
if COMPILE_SIMPLE:
	output = generePageFormatee(lignes)
	compileLaTex(output,nomSansExt)
	if(NETTOIE):
		nettoie(nomSansExt,False)
	


	

