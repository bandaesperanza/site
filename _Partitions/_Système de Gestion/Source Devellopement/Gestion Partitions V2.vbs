fin=7
Do While Fin<>587

If fin=7 Then
'*********** Demande de ce que l'on veut faire *************
Type_programme = InputBox("Choisir le programme à exécuter." & vbCrLf & vbCrLf & "1 = Renomage des partitions" & vbCrLf & "2 = Renseignment de l'excel" & vbCrLf & "3 = Renseignment de l'excel Global" & vbCrLf & "4 = Générer les partitions manquantes par instrument", "Banda Esperanza - Tyrosse" , "")
End If

'******* Chemin du script ************
Set FSO = CreateObject("Scripting.FileSystemObject")
path_Scr = fso.GetParentFolderName(wscript.ScriptFullName)
nbre_path_Scr=Len(path_Scr)

'******** Recuperation du chemin dropbox ********
Path_dropbox = (Left(path_Scr,(nbre_path_Scr - 36)))


'*********** Selection du programme ***************
Select Case Type_programme

Case 99   'debug 


Case ""
	MsgBox "Abandon opérateur",vbCritical
	Wscript.Quit
	
Case 1	'Renomage des partitions

'************** Recuperation du dossier à traiter *****************
'Création des objet et appel des fonction de browse
Set oShell = CreateObject("Shell.Application")
Set oFolder = oShell.BrowseForFolder(&H0&, "Choisir un répertoire", &H1, Path_dropbox)

'Test si un dossier est bien selectionner
If oFolder is Nothing Then 
	MsgBox "Abandon opérateur",vbCritical
	Wscript.quit
Else
  Set oFolderItem = oFolder.Self
End If

'Création de l'objet de gestion des fichier
Set Obj_Fichier = CreateObject("Scripting.FileSystemObject")

'Boucle de construction de la propriété liste des fichier
LISTE_FICHIER = ""
NBRE = 0
Rep = oFolderItem.path
Morceau = oFolderItem
For Each Obj_Liste In  Obj_Fichier.GetFolder(Rep).Files
	If LISTE_FICHIER <> "" Then
		LISTE_FICHIER = LISTE_FICHIER & ";" & Obj_Liste.Name
	Else
		LISTE_FICHIER = Obj_Liste.Name
	End If
	If Left((Right(Obj_Liste.Name, 4)),1) = "." Then
		NBRE = NBRE + 1
	End If		
Next

'Renseignement des fichiers
TABL_FICHIER = Split(LISTE_FICHIER, ";")

'Renomage
Set objFSO = CreateObject("Scripting.FileSystemObject")

For J=0 To (NBRE - 1)
	NOM_FICHIER_NORM = TABL_FICHIER(j)
	NOM_FICHIER = LCase(TABL_FICHIER(j))
	Select Case NOM_FICHIER
		Case "clarinette 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\08 - " & Morceau & " - Clarinette 1.pdf"
		Case "clarinette 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\09 - " & Morceau & " - Clarinette 2.pdf"
		Case "clarinette 3.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\10 - " & Morceau & " - Clarinette 3.pdf"
		Case "flute.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\03 - " & Morceau & " - Flute.pdf"
		Case "saxo alto 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\17 - " & Morceau & " - Saxo Alto 1.pdf"
		Case "saxo alto 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\18 - " & Morceau & " - Saxo Alto 2.pdf"
		Case "baryton.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton.pdf"
		Case "Euphonium Fa 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 1 Fa.pdf"
		Case "Euphonium Fa 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 2 Fa.pdf"
		Case "Euphonium Sol 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 1 Sol.pdf"
		Case "Euphonium Sol 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 2 Sol.pdf"
		Case "baryton 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 1.pdf"
		Case "baryton 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 2.pdf"
		Case "saxo tenor.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\19 - " & Morceau & " - Saxo Tenor.pdf"
		Case "Saxo ténor 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\19 - " & Morceau & " - Saxo Tenor 1.pdf"
		Case "Saxo ténor 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\19 - " & Morceau & " - Saxo Tenor 2.pdf"			
		Case "souba.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba.pdf"
		Case "Souba Fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Fa.pdf"
		Case "Souba Sol.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Sol.pdf"
		Case "trombone.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\29 - " & Morceau & " - Trombone 1 Principal.pdf"
		Case "trompette 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\22 - " & Morceau & " - Trompette 1.pdf"
		Case "trompette 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\23 - " & Morceau & " - Trompette 2.pdf"
		Case "trompette 3.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\24 - " & Morceau & " - Trompette 3.pdf"
		Case "baryton bb 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton.pdf"
		Case "basse bb 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba 1.pdf"
		Case "basse bb 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba 2.pdf"
		Case "batterie.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\35 - " & Morceau & " - Batterie.pdf"
		Case "bugle eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\13 - " & Morceau & " - Bugle Eb.pdf"
		Case "bugle 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\13 - " & Morceau & " - Bugle 1.pdf"
		Case "bugle 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\14 - " & Morceau & " - Bugle 2.pdf"
		Case "bugle 3.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\15 - " & Morceau & " - Bugle 3.pdf"
		Case "euphonium bb clef sol.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\34 - " & Morceau & " - Euphonium 2.pdf"
		Case "percussion.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\36 - " & Morceau & " - Percussion.pdf"
		Case "saxo alto.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\17 - " & Morceau & " - Saxo Alto 1.pdf"
		Case "trombone 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\29 - " & Morceau & " - Trombone 1.pdf"
		Case "trombone 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\30 - " & Morceau & " - Trombone 2.pdf"
		Case "trombone 3.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\31 - " & Morceau & " - Trombone 3.pdf"
		Case "basse bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba.pdf"
		Case "caisse claire.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\35 - " & Morceau & " - Caisse Claire.pdf"
		Case "grosse caisse.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\36 - " & Morceau & " - Grosse Caisse.pdf"
		Case "clarinette pral.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\07 - " & Morceau & " - Clarinette Principale.pdf"
		Case "baryton 1 bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 1.pdf"
		Case "baryton 2 bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 2.pdf"
		Case "baryton bb 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton 2.pdf"
		Case "baryton bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton.pdf"
		Case "basse ut.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Ut.pdf"
		Case "basse-contrebasse bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba.pdf"
		Case "contrebasse bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Contrebasse.pdf"
		Case "contrebasse eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Contrebasse Eb.pdf"
		Case "clarinette eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\06 - " & Morceau & " - Clarinette Eb.pdf"
		Case "hautbois.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\05 - " & Morceau & " - Hautbois.pdf"
		Case "saxo baryton.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\20 - " & Morceau & " - Saxo Baryton.pdf"
		Case "Saxophone baryton.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\20 - " & Morceau & " - Saxo Baryton.pdf"				
		Case "baryton-euphonium.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton.pdf"
		Case "basse bb fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba.pdf"
		Case "basse bb sol.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba 2.pdf"
		Case "cor eb 1 et 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor Eb 1 et 2.pdf"
		Case "cor fa 1 et 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor Fa 1 et 2.pdf"
		Case "timbale.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\38 - " & Morceau & " - Timbale.pdf"
		Case "clarinette.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\07 - " & Morceau & " - Clarinette Principale.pdf"
		Case "guitare.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\99 - " & Morceau & " - Guitare.pdf"
		Case "saxo basse.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\21 - " & Morceau & " - Saxo Basse.pdf"
		Case "trombone bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\29 - " & Morceau & " - Trombone 1 Bb.pdf"
		Case "trompette ut.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\22 - " & Morceau & " - Trompette 1 Ut.pdf"
		Case "trompette.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\22 - " & Morceau & " - Trompette 1.pdf"
		Case "tuba ut.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Ut.pdf"
		Case "bombardino ut.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\34 - " & Morceau & " - Euphonium Ut.pdf"
		Case "cor 1 eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor Eb 1.pdf"
		Case "cor 2 eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\26 - " & Morceau & " - Cor Eb 2.pdf"
		Case "cor 3 eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\27 - " & Morceau & " - Cor Eb 3.pdf"
		Case "cor 4 eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\28 - " & Morceau & " - Cor Eb 4.pdf"
		Case "cor 2-3 eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\26 - " & Morceau & " - Cor Eb 2-3.pdf"
		Case "flute - picolo.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\01 - " & Morceau & " - Picolo-Flute.pdf"
		Case "grosse caisse et cymbale.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\36 - " & Morceau & " - Grosse Caisse-Cymbale.pdf"
		Case "trombone 2-3.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\30 - " & Morceau & " - Trombone 2-3.pdf"
		Case "clarinnette basse.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\11 - " & Morceau & " - Clarinnette Basse.pdf"
		Case "cor en fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor en fa principal.pdf"
		Case "picolo.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\01 - " & Morceau & " - Picolo 1.pdf"
		Case "Piccolo 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\01 - " & Morceau & " - Picolo 1.pdf"
		Case "Piccolo 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\01 - " & Morceau & " - Picolo 2.pdf"
		Case "flute 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\03 - " & Morceau & " - Flute 1.pdf"
		Case "flute 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\04 - " & Morceau & " - Flute 2.pdf"
		Case "euphonium.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\34 - " & Morceau & " - Euphonium.pdf"
		Case "xylophone.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\39 - " & Morceau & " - Xylophone.pdf"
		Case "cor fa 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor fa 1.pdf"
		Case "cor fa 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\26 - " & Morceau & " - Cor fa 2.pdf"
		Case "bombardino.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\34 - " & Morceau & " - Euphonium.pdf"
		Case "cymbale-g.caisse.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\36 - " & Morceau & " - Grosse Caisse-Cymbale.pdf"
		Case "trompe eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor Eb 1 principal.pdf"
		Case "tambourin.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\37 - " & Morceau & " - Tambourin.pdf"
		Case "tuba bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba.pdf"
		Case "conducteur.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\00 - " & Morceau & " - Conducteur.pdf"
		Case "baryton ut.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\32 - " & Morceau & " - Baryton Ut.pdf"
		Case "basson.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\12 - " & Morceau & " - Basson.pdf"
		Case "basson 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\12 - " & Morceau & " - Basson 1.pdf"
		Case "basson 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\12 - " & Morceau & " - Basson 2.pdf"
		Case "clarinette solo.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\07 - " & Morceau & " - Clarinette Principale.pdf"
		Case "cymbale.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\37 - " & Morceau & " - Cymbale.pdf"
		Case "hautbois 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\05 - " & Morceau & " - Hautbois 1.pdf"
		Case "hautbois 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\05 - " & Morceau & " - Hautbois 2.pdf"
		Case "basse eb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Eb.pdf"
		Case "basse eb 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Eb 1.pdf"
		Case "basse eb 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Basse-Souba Eb 2.pdf"
		Case "contrebasse ut.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\33 - " & Morceau & " - Contrebasse Ut.pdf"
		Case "saxo soprano.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\16 - " & Morceau & " - Saxo Soprano.pdf"
		Case "clarinette alto.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\99 - " & Morceau & " - Clarinette Alto.pdf"
		Case "clarinette basse.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\11 - " & Morceau & " - Clarinette Basse.pdf"
		Case "cor 1 fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\25 - " & Morceau & " - Cor fa 1.pdf"
		Case "cor 2 fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\26 - " & Morceau & " - Cor fa 2.pdf"
		Case "cor 3 fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\27 - " & Morceau & " - Cor fa 3.pdf"
		Case "cor 4 fa.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\28 - " & Morceau & " - Cor fa 4.pdf"
		Case "percussion 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\36 - " & Morceau & " - Percussion 1.pdf"
		Case "percussion 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\37 - " & Morceau & " - Percussion 2.pdf"
		Case "percussion 3.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\99 - " & Morceau & " - Percussion 3.pdf"
		Case "cornemuse.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\99 - " & Morceau & " - Cornemuse.pdf"
		Case "tenorhorn 1.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\99 - " & Morceau & " - TenorHorn 1.pdf"
		Case "tenorhorn 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\99 - " & Morceau & " - TenorHorn 2.pdf"
		Case "trombone 1 bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\29 - " & Morceau & " - Trombone 1 Bb.pdf"
		Case "trombone 1 bb 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\29 - " & Morceau & " - Trombone 1 Bb (clef fa).pdf"
		Case "trombone 2 bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\30 - " & Morceau & " - Trombone 2 Bb.pdf"
		Case "trombone 2 bb 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\30 - " & Morceau & " - Trombone 2 Bb (clef fa).pdf"
		Case "trombone 3 bb.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\31 - " & Morceau & " - Trombone 3 Bb.pdf"
		Case "trombone 3 bb 2.pdf"
			objFSO.MoveFile Rep & "\" & NOM_FICHIER_NORM, Rep & "\31 - " & Morceau & " - Trombone 3 Bb (clef fa).pdf"
	End Select
Next

MsgBox "Rennomage des partitions terminées terminé"

Case 2	'Progamme de renseignement de l'excel

'Recupération du model excel
Chemin_model_excel = path_Scr & "\Utilitaires\Page de garde vierge.xlsx"

'************** Recuperation du dossier à traiter *****************
'Création des objet et appel des fonction de browse
Set oShell = CreateObject("Shell.Application")
Set oFolder = oShell.BrowseForFolder(&H0&, "Choisir un répertoire", &H1, Path_dropbox)

'Test si un dossier est bien selectionner
If oFolder is Nothing Then 
	MsgBox "Abandon opérateur",vbCritical
	Wscript.quit
Else
  Set oFolderItem = oFolder.Self
End If

'Création de l'objet de gestion des fichier
Set Obj_Fichier = CreateObject("Scripting.FileSystemObject")

'Boucle de construction de la propriété liste des fichier
LISTE_FICHIER = ""
NBRE = 0
Obj_Liste = ""
NOM_99=""
Rep = oFolderItem.path
Morceau_NAME = oFolderItem
Morceau=LEN(Morceau_NAME)
For Each Obj_Liste In  Obj_Fichier.GetFolder(Rep).Files
	If LISTE_FICHIER <> "" Then
		LISTE_FICHIER = LISTE_FICHIER & ";" & Obj_Liste.Name
	Else
	LISTE_FICHIER = Obj_Liste.Name
	End If
	If Right(Obj_Liste.Name, 3) = "pdf" Then
		NBRE = NBRE + 1
	End If
	If Right(Obj_Liste.Name, 4) = "xlsx" Then
		NBRE = NBRE + 1
	End If	
	If Right(Obj_Liste.Name, 3) = "xls" Then
		NBRE = NBRE + 1
	End If	
	If Right(Obj_Liste.Name, 3) = "JPG" Then
		NBRE = NBRE + 1
	End If	
Next

'Renseignement des fichiers
TABL_FICHIER = Split(LISTE_FICHIER, ";")


'Renomage
Dim objExcel, objWorkbook, value
Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(Chemin_model_excel)
objExcel.Visible = false

For J=0 To (NBRE - 1)
If right(TABL_FICHIER(j), 3)="pdf" Then
	NOM_FICHIER_COMP=(TABL_FICHIER(j))
	NBRE_CARACT=Len(TABL_FICHIER(j))
	NOM_FICHIER = Left(TABL_FICHIER(j), 2)
	
	NBR_INST_PDF=NBRE_CARACT-8-Morceau
	INSTRUMENT_PDF=Right(NOM_FICHIER_COMP,NBR_INST_PDF)
	INSTRUMENT=Left(INSTRUMENT_PDF,(NBR_INST_PDF-4))
	
	Select Case NOM_FICHIER
	'Cells(Ligne,Colonne)
		Case 00
			objExcel.Cells(13, 4).Value = "x"
		Case 01
			objExcel.Cells(15, 2).Value = "x"
		Case 02
			objExcel.Cells(17, 2).Value = "x"
		Case 03
			objExcel.Cells(19, 2).Value = "x"
		Case 04
			objExcel.Cells(21, 2).Value = "x"
		Case 05
			objExcel.Cells(23, 2).Value = "x"
		Case 06
			objExcel.Cells(25, 2).Value = "x"
		Case 07
			objExcel.Cells(27, 2).Value = "x"
		Case 08
			objExcel.Cells(29, 2).Value = "x"
		Case 09
			objExcel.Cells(31, 2).Value = "x"
		Case 10
			objExcel.Cells(33, 2).Value = "x"
		Case 11
			objExcel.Cells(35, 2).Value = "x"
		Case 12
			objExcel.Cells(37, 2).Value = "x"
		Case 13
			objExcel.Cells(39, 2).Value = "x"
		Case 14
			objExcel.Cells(41, 2).Value = "x"
		Case 15
			objExcel.Cells(43, 2).Value = "x"
		Case 16
			objExcel.Cells(45, 2).Value = "x"
		Case 17
			objExcel.Cells(47, 2).Value = "x"
		Case 18
			objExcel.Cells(49, 2).Value = "x"
		Case 19
			objExcel.Cells(51, 2).Value = "x"
		Case 20
			objExcel.Cells(53, 2).Value = "x"
		Case 21
			objExcel.Cells(15, 6).Value = "x"
		Case 22
			objExcel.Cells(17, 6).Value = "x"
		Case 23
			objExcel.Cells(19, 6).Value = "x"
		Case 24
			objExcel.Cells(21, 6).Value = "x"
		Case 25
			objExcel.Cells(23, 6).Value = "x"
		Case 26
			objExcel.Cells(25, 6).Value = "x"
		Case 27
			objExcel.Cells(27, 6).Value = "x"
		Case 28
			objExcel.Cells(29, 6).Value = "x"
		Case 29
			objExcel.Cells(31, 6).Value = "x"
		Case 30
			objExcel.Cells(33, 6).Value = "x"
		Case 31
			objExcel.Cells(35, 6).Value = "x"
		Case 32
			objExcel.Cells(37, 6).Value = "x"
		Case 33
			objExcel.Cells(39, 6).Value = "x"
		Case 34
			objExcel.Cells(41, 6).Value = "x"
		Case 35
			objExcel.Cells(43, 6).Value = "x"
			objExcel.Cells(43, 7).Value = INSTRUMENT
		Case 36
			objExcel.Cells(45, 6).Value = "x"
			objExcel.Cells(45, 7).Value = INSTRUMENT
		Case 37
			objExcel.Cells(47, 6).Value = "x"
			objExcel.Cells(47, 7).Value = INSTRUMENT
		Case 38
			objExcel.Cells(49, 6).Value = "x"
			objExcel.Cells(49, 7).Value = INSTRUMENT
		Case 39
			objExcel.Cells(51, 6).Value = "x"
			objExcel.Cells(51, 7).Value = INSTRUMENT
		Case 40
			objExcel.Cells(52, 6).Value = "x"
			objExcel.Cells(52, 7).Value = INSTRUMENT
		Case 99
			If NOM_99 = "" then
			NOM_99 = INSTRUMENT
			Else
			NOM_99 = NOM_99 & vbCrLf & INSTRUMENT
			End if	
	End Select
End If
	
Next
objExcel.Cells(9, 2).Value = Morceau_NAME
objExcel.Cells(59, 5).Value = NOM_99

objWorkbook.SaveAs (Rep & "\@page_de_garde.xlsx")
objExcel.Quit

MsgBox "Renseignement Excel terminé"

Case 3	'Progamme de gestion fichier excel global
'Recupération du model excel
Chemin_model_excel = path_Scr & "\Utilitaires\Page de garde vierge.xlsx"

'Création des objet et appel des fonction de browse
Set oShell = CreateObject("Shell.Application")
Set oFolder = oShell.BrowseForFolder(&H0&, "Choisir un répertoire", &H1, Path_dropbox)

'Test si un dossier est bien selectionner
If oFolder is Nothing Then 
	MsgBox "Abandon opérateur",vbCritical
	Wscript.quit
Else
  Set oFolderItem = oFolder.Self
End If

'Construction de la liste des dossiers 
LISTE_DOSSIER = ""
Set oFSO2 = CreateObject("Scripting.FileSystemObject")
stRep2 = oFolderItem.path
If oFSO2.FolderExists(stRep2) Then
 For each oFld2 in  oFSO2.GetFolder(stRep2).SubFolders
   	If LISTE_DOSSIER <> "" Then
		LISTE_DOSSIER = LISTE_DOSSIER & ";" & oFld2
	Else
	LISTE_DOSSIER = oFld2
	End If
	NBRE_DOSSIER = NBRE_DOSSIER + 1
 Next
End If
'Renseignement des fichiers
TABL_DOSSIER = Split(LISTE_DOSSIER, ";")

'******************Traitement********************
For K=0 To (NBRE_DOSSIER - 1)

Chemin_dossier = TABL_DOSSIER(K)

TABL_NAME = Split(Chemin_dossier, "\")

nb = Len(Chemin_dossier) - Len(Replace(Chemin_dossier, "\", "" ))

'Création de l'objet de gestion des fichier
Set Obj_Fichier = CreateObject("Scripting.FileSystemObject")

'Boucle de construction de la propriété liste des fichier
LISTE_FICHIER = ""
NBRE = 0
Obj_Liste = ""
NOM_99=""
Rep = Chemin_dossier
Morceau_NAME = TABL_NAME(nb)
Morceau=LEN(Morceau_NAME)
For Each Obj_Liste In  Obj_Fichier.GetFolder(Rep).Files
	If LISTE_FICHIER <> "" Then
		LISTE_FICHIER = LISTE_FICHIER & ";" & Obj_Liste.Name
	Else
	LISTE_FICHIER = Obj_Liste.Name
	End If
	If Right(Obj_Liste.Name, 3) = "pdf" Then
		NBRE = NBRE + 1
	End If
	If Right(Obj_Liste.Name, 4) = "xlsx" Then
		NBRE = NBRE + 1
	End If	
	If Right(Obj_Liste.Name, 3) = "xls" Then
		NBRE = NBRE + 1
	End If	
	If Right(Obj_Liste.Name, 3) = "JPG" Then
		NBRE = NBRE + 1
	End If	
Next

'Renseignement des fichiers
TABL_FICHIER = Split(LISTE_FICHIER, ";")


'Renomage
Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(Chemin_model_excel)
objExcel.Visible = false

For J=0 To (NBRE - 1)
If right(TABL_FICHIER(j), 3)="pdf" Then
	NOM_FICHIER_COMP=(TABL_FICHIER(j))
	NBRE_CARACT=Len(TABL_FICHIER(j))
	NOM_FICHIER = Left(TABL_FICHIER(j), 2)
	
	NBR_INST_PDF=NBRE_CARACT-8-Morceau
	INSTRUMENT_PDF=Right(NOM_FICHIER_COMP,NBR_INST_PDF)
	INSTRUMENT=Left(INSTRUMENT_PDF,(NBR_INST_PDF-4))
	
	Select Case NOM_FICHIER
	'Cells(Ligne,Colonne)
		Case 00
			objExcel.Cells(13, 4).Value = "x"
		Case 01
			objExcel.Cells(15, 2).Value = "x"
		Case 02
			objExcel.Cells(17, 2).Value = "x"
		Case 03
			objExcel.Cells(19, 2).Value = "x"
		Case 04
			objExcel.Cells(21, 2).Value = "x"
		Case 05
			objExcel.Cells(23, 2).Value = "x"
		Case 06
			objExcel.Cells(25, 2).Value = "x"
		Case 07
			objExcel.Cells(27, 2).Value = "x"
		Case 08
			objExcel.Cells(29, 2).Value = "x"
		Case 09
			objExcel.Cells(31, 2).Value = "x"
		Case 10
			objExcel.Cells(33, 2).Value = "x"
		Case 11
			objExcel.Cells(35, 2).Value = "x"
		Case 12
			objExcel.Cells(37, 2).Value = "x"
		Case 13
			objExcel.Cells(39, 2).Value = "x"
		Case 14
			objExcel.Cells(41, 2).Value = "x"
		Case 15
			objExcel.Cells(43, 2).Value = "x"
		Case 16
			objExcel.Cells(45, 2).Value = "x"
		Case 17
			objExcel.Cells(47, 2).Value = "x"
		Case 18
			objExcel.Cells(49, 2).Value = "x"
		Case 19
			objExcel.Cells(51, 2).Value = "x"
		Case 20
			objExcel.Cells(53, 2).Value = "x"
		Case 21
			objExcel.Cells(15, 6).Value = "x"
		Case 22
			objExcel.Cells(17, 6).Value = "x"
		Case 23
			objExcel.Cells(19, 6).Value = "x"
		Case 24
			objExcel.Cells(21, 6).Value = "x"
		Case 25
			objExcel.Cells(23, 6).Value = "x"
		Case 26
			objExcel.Cells(25, 6).Value = "x"
		Case 27
			objExcel.Cells(27, 6).Value = "x"
		Case 28
			objExcel.Cells(29, 6).Value = "x"
		Case 29
			objExcel.Cells(31, 6).Value = "x"
		Case 30
			objExcel.Cells(33, 6).Value = "x"
		Case 31
			objExcel.Cells(35, 6).Value = "x"
		Case 32
			objExcel.Cells(37, 6).Value = "x"
		Case 33
			objExcel.Cells(39, 6).Value = "x"
		Case 34
			objExcel.Cells(41, 6).Value = "x"
		Case 35
			objExcel.Cells(43, 6).Value = "x"
			objExcel.Cells(43, 7).Value = INSTRUMENT
		Case 36
			objExcel.Cells(45, 6).Value = "x"
			objExcel.Cells(45, 7).Value = INSTRUMENT
		Case 37
			objExcel.Cells(47, 6).Value = "x"
			objExcel.Cells(47, 7).Value = INSTRUMENT
		Case 38
			objExcel.Cells(49, 6).Value = "x"
			objExcel.Cells(49, 7).Value = INSTRUMENT
		Case 39
			objExcel.Cells(51, 6).Value = "x"
			objExcel.Cells(51, 7).Value = INSTRUMENT
		Case 40
			objExcel.Cells(52, 6).Value = "x"
			objExcel.Cells(52, 7).Value = INSTRUMENT
		Case 99
			If NOM_99 = "" then
			NOM_99 = INSTRUMENT
			Else
			NOM_99 = NOM_99 & vbCrLf & INSTRUMENT
			End if	
	End Select
End If
	
Next
objExcel.Cells(9, 2).Value = Morceau_NAME
objExcel.Cells(59, 5).Value = NOM_99

objWorkbook.SaveAs (Rep & "\@page_de_garde.xlsx")
objExcel.Quit
Next

MsgBox "Renseignement Excel terminé"
Wscript.Quit

Case 4
'Choix de l'instrument à générer
Num_Instrument = InputBox("Choisir l'instrument à générer." & vbCrLf & vbCrLf & "01-Picolo 1"& vbCrLf &"02-Picolo 2" & vbCrLf & "03-Flute 1"& vbCrLf &"04-Flute 2" & vbCrLf & "05-Haubois" & vbCrLf & "06-Clarinette Eb" & vbCrLf & "07-Clarinette Principale"& vbCrLf &"08-Clarinette Bb 1"& vbCrLf &"09-Clarinette Bb 2"& vbCrLf &"10-Clarinette Bb 3" & vbCrLf & "11-Clarinette Basse" & vbCrLf & "12-Basson" & vbCrLf & "13-Bugle 1"& vbCrLf &"14-Bugle 2"& vbCrLf &"15-Bugle 3" & vbCrLf & "16-Saxo Soprano" & vbCrLf & "17-Saxo Alto 1"& vbCrLf &"18-Saxo Alto 2" & vbCrLf & "19-Saxo Ténor" & vbCrLf & "20-Saxo Baryton" & vbCrLf & "21-Saxo Basse" & vbCrLf & "22-Trompette 1"& vbCrLf &"23-Trompette 2"& vbCrLf &"24-Trompette 3" & vbCrLf & "25-Cor 1"& vbCrLf &"26-Cor 2"& vbCrLf &"27-Cor 3"& vbCrLf &"28-Cor 4" & vbCrLf & "29-Trombone 1"& vbCrLf &"30-Trombone 2"& vbCrLf &"31-Trombone 3" & vbCrLf & "32-Baryton" & vbCrLf & "33- Basse-Souba" & vbCrLf & "34-Euphonium" & vbCrLf & "35-Batterie/Caisse Claire"& vbCrLf &"36-Percussion 1"& vbCrLf &"37-Percussion 2"& vbCrLf &"38-Timbales" & vbCrLf & "39-Xylophone", "Banda Esperanza - Tyrosse" , "")

'Extraction du nom du l'instrument
Select Case Num_Instrument
Case 01
Instrument = "Picolo 1"
Case 02
Instrument = "Picolo 2"
Case 03
Instrument = "Flute 1"
Case 04
Instrument = "Flute 2"
Case 05
Instrument = "Haubois"
Case 06
Instrument = "Clarinette Eb"
Case 07
Instrument = "Clarinette Principale"
Case 08
Instrument = "Clarinette Bb 1"
Case 09
Instrument = "Clarinette Bb 2"
Case 10
Instrument = "Clarinette Bb 3"
Case 11
Instrument = "Clarinette Basse"
Case 12
Instrument = "Basson"
Case 13
Instrument = "Bugle 1"
Case 14
Instrument = "Bugle 2"
Case 15
Instrument = "Bugle 3"
Case 16
Instrument = "Saxo Soprano"
Case 17
Instrument = "Saxo Alto 1"
Case 18
Instrument = "Saxo Alto 2"
Case 19
Instrument = "Saxo Ténor"
Case 20
Instrument = "Saxo Baryton"
Case 21
Instrument = "Saxo Basse"
Case 22
Instrument = "Trompette 1"
Case 23
Instrument = "Trompette 2"
Case 24
Instrument = "Trompette 3"
Case 25
Instrument = "Cor 1"
Case 26
Instrument = "Cor 2"
Case 27
Instrument = "Cor 3"
Case 28
Instrument = "Cor 4"
Case 29
Instrument = "Trombone 1"
Case 30
Instrument = "Trombone 2"
Case 31
Instrument = "Trombone 3"
Case 32
Instrument = "Baryton"
Case 33
Instrument = "Basse-Souba"
Case 34
Instrument = "Euphonium"
Case 35
Instrument = "Batterie/Caisse Claire"
Case 36
Instrument = "Percussion 1"
Case 37
Instrument = "Percussion 2"
Case 38
Instrument = "Timbales"
Case 39
Instrument = "Xylophone"
End select

'************************************************************************************
'Création des objet et appel des fonction de browse
REP_PARTITION = Path_dropbox & "\Partitions"

'Construction de la liste des dossiers 
LISTE_DOSSIER = ""
Set oFSO3 = CreateObject("Scripting.FileSystemObject")
stRep3 = REP_PARTITION
If oFSO3.FolderExists(stRep3) Then
 For each oFld3 in  oFSO3.GetFolder(stRep3).SubFolders
   	If LISTE_DOSSIER <> "" Then
		LISTE_DOSSIER = LISTE_DOSSIER & ";" & oFld3
	Else
	LISTE_DOSSIER = oFld3
	End If
	NBRE_DOSSIER = NBRE_DOSSIER + 1
Next
End If

'Renseignement des fichiers
TABL_DOSSIER = Split(LISTE_DOSSIER, ";")

'******************Traitement********************
For K=0 To (NBRE_DOSSIER - 1)

'Selection d'un dossier et nom morceau
Rep = TABL_DOSSIER(K)
TABL_NAME = Split(Rep, "\")
nb = Len(Rep) - Len(Replace(Rep, "\", "" ))
Morceau_NAME = TABL_NAME(nb)

'Création de l'objet de gestion des fichier
Set Obj_Fichier = CreateObject("Scripting.FileSystemObject")

'Boucle de construction de la propriété liste des fichier
LISTE_FICHIER = ""
NBRE = 0
Obj_Liste = ""
Morceau=LEN(Morceau_NAME)
For Each Obj_Liste In  Obj_Fichier.GetFolder(Rep).Files
	If LISTE_FICHIER <> "" Then
		LISTE_FICHIER = LISTE_FICHIER & ";" & Obj_Liste.Name
	Else
	LISTE_FICHIER = Obj_Liste.Name
	End If
	If Right(Obj_Liste.Name, 3) = "pdf" Then
		NBRE = NBRE + 1
	End If
	If Right(Obj_Liste.Name, 4) = "xlsx" Then
		NBRE = NBRE + 1
	End If	
	If Right(Obj_Liste.Name, 3) = "xls" Then
		NBRE = NBRE + 1
	End If	
	If Right(Obj_Liste.Name, 3) = "JPG" Then
		NBRE = NBRE + 1
	End If	
Next

'Renseignement des fichiers
TABL_FICHIER = Split(LISTE_FICHIER, ";")

Partition_Trouve = ""
For J=0 To (NBRE - 1)
	If right(TABL_FICHIER(j), 3)="pdf" Then
		NOM_FICHIER_COMP=(TABL_FICHIER(j))
		NBRE_CARACT=Len(TABL_FICHIER(j))
		NOM_FICHIER = Left(TABL_FICHIER(j), 2)

		If NOM_FICHIER=Num_Instrument Then
			Partition_Trouve = "Oui"
		End If
		If Num_Instrument=01 Then
			If NOM_FICHIER="03" Then
				Partition_Trouve = "Oui"
			End If
		End If
		If Num_Instrument=03 Then
			If NOM_FICHIER="01" Then
				Partition_Trouve = "Oui"
			End If
		End If
	End If
	
Next

If Partition_Trouve = "" Then
	If Parti_manquante = "" Then
		Parti_manquante = Morceau_NAME
	Else
		Parti_manquante = Parti_manquante & vbCrLf & Morceau_NAME
	End If
End If

next

'Création d'un word et renseignement
Set objWord = CreateObject("Word.Application")
objWord.Visible = False
Set objDoc = objWord.Documents.Add()

objWord.Selection.Text = "Génération Automatique des partitions manquantes pour l'instrument: " & vbCrLf & Instrument & vbCrLf& vbCrLf & Parti_manquante
objWord.Selection.ParagraphFormat.Alignment = 1
objWord.Selection.ParagraphFormat.SpaceAfter = 0
objWord.Selection.ParagraphFormat.SpaceBefore = 0
objWord.Visible = True
Wscript.Quit

End Select

Fin = MsgBox ("Désirez vous faire une autre partition?",vbYesNo)
loop
