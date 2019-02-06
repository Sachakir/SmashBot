dark = require("dark")
entree_sortie = require("entree_sortie")
-- On recupere les pipelines
pUnivers = require("patternUnivers")
pCameoSerie = require("serieCameo")

local function have_tag(seq, tag)
    return #seq[tag] ~= 0
end

local function string_tag(seq, tag)
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

local function enlever_accents(texte)
  texte = texte:gsub("['`^~\"]", " ")
  text = texte:gsub("['`^~\"]", "")
  return(texte)
end

local data = {}
local fichiers = obtenir_tous_les_textes()

for nom,texte in pairs(fichiers) do
    personage_tab = {}
    texte = texte:gsub("%p", " %0 ")
    texte = enlever_accents(texte)
	local seq = dark.sequence(texte)
	pUnivers(seq)
    pCameoSerie(seq)
    personage_tab["createur"] = string_tag(seq, "#cre")
    personage_tab["date"] = string_tag(seq, "#date")
    personage_tab["premiere_apparition"] = string_tag(seq, "#fa")
    personage_tab["serie"] = string_tag(seq, "#serie")
    personage_tab["cameo"] = string_tag(seq, "#appearance")
    data[nom] = personage_tab
end

ecrire_dans_la_bd(data)
print(obtenir_les_lignes_de("Mario"))

