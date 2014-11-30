local Mix Interprete Projet CWD in
   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre systeme.
   CWD = {Property.condGet 'testcwd' '/home/layus/ucl/fsab1402/2014-2015/projet_2014/src/'}

   % Projet fournit quatre fonctions :
   % {Projet.run Interprete Mix Music 'out.wav'} = ok OR error(...) 
   % {Projet.readFile FileName} = audioVector(AudioVector) OR error(...)
   % {Projet.writeFile FileName AudioVector} = ok OR error(...)
   % {Projet.load 'music_file.oz'} = Oz structure.
   %
   % et une constante :
   % Projet.hz = 44100, la frequence d'echantilonnage (nombre de donnees par seconde)
   [Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}

   local
      Audio = {Projet.readFile CWD#'wave/animaux/cow.wav'}
   in
      local V P Lire Length ToNote ToEchantillon Duree TempsTotal Etirer Transpose Bourdon Muet in
      % Mix prends une musique et doit retourner un vecteur audio.
	 fun {Mix Interprete Music}
	 
	    local ToAudio Merge Renverser RepetitionN RepetitionD Clip Echo Fondu FonduEnchaine Couper in
	    
	       fun {ToAudio Echantillon}
		  local ToAudioAux n in
		     fun {ToAudioAux hauteur N I}
			if I==0 then nil
			else
			   case hauteur
			   of 'H' then 0|{ToAudioAux 'H' N I-1}
			   [] H then local F A in
					F=2^(H div 12)*440
					A=(0.5*{Sin 2*3.14*F*(N-I+1)} div 44100)
					A|{ToAudioAux H N I-1}
				     end
			   end
			end
		     end
		  
		     n = 44100
		     case Echantillon
		     of silence(duree:s) then
			local N in
			   N=n*s {ToAudioAux 'H' N N}
			end
		     [] echantillon(hauteur:h duree:s instrument:none) then
			local N in
			   N=n*s {ToAudioAux h N N}
			end
		     end     
		  end
	       end
	    
	% fun {Merge L}
	%    case L
	%    of nil then nil
	%    [] H|T then case H of I#M then
	%		   case M
	%		   of nil then nil
	%		   [] H|T then I*H|{}
	%		   end	      
	%		end % PAS BON
	%    else nil
	%       Audio 
	%    end
	% end

	       fun {Renverser L A}
%L est la liste � inverser, A un accumulateur qui vaut nil au d�part (du au case dans lequel on fait appel � cette fonction)
		  case L
		  of nil then A
		  [] H|T then {Renverser T H|A}
		  end  
	       end

	       fun {RepetitionN N M}
		  if N==0 then skip
		  elseif N==1 then M   % = 1 ou 0 ?
		  else if M==nil then {RepetitionN N-1 M}
		       else M.1|{RepetitionN N M.2}
		       end
		  end	    
	       end

	       fun {RepetitionD D M}
		  local N M1 M2 in
		     N = {TempsTotal M 0} div D
		     M1 = {RepetitionN N M}
		     fun {M2 D M A}
			if A+M.1.duree > D then nil
			else M.1|{M2 D M.2 A+M.1.duree}
			end		  
		     end
		     M1 + {M2 D M 0}
		  end
	       end

	       fun {Echo Delai Decadence Repetition Musique}
		  local Intensite A I EchoAux in
		     fun {Intensite d R}
			if R == 0 then I
			else I*d^R+{Intensite d R-1}
			end
		     end

		     proc {$ I} {Intensite Decadence Repetition} end

		     fun {EchoAux D d R M A}
			if A==R then nil
			else I^(A+1)#[voix[silence(duree:D*A)] M]|{EchoAux D d R A+1}
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
		     if Ouverture > 0 && {Length M 0} > 44100*Ouverture then {FonduAux M Ouverture*44100 1}
		     end
		     fun {FonduAux M Duree Acc}
			if Acc == Duree then nil
			else
			   ((M.1*Acc)/Duree)|{FonduAux M.2 Duree Acc+1}
			end
		     end
		     if Fermeture > 0 && {Length M 0} > 44100*Fermeture then {Renverser {FonduAux {Renverser M nil} Fermeture*Duree 1} nil}
		     end
		  end
	       end

	       fun {FonduEnchaine Duree M1 M2}
		  local Voix Silence in
		     {Merge ([0.5#{Fondu Duree 0 M1} 0.5#{Fondu 0 Duree [Voix([Silence(({Length M1 0}/44100)-Duree)]) M2]}])}
		  end
	       end

	       fun {Length List Acc}
		  if List == nil then Acc
		  else {Length List.2 Acc+1}
		  end
	       end

%	       local Inter Note Silence DebutAi FinAi in
%		  fun {Couper Debut Fin M}
%		     Inter = Fin - Debut
%		     if Inter < 0 then {Couper Fin Debut M} end
%		     if Debut < 0 && Fin < 0 then {ToAudio {Etirer Inter {ToNote Silence}}}
%		     elseif Debut < 0 && Fin > 0 then {ToAudio {Etirer ~Debut {ToNote Silence}}}|{Couper 0 Fin M}
%		     else DebutAi = 44100 * Debut
%			  FinAi = 44100 * Debut
%			  fun {CouperAux DebutAi
%			
%		     end
%		  end

	       local Inter Silence Duree CouperAux d f in
		  fun {Couper Debut Fin M}
		     Inter = Fin - Debut
		     if Inter < 0 then {Couper Fin Debut M} end
		     if Debut < 0 && Fin < 0 then {ToAudio {Etirer Inter {ToNote Silence}}}
		     elseif Debut < 0 && Fin > 0 then {ToAudio {Etirer ~Debut {ToNote Silence}}}|{CouperAux 0 Fin*44100 M}
		     else {CouperAux Debut*44100 Fin*44100 M}
			
			fun {CouperAux d f M}
			   if Fin == 0 then nil 
			   elseif Debut == 0 then M.1|{Couper 0 Fin-1 M.2}
			   else {Couper Debut-1 Fin-1 M.2}   
			   end
			end
		     
		     end
		  end
		  
	       end
	    end
	 end
	 
      % Interprete doit interpréter une partition
	 fun {Interprete Partition}
	    P={ToNote {Flatten Partition}}
	    V={Lire P}
	    V
	 end
	    
	 fun {Lire Partition}
	    case Partition
	    of nil then nil
	    [] H|T then case H  
			of muet(P) then {Muet {Interprete P}}
			[] duree(secondes:S P) then {Duree S {Interprete P}}
			[] etirer(facteur:F P) then {Etirer F {Interprete P}}
			[] bourdon(note:N P) then {Bourdon N {Interprete P}}
			[] transpose(demitons:E P) then {Transpose E {Interprete P}}
			end
	       H|{Lire T}
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
			      of [N] then M={ToEchantillon note(nom:Atom octave:4 alteration:none)} M|{ToNote P}
			      [] [N O] then M={ToEchantillon note(nom:{StringToAtom[N]} octave:{StringToInt[O]} alteration:none)} M|{ToNote P}
			      end
			   else  H|{ToNote T}
			   end
	       end
	    end
	 end	       
	    		  
	 fun {ToEchantillon Note}
	    local Nom C Hauteur in
	       Nom = Note.nom
	       if Nom == a then Hauteur = 0
	       elseif Nom == b then Hauteur = 2
	       elseif Nom == c then Hauteur = 3
	       elseif Nom == d then Hauteur = 5
	       elseif Nom == e then Hauteur = 7
	       elseif Nom == f then Hauteur = 8
	       elseif Nom == g then Hauteur = 10
	       end
	       C = Note.octave
	       Hauteur = Hauteur + ((C-4*12))
	       if Note.alteration == '#' then Hauteur = Hauteur + 1
	       end
	       echantillon = Note(hauteur:Hauteur duree:1 instrument:none)	  
	    end
	 end
	       
	 fun {TempsTotal Partition TempsTotal}
	    case Partition.1 of note(hauteur:h duree:d instrument:none)
	    then {TempsTotal Partition.2 TempsTotal+Partition.1.note}
	    [] nil then TempsTotal
	    else {TempsTotal Partition.2 TempsTotal}
	    end
	 end

	 fun {Duree DureeTotaleVoulue Partition}
	    local DureeActuelle in
	       DureeActuelle = {TempsTotal Partition 0}
	       {Etirer Partition DureeTotaleVoulue/DureeActuelle}
	    end
	 end
	 
	 fun {Etirer Facteur Partition}
	    for I in Partition do
	       I.duree = I.duree * Facteur %a verifier
	    end
	 end

	 fun {Transpose NbreDemiTons Note}
	    local E in
	       E = {ToEchantillon Note}
	       E.hauteur = E.hauteur + NbreDemiTons %a verifier
	    end
	 end

	 fun {Bourdon Note Partition}
	    if Partition == nil then nil
	    else
	       Note|{Bourdon Note Partition.2}
	    end
	 end

	 fun {Muet Partition}
	    local Silence in
	       {Bourdon Silence(duree:1) Partition}
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
