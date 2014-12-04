local
A = 1.0

    fun {Clip Bas Haut Audio}
	 case Audio
	 of nil then nil
	 [] H|T then if H < Bas then Bas|{Clip Bas Haut T}
		     elseif H > Haut then Haut|{Clip Bas Haut T}
		     else H|{Clip Bas Haut T}
		     end
	 end	    
      end


in
   
{Browse {Clip ~0.15 0.15 A}}

   end