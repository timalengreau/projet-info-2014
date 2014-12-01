declare
fun {Transpose NbreDemiTons Note}
   local E in
      E = {ToEchantillon Note}
      echantillon(hauteur:(E.hauteur + NbreDemiTons) duree:E.duree instrument:E.instrument)
   end
end

fun {ToEchantillon Note} %Faire les silences /!\
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


{Browse {Transpose 12 note(nom:a octave:4 alteration:none)}}