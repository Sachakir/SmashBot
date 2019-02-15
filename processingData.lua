dark = require("dark")
entree_sortie = require("entree_sortie")
-- On recupere les pipelines
pUnivers = require("patternUnivers")
pCameoSerie = require("serieCameo")
relations = require("relations")

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
    texte = texte:gsub("ä", "a")
    texte = texte:gsub("â", "a")
    texte = texte:gsub("à", "a")
    texte = texte:gsub("é", "e")
    texte = texte:gsub("è", "e")
    texte = texte:gsub("ê", "e")
    texte = texte:gsub("ë", "e")
    texte = texte:gsub("ï", "i")
    texte = texte:gsub("î", "i")
    texte = texte:gsub("ì", "i")
    texte = texte:gsub("ö", "o")
    texte = texte:gsub("ô", "o")
    texte = texte:gsub("ò", "o")
    texte = texte:gsub("ü", "u")
    texte = texte:gsub("û", "u")
    texte = texte:gsub("ù", "u")
	texte = texte:gsub("'", " ")
    return texte
end

local taps = {
    ["#cre"] = "yellow",
    ["#date"] = "blue",
    ["#fa"] = "green",
    ["#serie"] = "red",
    ["#appearance"] = "purple",
    ["#lienFamille"] = "red"
}

local data = {}
local fichiers = obtenir_tous_les_textes()

---### Apply the patterns on every file ###
for nom,texte in pairs(fichiers) do
    personage_tab = {}
    texte = texte:gsub("%p", " %0 ")
    texte = enlever_accents(texte)
	local seq = dark.sequence(texte)
	pUnivers(seq)
    pCameoSerie(seq)
    relations(seq)
    personage_tab["lienFamille"] = string_tag(seq,"#lienF")
    personage_tab["createur"] = string_tag(seq, "#cre")
    personage_tab["date"] = string_tag(seq, "#date")
    personage_tab["premiere_apparition"] = string_tag(seq, "#fa")
    personage_tab["serie"] = string_tag(seq, "#serie")
    personage_tab["cameo"] = string_tag(seq, "#appearance")
    data[nom] = personage_tab
end

ecrire_dans_la_bd(data)

---### Test to display the analysis of one file ###
local test_nom = "Captain Falcon"
test = obtenir_les_lignes_de(test_nom)
--print(test)
test = test:gsub("%p", " %0 ")
test = enlever_accents(test)
seq_test = dark.sequence(test)
pUnivers(seq_test)
pCameoSerie(seq_test)
relations(seq_test)
--print(seq_test:tostring(taps))


