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


{Browse {FloatToInt 2.5}}

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
		  end   */

%		  fun {Coupe Debut Fin M}
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
%	       0
%	    end