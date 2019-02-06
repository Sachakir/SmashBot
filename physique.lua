dark = require("dark")
es = require("entree_sortie")

function have_tag(seq, tag)
    return #seq[tag] ~= 0
end

function string_tag(seq, tag)
    if not have_tag(seq, tag) then
        return
    end
    local pos = seq[tag][1]
    local deb, fin = pos[1], pos[2]
    
    local res = {}
    for i = deb,fin do
        res[#res+1] = seq[i].token
    end
    
    return table.concat(res, " ")
end

local basic = dark.basic()
    
local main = dark.pipeline()

local mem = dark.model("postag-fr")

local Pphysique = dark.pipeline()

Pphysique:basic() -- #w et #W

Pphysique:lexicon("#personnage", es.obtenir_tous_les_noms())

Pphysique:lexicon("#Lvetement", {"cravate", "salopette", "robe", "chemise", "gant",
								 "gants", "bonnet", "bonnets", "combinaison", "chaussure",
								 "chaussures", "T - Shirt", "T - shirt", "casquette",
								 "botte", "bottes", "tenue", "manteau", "manteaux", "cape", "blouse",
								 "armure", "baskets", "basket", "sweat", "ceinture", 
								 "tunique", "costume", "maillot", "sac - a - dos"})

Pphysique:lexicon("#Lcouleur", {"bleu", "bleue", "bleus", "bleues", "rouge", "rouges",
								 "vert", "verte", "verts", "vertes", "violet", 
								 "violette", "violets", "violettes", "orange", 
								 "oranges", "jaune", "jaunes", "cyan", "cyans",
								 "blanc", "blancs", "blanche", "blanches", "noir",
								 "noirs", "gris",  "grise", "grises", "marron", "indigo",
								 "ecarlate", "dore", "dores", "argente"})

Pphysique:lexicon("#Lcorps", {}) -- #TODO

Pphysique:lexicon("#LcouleurAdjectif", {"clair", "fonce"})

Pphysique:lexicon("#LmotHabit", {"avec", "porte", "met", "a", "possede", "revet", })

-- couleur adjectif
Pphysique:pattern([[ [#Rcouleur #Lcouleur #POS=ADJ?] ]])

-- couleur composee
Pphysique:pattern([[ [#Rcouleur #Lcouleur-#Lcouleur] ]])

-- vetement
Pphysique:pattern([[ [#Rvetement #Lvetement #Rcouleur?] ]])

-- habits portes
Pphysique:pattern([[ #LmotHabit #POS=DET #POS=ADJ? [#habitPorte #Lvetement #Rcouleur?] ]])
Pphysique:pattern([[ #habitPorte .{1,10}? [#habitPorte #Lvetement #Rcouleur?] ]])
Pphysique:pattern([[ (/[Ss][eoa][ns]?/) [#habitPorte #Lvetement #Rcouleur?] ]])



-- physique
Pphysique:pattern([[ #personnage est un [#caracteristiques (#POS=NNC|#POS=NNP|#POS=ADJ){1,3}] ]])
Pphysique:pattern([[ #personnage est #w{1,3} [#caracteristiques #POS=ADJ{1,3}] ]])

Pphysique:pattern([[ #caracteristiques .{0,2}? [#caracteristiques #POS=ADJ] ]])

Pphysique:pattern([[ #personnage a #w{1,3}? [#caracteristiques #Pos=NNC #POS=ADJ] ]])
--(#personnage|/[Ii]l/|/[Ee]lle/)

-- couleurs possibles : black, red, green, yellow, blue, magenta, cyan, white
local tags = {
    ["#habitPorte"] = "red",
    ["#caracteristiques"] = "green",
  --  ["#Rvetement"] = "blue",
  --  ["#personnage"] = "yellow",
  	--["#POS=ADJ"] = "cyan",
}

local file = io.open("textes/Mario.txt", "r")
--local line = "La tour Eiffel mesure 324 mètres ."

local lines = file:read("*all") -- "DonkeyKong[1]" pour le truc de Quentin, pour avoir la 1ère ligne
lines = lines:gsub("%p", " %0 ")

-- création d'une séquence
local seq = dark.sequence(lines)
basic(seq)
mem:label(seq)
Pphysique(seq)


--print(serialize(seq[3]))
print(seq:tostring(tags))
--print(serialize(seq["#Rcouleur"][1]))

--[[for k,v in pairs(seq[3]) do
    print(k, v)
end]]--

return Pphysique	