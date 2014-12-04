%code mixe une musique et renvoit un fichier wave
%Auteurs : Timothee Malengreau NOMA : 6618-13-00
%          Charlotte Poncette NOMA : 9458-12-00

local Mix Interprete Projet CWD in

   %CWD = {Property.condGet 'testcwd' '/home/tim/projet-info-2014/'}
   CWD = {Property.condGet 'testcwd' 'C:\\Users\\Charlotte\\Documents\\UCL\\Q3\\Informatique\\projet-info-2014\\'}

   [Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}

   local Lire Final  ToAudio Merge Renverser RepetitionN RepetitionD Clip Echo Fondu FonduEnchaine Longueur Coupe Transpose Bourdon Muet ToEchantillon TempsTotal ToNote Duree Etirer in

      %Entrée : une partition (Partition) et un accumulateur (TempsTot) qu'on doit initialiser à 0.0
      %Sortie : la durée totale de la partition en secondes.
      fun {TempsTotal Partition TempsTot}
	 case Partition
	 of nil then TempsTot 
	 [] H|T then case H
		     of  echantillon(hauteur:H duree:D instrument:none)
		     then {TempsTotal T TempsTot+D}
		     else {TempsTotal T TempsTot}
		     end
	 end
      end
      
      %Entree : une note étendue (Note) de la forme note(nom:<nom> octave:<octave> alteration:<alteration>)
      %Sortie : un echantillon de la forme  echantillon(hauteur:<hauteur> duree:<duree> instrument:none)
      %la durée étant en secondes et la hauteur étant la différence de demitons entre la note en entrée et a4, le la de référence d'une fréquence de 440Hz.
      fun {ToEchantillon Note}
	 local Nom C Hauteur H1 H2 in
	    if Note == 'silence' then silence(duree:1.0)
	    else
	       Nom = Note.nom
	       if Nom == 'a' then H1 = 0
	       elseif Nom == 'b' then H1 = 2
	       elseif Nom == 'c' then H1 = ~9
	       elseif Nom == 'd' then H1 = ~7
	       elseif Nom == 'e' then H1 = ~5
	       elseif Nom == 'f' then H1 = ~4
	       elseif Nom == 'g' then H1 = ~2
	       end
	       C = Note.octave
	       H2 = H1 + (((C-4)*12))
	       if Note.alteration == '#' then Hauteur = H2 + 1
	       else Hauteur = H2
	       end
	       echantillon(hauteur:Hauteur duree:1.0 instrument:none)	  
	    end
	 end
      end

      %Entree : une partition et la duree voulue pour cette partition
      %Sortie : une partition qui dure la duree totale voulue d'entrée
      fun {Duree DureeTotaleVoulue Partition}
	 local DureeActuelle in
	    DureeActuelle = {TempsTotal Partition 0.0}
	    {Etirer DureeTotaleVoulue/DureeActuelle Partition}
	 end
      end

      %Entree : une partition et le facteur avec lequel nous voulons étirer cette partition
      %Sortie : une partition dont la duree a ete multipliee par le facteur d'entree
      fun {Etirer Facteur Partition}
	 case Partition of nil then nil
	 [] H|T then echantillon(hauteur:H.hauteur duree:H.duree*Facteur instrument:H.instrument)|{Etirer Facteur T}
	 [] H then echantillon(hauteur:H.hauteur duree:H.duree*Facteur instrument:H.instrument)%|nil
	 end
      end

      %Entree : une partition
      %Sortie : une liste d'echantillons
      fun {ToNote Partition}
	 case Partition
	 of nil then nil
	 [] H|T then case H
		     of 'silence' then {ToEchantillon 'silence'}|{ToNote T}
		     [] Nom#Octave then {ToEchantillon note(nom:Nom octave:Octave alteration:'#')}|{ToNote T}
		     [] Atom then
			case {AtomToString Atom}
			of [N] then {ToEchantillon note(nom:Atom octave:4 alteration:none)}|{ToNote T}
			[] [N O] then {ToEchantillon note(nom:{StringToAtom[N]} octave:{StringToInt[O]} alteration:none)}|{ToNote T}
			end
		     else  H|{ToNote T}
		     end
	 [] H
	 then case H
	      of 'silence' then {ToEchantillon 'silence'}
	      [] Nom#Octave then {ToEchantillon note(nom:Nom octave:Octave alteration:'#')}
	      [] Atom then
		 case {AtomToString Atom}
		 of [N] then {ToEchantillon note(nom:Atom octave:4 alteration:none)}
		 [] [N O] then {ToEchantillon note(nom:{StringToAtom[N]} octave:{StringToInt[O]} alteration:none)}
		 end
	      end
	 end
      end

      %Entree : une musique
      %Sortie : un vecteur audio
      %La musique en entree est decortiquee et chaque element est traite en fonction de sa nature (partition, wave, filtres, etc.)
% A PRIORI QUOIQUE      
      fun {Final M}
	 case M
	 of nil then nil
	 [] H|T then case H
		     of voix(Voix) then Voix|{Final T}
			
		     [] partition(Partition) then
			{ToAudio {Interprete Partition}}|{Final T}
			
		     [] wave(Fichier) then
			{Projet.readFile CWD#Fichier}|{Final T}
			
		     [] renverser(Musique) then
			{Renverser {Mix Interprete Musique}}|{Final T}
			
		     [] repetition(nombre:N Musique) then
			{RepetitionN N {Mix Interprete Musique}}|{Final T}
			
		     [] repetition(duree:S Musique) then
			{RepetitionD S {Mix Interprete Musique}}|{Final T}
			
		     [] clip(bas:Bas haut:Haut Musique) then
			{Clip Bas Haut {Mix Interprete Musique}}|{Final T}
			
		     [] echo(delai:S Musique) then
			{Echo S 1.0 1.0 {Mix Interprete Musique}}|{Final T}
			
		     [] echo(delai:S decadence:D Musique) then
			{Echo S D 1 {Mix Interprete Musique}}|{Final T}
			
		     [] echo(delai:S decadence:D repetition:R Musique) then
			{Echo S D R {Mix Interprete Musique}}|{Final T}
			
		     [] fondu(ouverture:Ouv fermeture:Ferm Musique) then
			{Fondu Ouv Ferm {Mix Interprete Musique}}|{Final T}
			
		     [] fondu_enchaine(duree:S Musique1 Musique2) then
			{FonduEnchaine S {Mix Interprete Musique1} {Mix Interprete Musique2}}|{Final T}
			
		     [] couper(debut:Debut fin:Fin Musique) then
			{Coupe Debut Fin {Mix Interprete Musique}}|{Final T}
			
		     [] merge(MusiquesAvecIntensites) then
			{Merge MusiquesAvecIntensites}|{Final T}
		     [] H then if H < ~1.0 then if H > 1.0 then H|{Final T}
						end
			       end
		     end
	 [] K then case K
		   of voix(Voix) then Voix

		   [] partition(Partition) then
		      {ToAudio {Interprete Partition}}

		   [] wave(Fichier) then
		      {Projet.readFile CWD#Fichier}
			 
		   [] renverser(Musique) then
		      {Renverser {Mix Interprete Musique}}
			
		   [] repetition(nombre:N Musique) then
		      {RepetitionN N {Mix Interprete Musique}}
			 
		   [] repetition(duree:S Musique) then
		      {RepetitionD S {Mix Interprete Musique}}
			 
		   [] clip(bas:Bas haut:Haut Musique) then
		      {Clip Bas Haut {Mix Interprete Musique}}
			 
		   [] echo(delai:S Musique) then
		      {Echo S 1.0 1.0 {Mix Interprete Musique}}
			
		   [] echo(delai:S decadence:D Musique) then
		      {Echo S D 1 {Mix Interprete Musique}}
			
		   [] echo(delai:S decadence:D repetition:R Musique) then
		      {Echo S D R {Mix Interprete Musique}}
			
		   [] fondu(ouverture:Ouv fermeture:Ferm Musique) then
		      {Fondu Ouv Ferm {Mix Interprete Musique}}
			
		   [] fondu_enchaine(duree:S Musique1 Musique2) then
		      {FonduEnchaine S {Mix Interprete Musique1} {Mix Interprete Musique2}}

		   [] couper(debut:Debut fin:Fin Musique) then
		      {Coupe Debut Fin {Mix Interprete Musique}}
			
		   [] merge(MusiquesAvecIntensites) then
		      {Merge MusiquesAvecIntensites}
		      
		   [] K then if K < ~1.0 then if K > 1.0 then K
						end
			     end
		   end
	 end
      end

      %Entree : une liste d'echantillons
      %Sortie : une liste de vecteurs audio
      %les vecteurs audio sont calcules en fonction de la hauteur, donc de la frequence, des echantillons.
      fun {ToAudio ListeEchantillons}
	 local ToAudioAux NbAiS  NbAiTot in %ListeEchantillons in
	    fun {ToAudioAux Hauteur N I}
	       if {IntToFloat I} == 0.0 then nil
	       else
		  case Hauteur
		  of 'silence' then 0.0|{ToAudioAux 'silence' N I-1}
		  [] H then local F Ai in
			       F = {Number.pow 2.0 ({IntToFloat H}/12.0)} * 440.0
			       Ai = 0.5*{Sin (2.0*3.14159265359*F*({IntToFloat N}))/44100.0}
			       Ai|{ToAudioAux H N+1 I-1}
			    end
		  end
	       end
	    end
	    
	    NbAiS = 44100.0
	    
	    %ListeEchantillons = {Flatten ListeEchantillons1}
	    
	    case ListeEchantillons
	    of nil then nil
	    [] H|T then case H
			of silence(duree:S) then
			   NbAiTot = {FloatToInt NbAiS*S}
			   {ToAudioAux 'silence' 1 NbAiTot}|{ToAudio T}
			[] echantillon(hauteur:H duree:S instrument:none) then
			   NbAiTot = {FloatToInt NbAiS*S}
			   {ToAudioAux H 1 NbAiTot}|{ToAudio T}
			else if H > ~1.0 then if H < 1.0 then H|{ToAudio T}
					      end
			     end
			end
	    [] K then case K
		      of silence(duree:S) then
			 NbAiTot = {FloatToInt NbAiS*S}
			 {ToAudioAux 'silence' 1 NbAiTot}
		      [] echantillon(hauteur:H duree:S instrument:none) then
			 NbAiTot = {FloatToInt NbAiS*S}
			 {ToAudioAux H 1 NbAiTot}
		      else if K > ~1.0 then if K < 1.0 then K
					    end
			   end
		      end
	    
	    end
	 end     
      end

      %Entree : L, une liste de musiques intensifiees
      %Sortie : une liste de vecteurs audios traduisant les musiques jouees simultanement, chacune avec une intensite determinee (la somme des intensites ne depasse jamais 1)
      fun {Merge L}
	 local Itot IntensiteTotale IntensifierMusic IntensifierList AdditionList Somme in

	    %Entree : L, une liste de musiques intensifiees
	    %Sortie : la somme des intensites
	    fun {IntensiteTotale L Acc}
	       case L of nil then Acc
	       [] H|T then case H of I#M then {IntensiteTotale T Acc+I} %Erreur : Variable M utilisee qu'une seule fois : c'est normal, on additionne les intensites
			   end
	       end
	    end

	    %Entree : I l'intensite a donner a la musique M
	    %Sortie : un vecteur audio de la musique intensifiee
	    fun {IntensifierMusic I M}
	       case M of nil then nil
		  [] H|T then (I*H)|{IntensifierMusic I T}
		  end
	    end

	    %Entree : L, une liste de musique à intensifier
	    %Sortie : une liste de musiques intensifiees
	    fun {IntensifierList L}
	       case L of nil then nil
	       [] H|T then case H of I#M then {IntensifierMusic (I/Itot) {Mix Interprete M}}|{IntensifierList T}
			   end
	       end
	    end

	    %Entree : L1, L2 deux listes a additionner element par element
	    %Sortie : une liste contenant l'addition des elements un a un des deux listes d'entree
	    fun {AdditionList L1 L2}
	       case L1
	       of nil then case L2
			   of nil then nil
			   else L2
			   end
	       [] H1|T1 then case L2
			     of nil then L1
			     [] H2|T2 then (H1+H2)|{AdditionList T1 T2}
			     end
	       end
	    end
	    
	    %Entree : L, une liste de listes dont on veut la somme
	    %Sortie : une liste dont toutes les listes ete additionnees suivant AdditionList
	    fun {Somme L}
	       case L of H|nil then H|nil
	       [] H1|H2|T then {Somme ({AdditionList H1 H2}|T)}
	       end 
	    end
	    
	    Itot = {IntensiteTotale L 0.0}
	    {Browse {Flatten {Somme {IntensifierList L}}}}
	    {Flatten {Somme {IntensifierList L}}}
	    
	 end
      end
      
      %Entree : L, la liste à inverser
      %Sortie : la liste L inversée    
      fun {Renverser L}
	 
	 local RenverserAux in
	    
	    fun {RenverserAux L Acc}
	       case L
	       of nil then Acc
	       [] H|T then {RenverserAux T H|Acc}
	       end  
	    end
	    
	    {RenverserAux L nil}
	 end
	 
      end
      
      %Entree : NbRep, le nombre de fois qu'on veut repeter la musique M
      %Sortie : la musique repetee le nombre de fois voulu
      fun {RepetitionN NbRep M}
	 if NbRep==0 then M
	 else {Append M {RepetitionN NbRep-1  M}}
	 end	    
      end
      
      %Entree : Duree, le temps (en secondes) durant lequel on veut repeter la musique M
      %Sortie : la musique repetee durant Duree
      fun {RepetitionD Duree M}
	 local NbRep M1 M2 Ttot in
	    Ttot = {IntToFloat {Longueur M 0}}
	    NbRep = {FloatToInt Duree*44100.0/Ttot}
	    M1 = {RepetitionN NbRep-1 M}
	    M2 = {Coupe 0.0 Duree-(Ttot*{IntToFloat NbRep}/44100.0) M}
	    
	    {Append M1 M2}
	 end
      end

      %Entree : un vecteur audio dont on veut faire l'echo apres un certain delai, un certain nombre de fois (Repetition) selon une certaine decadence
      %Sortie : le vecteur audio voulu
% ?
      fun {Echo Delai Decadence Repetition Audio}
	 local EquIntensite I EchoAux in
	    fun {EquIntensite Dec Rep}
	       if Rep == 0 then 1.0
	       else {Pow Dec {IntToFloat Rep}}+{EquIntensite Dec Rep-1}
	       end
	    end

	    I = 1.0/{EquIntensite Decadence Repetition}

	    fun {EchoAux Del Dec Rep M Acc} 
	       if Acc==Rep then nil
	       else {Pow I {IntToFloat (Acc+1)}}#[partition(silence(duree:Del*{IntToFloat Acc})) M]|{EchoAux Del Dec Rep M Acc+1}
	       end
	    end

	    {EchoAux Delai Decadence Repetition Audio 0}

	 end
      end

      %Entree : un vecteur audio qu'on veut plafonner selon bas et haut
      %Sortie : le vecteur audio plafonne
      fun {Clip Bas Haut Audio}
	 case Audio
	 of nil then nil
	 [] H|T then if H < Bas then Bas|{Clip Bas Haut T}
		     elseif H > Haut then Haut|{Clip Bas Haut T}
		     else H|{Clip Bas Haut T}
		     end
	 [] K then if K < Bas then Bas
		   elseif K > Haut then Haut
		   else K
		   end
	 end	    
      end

      %Entree : un vecteur audio, la duree de l'ouverture et de la fermeture
      %Sortie : le vecteur audio fondu
      %l'intensite du vecteur audio va augmenter lineairement pendant l'ouverture et diminuer lineairement durant la fermeture
      fun {Fondu Ouverture Fermeture Audio}
	 local FonduAux LAudio in
	    LAudio = {IntToFloat {Longueur Audio 0}}
	    
	    fun {FonduAux Audio Duree Acc}
	       if Acc > Duree then nil
	       else case Audio
		    of nil then nil
		    [] H|T then {Append ((H*Acc)/Duree)|{FonduAux T Duree Acc+1.0} {Coupe Ouverture LAudio/44100.0 Audio}}
		    [] H then {Append (H*Acc)/Duree {Coupe Ouverture LAudio/44100.0 Audio}}
		    end
	       end
	    end
	    
	    if Ouverture > 0.0 then if Fermeture > 0.0 then
				       {Renverser {FonduAux {Renverser {FonduAux Audio Ouverture*44100.0 1.0}} Fermeture*44100.0 1.0}}
				    end
	       
	    elseif Ouverture > 0.0 then if LAudio > (44100.0*Ouverture) then
					   {FonduAux Audio Ouverture*44100.0 1.0}
					end
	       
	    elseif Fermeture > 0.0 then if LAudio > (44100.0*Fermeture) then
					   {Renverser {FonduAux {Renverser Audio} Fermeture*44100.0 1.0}}
					end
	    end
	 end
      end

      %Entree : deux fichiers audio qu'on enchaine avec un fondu
      %Sortie : le vecteur audio transforme
% ? 
      fun {FonduEnchaine Duree Audio1 Audio2}
	 {Merge ([0.5#{Fondu Duree 0.0 Audio1} 0.5#{Fondu 0.0 Duree [voix([silence(({Longueur Audio1 0}/44100.0)-Duree)]) Audio2]}])}
      end

      %Entree : une liste et un accumulateur a zero
      %Sortie : la longueur de la liste
      fun {Longueur List Acc}
	 case List of nil then Acc
	 else {Longueur List.2 Acc+1}
	 end
      end

      %Entree : un fichier audio qu'on veut couper entre debut et fin
      %Sortie : le fichier coupé
      fun {Coupe Debut Fin Audio}
	 local Inter CoupeAux in

	    fun {CoupeAux D F Audio}
	       if F == 0.0 then nil
	       elseif D == 0.0 then Audio.1|{CoupeAux 0.0 F-1.0 Audio.2}
	       else {CoupeAux D-1.0 F-1.0 Audio.2}   
	       end
	    end
	    
	    Inter = Fin - Debut
	    if Inter < 0.0 then {Coupe Fin Debut Audio}
	       
	    elseif Debut < 0.0 then if Fin < 0.0
				    then {ToAudio {Etirer Inter {ToNote 'silence'}}} end
	       
	    elseif Debut < 0.0 then if Fin > 0.0
				    then {ToAudio {Etirer ~Debut {ToNote 'silence'}}}|{CoupeAux 0.0 Fin*44100.0 Audio} end
	       
	    else {CoupeAux Debut*44100.0 Fin*44100.0 Audio}
	    end
	 end
      end

      %Entree : une partition et un nombre de demitons
      %Sortie : la partition transposee du nombre de demitons
      fun {Transpose NbreDemiTons Partition}
	 case Partition
	 of nil then nil
	 [] H|T then echantillon(hauteur:H.hauteur+NbreDemiTons duree:H.duree instrument:H.instrument)|{Transpose NbreDemiTons T}
	 end
      end

      %Entree : une partition et une note
      %Sortie : une partition dont toutes les notes ont ete remplacees par la note d'entree
      fun {Bourdon Note Partition}
	 if Partition == nil then nil
	 else
	    ({ToNote Note})|{Bourdon Note Partition.2}
	 end
      end

      %Entree : une partition
      %Sortie : une partition dont toutes les notes ont ete remplacees par un silence
      fun {Muet Partition}
	 {Bourdon 'silence' Partition}
      end

      %Entree : une partition
      %Sortie : une liste d'echantillons
      fun {Lire Partition}
	 case Partition
	 of nil then nil
	 [] H|T then case H
		     of muet(Part) then {Muet {Interprete Part}}|{Lire T}
			   
		     [] duree(secondes:S Part) then {Duree S {Interprete Part}}|{Lire T}
			   
		     [] etirer(facteur:F Part) then {Etirer F {Interprete Part}}|{Lire T}
			   
		     [] bourdon(note:N Part) then {Bourdon N {Interprete Part}}|{Lire T}
			   
		     [] transpose(demitons:E Part) then {Transpose E {Interprete Part}}|{Lire T}
			   
		     else {ToNote H}|{Lire T}  
		     end
	       
	 [] H then case H
		   of muet(Part) then {Muet {Interprete Part}}
			 
		   [] duree(secondes:S Part) then {Duree S {Interprete Part}}
			 
		   [] etirer(facteur:F Part) then {Etirer F {Interprete Part}}
			 
		   [] bourdon(note:N Part) then {Bourdon N {Interprete Part}}
			 
		   [] transpose(demitons:E Part) then {Transpose E {Interprete Part}}
			 
		   else {ToNote H}
		   end
	 end
      end

      %Entree : une partition
      %Sortie : une liste d'echantillons
      fun {Interprete Partition}
	 local P in
	    P = {Flatten Partition}
	    {Flatten {Lire P}}
	 end
      end

      %Entree : une musique et une fonction interprete
      %Sortie : une liste de vecteurs audio
      fun {Mix Interprete Music}
	 local M in
	    M = {Flatten Music}
	    {Flatten {Final M}}	    
	 end
      end
   end
   
   local 
      Music = {Projet.load CWD#'blabalba.oz'}
   in
      {Browse {Projet.run Mix Interprete Music CWD#'out.wav'}}
   end
end