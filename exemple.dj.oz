%Exemple.dj.oz
%Notre code avec cet exemple tourne pour le moment en boucle infinie,
%ou tellement longtemps que l'on peut l'y assimiler. Cette version
%est rendue à 01h15 le 4/12/14

local
   A = [etirer(facteur:0.5 [c d e f g])]
   B = [etirer(facteur:0.4 [a b c5 transpose(demitons:12 d)])]
   Partition = [etirer(facteur:0.3 [A B])]

   Musique = [merge([0.5#partition(A) 0.5#partition(B)])] %fondu_enchaine(duree:2.0 partition(A) partition(B)) repetition(nombre:2 [echo(delai:1.0 decadence:0.5 partition(Partition)) A]) /*coupe(0.0 1.5 partition(A))]*/clip(0.15 0.95 partition([a b c])) renverser(partition(A))]

in
   Musique
end
