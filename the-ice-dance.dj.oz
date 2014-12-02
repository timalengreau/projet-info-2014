%The ice dance
local
   MA = [etirer(facteur:4.0 b) etirer(facteur:2.0 [b d]) etirer(facteur:4.0 d) etirer(facteur:2.0 [f#4 a5])]
   MAa = [etirer(facteur:4.0 [b b d]) etirer(facteur:2.0 [f#4 a5])]
   MAb = [etirer(facteur:2.0 [f#5 a6])]
   MB = [etirer(facteur:4.0 [b3 g3 f#3 d3])]
   MBb = [etirer(facteur:2.0 [b3 g3 b4 g3]) etirer(facteur:4.0 [f#3 d3])]
   
   M1 = [MA MAa transpose(demitons:~12 MA) transpose(demitons:~12 MA) MB MBb transpose(demitons:~12 MA) transpose(demitons:~12 MA)]
   M2 = [etirer(facteur:28.0 silence) MAb MA MA transpose(demitons:12 MB) transpose(demitons:12 MBb) MA MA]
   
   AccA = [etirer(facteur:4.0 [b3 g2 f#3 d3])]
   AccB = [g1 d2 g2 d2 g2 d2 g2 d2]
   AccBb = [g1 d2 g2 d2 g1 d2 g1 d2]
   AccBc = [g1 d2 g2 d2 g1 d2 g2 d2]
   AccC = [b2 f#2 b3 f#2 d2 a3 d3 a3]
   AccC1 = [b2 f#2 b3 f#2 d2 a3 etirer(facteur:2.0 d3)]
   AccC2 = [b2 f#2 b3 f#2 b2 f#2 b3 f#2]
   AccC3 = [b2 f#2 b3 f#2 etirer(facteur:4.0 b3)]
   AccC3c = [b2 f#2 b3 f#2 etirer(facteur:4.0 b2)]
   
   Acc1 = [AccA AccA AccB AccC AccB AccC1 AccB AccC2 AccB AccC3 AccB AccC AccB AccC1]
   Acc2 = [AccA AccA AccBb AccC AccBb AccC1 AccBc AccC2 AccBc AccC3c AccBb AccC AccBb AccC1]
   
   Partition = merge[0.3#partition(M1) 0.3#partition(M2) 0.2#partition(Acc1) 0.2#partition(Acc2)]
in
   [partition(Partition)]
end