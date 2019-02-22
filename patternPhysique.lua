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

function list_string_tag(seq, tag)
    if not have_tag(seq, tag) then
        return
    end
    local taille_tag_seq = #seq[tag]
    local table_res = {}
    for nString = 1,taille_tag_seq do 
        local pos = seq[tag][nString]
        local deb, fin = pos[1], pos[2]
        
        local res = {}
        for i = deb,fin do
            res[#res+1] = seq[i].token
        end
        table_res[#table_res+1] = table.concat(res, " ")
    end
    return table_res
end

local basic = dark.basic()
    
local main = dark.pipeline()

local mem = dark.model("postag-fr")

local Pphysique = dark.pipeline()

Pphysique:basic() -- #w et #W

-- Lexiques

Pphysique:lexicon("#personnage", es.obtenir_tous_les_noms())

Pphysique:lexicon("#Lvetement", {"cravate", "salopette", "robe", "chemise", "gant",
								 "gants", "bonnet", "bonnets", "chaussure",
								 "chaussures", "TShirt", "Tshirt", "casquette",
								 "botte", "bottes", "manteau", "manteaux", "cape", "blouse",
								 "armure", "baskets", "basket", "sweat", "ceinture", 
								 "costume", "maillot", "sacados"})

Pphysique:lexicon("#LvetementCompose", {"combinaison", "tenue", "tunique", "vetements", "vetement"}) 

Pphysique:lexicon("#Lcouleur", {"bleu", "bleue", "bleus", "bleues", "rouge", "rouges",
								 "vert", "verte", "verts", "vertes", "violet", 
								 "violette", "violets", "violettes", "orange", 
								 "oranges", "jaune", "jaunes", "cyan", "cyans",
								 "blanc", "blancs", "blanche", "blanches", "noir",
								 "noirs", "noire", "noires", "gris",  "grise", "grises", "marron", "indigo",
								 "ecarlate", "dore", "dores", "argente"})

Pphysique:lexicon("#Lcorps", {"corps", "oreilles", "queue", "yeux", "oeil", "oreille", "nez",
                               "bouche", "dent", "dents", "cheveux", "tete", "museau", "fourrure",
                               "joues", "cou", "epaule", "epaules", "joue", "bras", "avant-bras", "poignet",
                               "main", "doigt", "mains", "poignets", "doigts", "griffe", "griffes",
                               "ongle", "ongles", "cuisse", "cuisses", "ventre", "dos", "jambe", "jambes",
                               "pied", "pieds", "cheville", "chevilles", "orteil", "orteils", "genou", "genoux",
                                }) 

Pphysique:lexicon("#LcouleurAdjectif", {"clair", "fonce", "clairs", "fonces"})

Pphysique:lexicon("#LmotHabit", {"avec", "porte", "met", "a", "possede", "revet", "est vetu", "est vetue"})


-- couleurs adjectif
Pphysique:pattern([[ [#Rcouleur #Lcouleur #LcouleurAdjectif?] ]])

Pphysique:pattern([[ [#Rcouleur #Lcouleur ((#w|#p) #Lcouleur){0,4}] ]])

Pphysique:pattern([[ [#Rcouleur #Lcouleur-#Lcouleur] ]])

-- vetement
Pphysique:pattern([[ [#Rvetement #Lvetement #Rcouleur?] ]])

Pphysique:pattern([[ [#Rvetement #LvetementCompose de #w+?] (et|","|"."|ainsi|#POS=VRB) ]])

Pphysique:pattern([[ [#Rvetement #LvetementCompose (#POS=ADJ|#Lcouleur) ] ]])

-- habits portes
Pphysique:pattern([[ #LmotHabit .{0,3} [#habitPorte #Rvetement] ]])

Pphysique:pattern([[ #habitPorte (.{1,9}? [#habitPorte #Rvetement]){1,6} ]])

Pphysique:pattern([[ (/[Ss][eoa][ns]?/) [#formuleHabitPorte (#Rvetement|#LvetementCompose) (#w){0,2} #POS=VRB (#w){0,2} #Rcouleur] ]])



-- physique
--[=[Pphysique:pattern([[ #personnage est un [#caracteristiques #POS=ADJ? (#POS=NNC|#POS=NNP) #POS=ADJ?] ]])
Pphysique:pattern([[ #personnage est #w{1,3} [#caracteristiques #POS=ADJ{1,3}] ]])

Pphysique:pattern([[ #caracteristiques .{0,2}? [#caracteristiques #POS=ADJ] ]])

Pphysique:pattern([[ #personnage a #w{1,3}? [#caracteristiques #POS=NNC #POS=ADJ] ]])
]=]--

-- corps
Pphysique:pattern([[[#Rcorps (#POS=ADJ #Lcorps | #Lcorps #POS=ADJ)] ]])

Pphysique:pattern([[ (#personnage|/[Ii]l/|/[Ee]lle/) a #POS=DET [#caracCorps #Rcorps] ]])

Pphysique:pattern([[ (/[Ss][eoa][ns]?/) [#formuleCorps #Lcorps (#w){0,2} #POS=VRB (#w){0,2} (#POS|ADJ|#Rcouleur)] ]])

Pphysique:pattern([[ #caracCorps (.{1,9}? [#caracCorps #Rcorps]){1,6} ]])


-- caracteristiques
-- TODO VOIR SI ON SEPARE CACARECRETISUREIQUES CORPS ET CARACATEREISQUEES NORMALES
Pphysique:pattern([[ (#personnage|C "'") est (un|une) [#caracGlobal (#Lcouleur|#POS=ADJ)? (#POS=NNC|#POS=NNP) (#Lcouleur|#POS=ADJ)? ] ]])

--(#personnage|/[Ii]l/|/[Ee]lle/)

-- couleurs possibles : black, red, green, yellow, blue, magenta, cyan, white
local tags = {
    ["#habitPorte"] = "red",
    ["#caracCorps"] = "green",
    ["#caracGlobal"] = "cyan",
    ["#Rcorps"] = "blue",
    --["#POS=ADJ"] = "yellow",
    ["#formuleCorps"] = "magenta",
    --["#LmotHabit"] = "cyan",
}

local file = io.open("textes/Pikachu.txt", "r")
--local line = "La tour Eiffel mesure 324 mètres ."

local lines = file:read("*all") 
lines = lines:gsub("%p", " %0 ")

-- création d'une séquence
local seq = dark.sequence(lines)
basic(seq)
mem:label(seq)
Pphysique(seq)

--print(serialize(seq[3]))


-- LE PRINT EST ICI
--print(seq:tostring(tags))
-- LE PRINT EST LA


--[[
print(serialize(seq["#formuleHabitPorte"]))
local formules = serialize(seq["#formuleHabitPorte"])

print("#########################")

--print(serialize(es.obtenir_tous_les_noms()))
--[[for k,v in pairs(seq[3]) do
    print(k, serialize(v))
end] ]--

print()

local bail = serialize(list_string_tag(seq, "#formuleHabitPorte"))..serialize(list_string_tag(seq, "#formuleCorps"))
print(bail)
bail = bail:gsub(" est ", " ")
bail = bail:gsub(" a ", " ")
bail = bail:gsub(" ont ", " ")
bail = bail:gsub(" sont ", " ")
print(bail)
]]

return Pphysique