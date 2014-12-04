%The ice dance
%Partition retranscrite de The Ice Dance du film Edward aux Mains d'Argent. Notre programme n'est malheureusement pas capable de la transformer en fichier wav car l'emulateur arrive a cours de memoire
local
   MA = [etirer(facteur:4.0 [b4]) etirer(facteur:2.0 [b4 d5]) etirer(facteur:4.0 [d5]) etirer(facteur:2.0 [f#5 a5])]
   MAa = [etirer(facteur:4.0 [b4 b4 d5]) etirer(facteur:2.0 [f#5 a5])]
   MAb = [etirer(facteur:2.0 [f#6 a6])]
   MB = [etirer(facteur:4.0 [b4 g5 f#4 d5])]
   MBb = [etirer(facteur:2.0 [b4 g5 b5 g5]) etirer(facteur:4.0 [f#5 d5])]
   
   M1 = [MA MAa transpose(demitons:~12 MA) transpose(demitons:~12 MA) transpose(demitons:~12 MB) transpose(demitons:~12 MBb) transpose(demitons:~12 MA) transpose(demitons:~12 MA)]
   %M2 = [etirer(facteur:28.0 silence) MAb MA MA MB MBb MA MA]
   
   AccA = [etirer(facteur:4.0 [b3 g3 f#4 d4])]
   AccB = [g2 d3 g3 d3 g3 d3 g3 d3]
   AccBb = [g2 d3 g3 d3 g2 d3 g2 d3]
   AccBc = [g2 d3 g3 d3 g2 d3 g3 d3]
   AccC = [b2 f#3 b3 f#3 d3 a3 d4 a3]
   AccC1 = [b2 f#3 b3 f#3 d3 a3 etirer(facteur:2.0 [d4])]
   AccC2 = [b2 f#3 b3 f#3 b2 f#3 b3 f#3]
   AccC3 = [b2 f#3 b3 f#3 etirer(facteur:4.0 [b3])]
   AccC3c = [b2 f#3 b3 f#3 etirer(facteur:4.0 [b2])]
   
   Acc1 = [AccA AccA AccB AccC AccB AccC1 AccB AccC2 AccB AccC3 AccB AccC AccB AccC1]
  % Acc2 = [AccA AccA AccBb AccC AccBb AccC1 AccBc AccC2 AccBc AccC3c AccBb AccC AccBb AccC1]

in
   
   [merge([0.6#partition(M1) 0.4#partition(Acc1)])]
   
end

