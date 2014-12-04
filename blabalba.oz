local
   A = [c4 d4 e4]
   B = [e4 f4 g4]
   C = [etirer(facteur:3.0 c4)]
    
in

   [merge([0.5#partition(A) 0.3#partition(B) 0.2#partition(C)])]

end