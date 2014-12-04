local
   A = [c d e f g]
   
   B
   fun {RepetitionN NbRep M}
	 if NbRep==1 then M
	 else {Append M {RepetitionN NbRep-1  M}}
	 end	    
      end
in
   
 B =[couper(debut:1.0 fin:5.0 partition(A))]



   {Browse {RepetitionN 3 A}}

   end