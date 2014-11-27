% Vous ne pouvez pas utiliser le mot-clé 'declare'.
local Mix Interprete Projet CWD in
   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre système.
   CWD = {Property.condGet 'testcwd' '/home/layus/ucl/fsab1402/2014-2015/projet_2014/src/'}

   % Projet fournit quatre fonctions :
   % {Projet.run Interprete Mix Music 'out.wav'} = ok OR error(...) 
   % {Projet.readFile FileName} = audioVector(AudioVector) OR error(...)
   % {Projet.writeFile FileName AudioVector} = ok OR error(...)
   % {Projet.load 'music_file.oz'} = Oz structure.
   %
   % et une constante :
   % Projet.hz = 44100, la fréquence d'échantilonnage (nombre de données par seconde)
   [Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}

   local
      Audio = {Projet.readFile CWD#'wave/animaux/cow.wav'}
   in
      % Mix prends une musique et doit retourner un vecteur audio.
      fun {Mix Interprete Music}
	 Audio
      end

      % Interprete doit interpréter une partition
      fun {Interprete Partition}
	 
	 local P in
	    P={ToNote {Flatten Partition}}
	    {Lire P}

	    fun {Lire Partition}
	       case Partition
	       of nil then nil
	       [] H|T then case H
			      of muet(P) then 
			      [] duree(seconces:S P) then {Duree S P} {Lire T}
			      [] etirer(facteur:F P) then {Etirer F P} {Lire T}
			      [] bourdon(note:N P) then {Bourdon N P} {Lire T}
			   [] transpose(demitons:E P) then {Transpose E P} {Lire T}
			   end
	       end
	    end

	    fun {ToNote Partition}
		  case Partition
		  of nil then nil
		  [] H|T then case H
			      of Nom#Octave then M={ToEchantillon note(nom:Nom octave:Octave alteration:’#’)}  M|{ToNote T}
			      [] Atom then
				 case {AtomToString Atom}
				 of [N] then M={ToEchantillon note(nom:Atom octave:4 alteration:none)} M|{ToNote P}
				 [] [N O] then M={ToEchantillon note(nom:{StringToAtom[N]} octave:{StringToInt[O]} alteration:none)} M|{ToNote P}
				 end
			      [] H|{ToNote T}
			      end
		  end
	       end
	       	 
		  local Hauteur in
		     fun {ToEchantillon Note Duree}
			Nom = Note.nom
			if Nom == a then Hauteur = 0
			elseif Nom == b then Hauteur = 2
			elseif Nom == c then Hauteur = 3
			elseif Nom == d then Hauteur = 5
			elseif Nom == e then Hauteur = 7
			elseif Nom == f then Hauteur = 8
			elseif Nom == g then Hauteur = 10
			else skip
			   C = Note.octave
			   Hauteur = Hauteur + ((C-4*12))
			   if Note.alteration == '#' then Hauteur = Hauteur + 1
			   else skip
			      echantillon = (hauteur:Hauteur duree:Duree instrument:none)
			   end
			end
		     end
		  end
	    
		  fun {TempsTotal Partition}
		     proc {TempstotalAux Partition Tempstotal}
			if Partition == nil then Tempstotal
			else {TempstotalAux Partition.2 Tempstotal+1}
			end
		     end
		  end

		  fun {Duree Partition DureeTotaleVoulue}
		     DureeActuelle = {TempsTotal Partition}
		     {Etirer Partition DureeTotaleVoulue/DureeActuelle}
		  end
	 
		  fun {Etirer Partition Facteur}
		     for I in Partition do
			I.duree = I.duree * Facteur
		     end
		  end

		  fun {Transpose Partition NbreDemiTons}
		     for I in Partition do
			I.hauteur = I.hauteur + NbreDemiTons
		     end
		  end

		  fun {Bourdon Partition}
	    
		  end

		  fun {Muet Partition}
	    
		  end
	       end
	    end
	 end

	 local 
	    Music = {Projet.load CWD#'joie.dj.oz'}
	 in
      % Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
      % vous devez mixer une musique qui démontre les fonctionalités de votre
      % programme.
      %
      % Si votre code devait ne pas passer nos tests, cet exemple serait le
      % seul qui ateste de la validité de votre implémentation.
	    {Browse {Projet.run Mix Interprete Music CWD#'out.wav'}}
	 end
      end