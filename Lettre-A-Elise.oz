% Lettre à Elise

local
   
   A = [ e5 d#5 e5 d#5 e5 b4 d5 c5 etirer(facteur:2.0 a4)]
   B = [ c4 e4 a4 etirer(facteur:2.0 b4)]
   C = [ e4 a4 c4 etirer(facteur:2.0 d5)]
   D = [ e4 c5 b4 etirer(facteur:4.0 a4)]
   Partition = [etirer(facteur:0.5 [A B C A B C])]
  %[repetition(nombre:2 fondu_enchaine(duree:5.0 fondu(ouverture:1.0 fermeture:0.0 partition(Partition)) echo(delai:10.0 decadence:0.5 partition(transpose(Partition)))))] 
in
   
   [fondu_enchaine(duree:5.0 partition(Partition) partition(Partition))]
   
end
   