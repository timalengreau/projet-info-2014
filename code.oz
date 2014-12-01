local Mix Interprete Projet CWD in
   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre √† votre systeme.
   CWD = {Property.condGet 'testcwd' '/home/tim/projet-info-2014/'}

   % Projet fournit quatre fonctions :
   % {Projet.run Interprete Mix Music 'out.wav'} = ok OR error(...) 
   % {Projet.readFile FileName} = audioVector(AudioVector) OR error(...)
   % {Projet.writeFile FileName AudioVector} = ok OR error(...)
   % {Projet.load 'music_file.oz'} = Oz structure.
   %
   % et une constante :
   % Projet.hz = 44100, la frequence d'echantilonnage (nombre de donnees par seconde)
   [Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}

   %local
   %   Audio = {Projet.readFile CWD#'wave/animaux/cow.wav'}
   %in
   local ToEchantillon TempsTotal ToNote Duree Etirer in
      
      fun {TempsTotal Partition TempsTotal}
	 case Partition.1 of note(hauteur:h duree:d instrument:none)
	 then {TempsTotal Partition.2 TempsTotal+Partition.1.note}
	 [] nil then TempsTotal
	 else {TempsTotal Partition.2 TempsTotal}
	 end
      end
      
      fun {ToEchantillon Note}
	 local Nom C Hauteur in
	    Nom = Note.nom
	    if Note == 'silence' then silence(duree:1)
	    else
	       if Nom == 'a' then Hauteur = 0
	       elseif Nom == 'b' then Hauteur = 2
	       elseif Nom == 'c' then Hauteur = 3
	       elseif Nom == 'd' then Hauteur = 5
	       elseif Nom == 'e' then Hauteur = 7
	       elseif Nom == 'f' then Hauteur = 8
	       elseif Nom == 'g' then Hauteur = 10
	       end
	       C = Note.octave
	       Hauteur = Hauteur + (((C-4)*12))
	       if Note.alteration == '#' then Hauteur = Hauteur + 1
	       end
	       echantillon(hauteur:Hauteur duree:1 instrument:none)	  
	    end
	 end
      end
      
      fun {Duree DureeTotaleVoulue Partition}
	 local DureeActuelle in
	    DureeActuelle = {TempsTotal Partition 0}
	    {Etirer Partition DureeTotaleVoulue/DureeActuelle}
	 end
      end
	 
      fun {Etirer Facteur Partition}
	 case Partition of nil then nil
	 [] H|T then echantillon(hauteur:H.hauteur duree:(H.duree*Facteur) instrument:H.instrument)|{Etirer Facteur T}
	 end
      end
      
      fun {ToNote Partition}
	 local M in
	    case Partition
	    of nil then nil
	    [] H|T then case H
			of Nom#Octave then M={ToEchantillon note(nom:Nom octave:Octave alteration:'#')}  M|{ToNote T}
			[] Atom then
			   case {AtomToString Atom}
			   of [N] then M={ToEchantillon note(nom:Atom octave:4 alteration:none)} M|{ToNote T}
			   [] [N O] then M={ToEchantillon note(nom:{StringToAtom[N]} octave:{StringToInt[O]} alteration:none)} M|{ToNote T}
			   end
			else  H|{ToNote T}
			end
	    end
	 end
      end

      %Mix prends une musique et doit retourner un vecteur audio.
      fun {Mix Interprete Music}
	 local ToAudio Merge Renverser RepetitionN RepetitionD Clip Echo Fondu FonduEnchaine Longueur Coupe in
	    
	    fun {ToAudio ListeEchantillons}
	       local ToAudioAux NbAiS  NbAiTot in
		     
		  fun {ToAudioAux Hauteur N I}
		     if I==0 then nil
		     else
			case Hauteur
			of 'silence' then 0|{ToAudioAux 'silence' N I-1}
			[] H then local F Ai in
				     F=2^(H div 12)*440
				     Ai=(0.5*{Sin ((2*3.14159265359*F*(N-I+1)) div 44100)})
				     Ai|{ToAudioAux H N I-1}
				  end
			end
		     end
		  end
		  
		  NbAiS = 44100

		  case ListeEchantillons
		  of nil then nil
		  [] H|T then case H
			      of silence(duree:S) then
				 NbAiTot = NbAiS*S
				 {ToAudioAux 'silence' NbAiTot NbAiTot}|{ToAudio T}
			      [] echantillon(hauteur:H duree:S instrument:none) then
				 NbAiTot = NbAiS*S
				 {ToAudioAux H NbAiTot NbAiTot}|{ToAudio T}
			      end
		  end
	       end     
	    end	    

	    fun {Merge L}
	       local N Itot IntensiteTotale IntensifierMusic IntensifierList AdditionList Somme in
		  N = {Longueur L 0}
		  Itot = {IntensiteTotale L 0}
		  {Somme {IntensifierList L}}
		     
		  fun {IntensiteTotale L Acc}
		     case L of nil then Acc
		     [] H|T then case H of I#M then {IntensiteTotale T Acc+I}
				 end
		     end
		  end

		  fun {IntensifierMusic I M}
		     local Maudio in
			Maudio = {ToAudio M}
			case Maudio of nil then nil
			[] H|T then (I*H)|{IntensifierMusic I T}
			end
		     end
		  end

		  fun {IntensifierList L}
		     case L of nil then nil
		     [] H|T then case H of I#M then {IntensifierMusic (I/Itot) M}|{IntensifierList T}
				 end
		     end
		  end
		     
		  fun {AdditionList L1 L2}
		     case L1
		     of nil then case L2
				 of nil then nil
				 else L2
                                    %[] H2|T2 then H2|{AdditionList L1 T2}
				 end
		     [] H1|T1 then case L2
				   of nil then L1
				      %of nil then H1|{AdditionList T1 L2}
				   [] H2|T2 then (H1+H2)|{AdditionList T1 T2}
				   end
		     end
		  end

		  fun {Somme L}
		     case L of H|nil then H
		     [] H1|H2|T then {Somme {AdditionList H1 H2}|T}
		     end 
		  end
		     
		  /*    case L of nil then nil end
		  if N==1 then case L.1 of I#M then {Intensifier (I/Itot) M}
			       end
		  elseif N==2 then local L1 L2 in
				      case L.1 of I#M then L1={Intensifier (I/Itot) M} end
				      case L.2 of I#M then L2={Intensifier (I/Itot) M} end
				      {AdditionList L1 L2}
				   end
			
		  elseif N==3 then local L1 L2 L3 in
				      case L.1 of I#M then L1={Intensifier (I/Itot) M} end
				      case L.2.1 of I#M then L2={Intensifier (I/Itot) M} end
				      case L.2.2 of I#M then L3={Intensifier (I/Itot) M} end
				      {AdditionList {AdditionList L1 L2} L3}
				   end
			
		  elseif N==4 then local L1 L2 L3 L4 in
				      case L.1 of I#M then L1={Intensifier (I/Itot) M} end
				      case L.2.1 of I#M then L2={Intensifier (I/Itot) M} end
				      case L.2.2.1 of I#M then L3={Intensifier (I/Itot) M} end
				      case L.2.2.2 of I#M then L4={Intensifier (I/Itot) M} end
				      {AdditionList {AdditionList {AdditionList L1 L2} L3} L4}
				   end
			
		  elseif N==5 then local L1 L2 L3 L4 L5 in
				      case L.1 of I#M then L1={Intensifier (I/Itot) M} end
				      case L.2.1 of I#M then L2={Intensifier (I/Itot) M} end
				      case L.2.2.1 of I#M then L3={Intensifier (I/Itot) M} end
				      case L.2.2.2.1 of I#M then L4={Intensifier (I/Itot) M} end
				      case L.2.2.2.2 of I#M then L5={Intensifier (I/Itot) M} end
				      {AdditionList {AdditionList {AdditionList {AdditionList L1 L2} L3} L4} L5}
				   end
			
		  elseif N==6 then local L1 L2 L3 L4 L5 L6 in
				      case L.1 of I#M then L1={Intensifier (I/Itot) M} end
				      case L.2.1 of I#M then L2={Intensifier (I/Itot) M} end
				      case L.2.2.1 of I#M then L3={Intensifier (I/Itot) M} end
				      case L.2.2.2.1 of I#M then L4={Intensifier (I/Itot) M} end
				      case L.2.2.2.2.1 of I#M then L5={Intensifier (I/Itot) M} end
				      case L.2.2.2.2.2 of I#M then L6={Intensifier (I/Itot) M} end
				      {AdditionList {AdditionList {AdditionList {AdditionList {AdditionList L1 L2} L3} L4} L5} L6}
				   end
		  end */
			   
	       end
	    end
	    
	    fun {Renverser L Acc}
%L est la liste ‡ inverser, Acc un accumulateur qui vaut nil au dÈpart (du au case dans lequel on fait appel ‡ cette fonction)
	       case L
	       of nil then Acc
	       [] H|T then {Renverser T H|Acc}
	       end  
	    end

	    fun {RepetitionN NbRep M}
	       if NbRep==0 then M
	       else if M==nil then {RepetitionN NbRep-1 M}
		    else M.1|{RepetitionN NbRep M.2}
		    end
	       end	    
	    end

	    fun {RepetitionD Duree M}
	       local NbRep M1 M2 in
		  NbRep = {TempsTotal M 0} div Duree
		  M1 = {RepetitionN NbRep M}
		  fun {M2 Duree M Acc}
		     if Acc+M.1.duree > Duree then nil
		     else M.1|{M2 Duree M.2 Acc+M.1.duree}
		     end		  
		  end
		  M1 + {M2 Duree M 0}
	       end
	    end

	    fun {Echo Delai Decadence Repetition Musique}
	       local EquIntensite I EchoAux in
		  fun {EquIntensite Dec Rep}
		     if Rep == 0 then 1
		     else Dec^Rep+{EquIntensite Dec Rep-1}
		     end
		  end

		  I = 1/{EquIntensite Decadence Repetition}

		  fun {EchoAux Del Dec Rep M Acc}
		     if Acc==Rep then nil
		     else I^(Acc+1)#[voix[silence(duree:Del*Acc)] M]|{EchoAux Del Dec Rep Acc+1}
		     end
		  end

		  {EchoAux Delai Decadence Repetition Musique 0}

	       end
	    end
	       
	    fun {Clip Bas Haut Audio}
	       case Audio
	       of nil then nil
	       [] H|T then if H < Bas then Bas|{Clip Bas Haut T}
			   elseif H > Haut then Haut|{Clip Bas Haut T}
			   else H|{Clip Bas Haut T}
			   end
	       end	    
	    end

	    fun {Fondu Ouverture Fermeture M}
	       local FonduAux in
		  if Ouverture > 0 then if {Longueur M 0} > (44100*Ouverture) then {FonduAux M Ouverture*44100 1}
					end
		  end
		  fun {FonduAux M Duree Acc}
		     if Acc == Duree then nil
		     else
			((M.1*Acc)/Duree)|{FonduAux M.2 Duree Acc+1}
		     end
		  end
		  if Fermeture > 0 then if {Longueur M 0} > (44100*Fermeture) then {Renverser {FonduAux {Renverser M nil} Fermeture*Duree 1} nil}
					end
		  end
	       end
	    end

	    fun {FonduEnchaine Duree M1 M2}
	       local Voix Silence in
		  {Merge ([0.5#{Fondu Duree 0 M1} 0.5#{Fondu 0 Duree [Voix([Silence(({Longueur M1 0}/44100)-Duree)]) M2]}])}
	       end
	    end

	    fun {Longueur List Acc}
	       case List of nil then Acc
	       else {Longueur List.2 Acc+1}
	       end
	    end

	    fun {Coupe Debut Fin M}
	       /*local Inter Silence Duree CoupeAux D F in
		    fun {CoupeAux D F M}
		       if Fin == 0 then nil
		       elseif Debut == 0 then M.1|{Coupe 0 F-1 M.2}
		       else {Coupe D-1 F-1 M.2}   
		       end
		    end
		     
		    Inter = Fin - Debut
		    if Inter < 0 then {Coupe Fin Debut M} end
		    if Debut < 0 then if Fin < 0 then {ToAudio {Etirer Inter {ToNote Silence}}} end
		    elseif Debut < 0 then if Fin > 0 then ({ToAudio {Etirer ~Debut {ToNote Silence}}})|{CoupeAux 0 Fin*44100 M} end
		    else {CoupeAux Debut*44100 Fin*44100 M}
		    end
		 end*/
	       0
	    end
	 end
      end
      	 
      % Interprete doit interpreter une partition
      fun {Interprete Partition}
	 local P Lire Transpose Bourdon Muet in
	    
	    fun {Lire Partition}
	       case Partition
	       of nil then nil
	       [] H|T then case H  
			   of muet(Part) then {Muet {Interprete Part} nil}
			   [] duree(secondes:S Part) then {Duree S {Interprete Part} nil}
			   [] etirer(facteur:F Part) then {Etirer F {Interprete Part} nil}
			   [] bourdon(note:N Part) then {Bourdon N {Interprete Part} nil}
			   [] transpose(demitons:E Part) then {Transpose E {Interprete Part} nil}
			   end
		  H|{Lire T}
	       end
	    end	       
	    		  
	    fun {Transpose NbreDemiTons Note}
	       local E in
		  E = {ToEchantillon Note}
		  echantillon(hauteur:(E.hauteur + NbreDemiTons) duree:E.duree instrument:E.instrument)
	       end
	    end

	    fun {Bourdon Note Partition}
	       if Partition == nil then nil
	       else
		  ({ToEchantillon Note})|{Bourdon Note Partition.2}
	       end
	    end

	    fun {Muet Partition}
	      % {Bourdon silence Partition}
	       0
	    end
	    
	    P={ToNote {Flatten Partition}}
	    {Lire P}

	 end
      end
   end
   
   local 
      Music = {Projet.load CWD#'joie.dj.oz'}
   in
      % Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
      % vous devez mixer une musique qui d√©montre les fonctionalit√©s de votre
      % programme.
      %
      % Si votre code devait ne pas passer nos tests, cet exemple serait le
      % seul qui ateste de la validit√© de votre impl√©mentation.
      {Browse {Projet.run Mix Interprete Music CWD#'out.wav'}}
   end
end