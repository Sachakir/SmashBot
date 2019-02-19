dark = require("dark")
entree_sortie = require("entree_sortie")
-- On recupere les pipelines
pUnivers = require("patternUnivers")
pCameoSerie = require("patternSerieCameo")
pPhysique = require("patternPhysique")
pAmi = require("relations")


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

function list_string_tag(seq, tag)
	--On check si tag existe
    if not have_tag(seq, tag) then
        return
    end
    local taille_tag_seq = #seq[tag]
    local table_res = {}
    for nString = 1,taille_tag_seq do 
		-- on prend le tag en position nString
        local pos = seq[tag][nString]
		--deb = debut de notre tag, fin = end de ce tag
        local deb, fin = pos[1], pos[2]
        local res = {}
		-- on recupere char par char l element
        for i = deb,fin do
            res[#res+1] = seq[i].token
        end
		if(checkPresence(table.concat(res, " "), table_res)) then
			-- On ajoute la valeur a la liste
			table_res[#table_res+1] = table.concat(res, " ")
		end
    end
    return table_res
end

function checkPresence(res, table_res)
	for compteur = 0, #table_res do
		if (table_res[compteur] == res) then
			return false
		end
	end
	return true
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
    return texte
end

local taps = {
    ["#cre"] = "yellow",
    ["#date"] = "blue",
    ["#fa"] = "green",
    ["#serie"] = "red",
    ["#appearance"] = "purple", 
    ["#caracGlobal"] = "cyan",
    ["#caracCorps"] = "red",
}

local data = {}
local fichiers = obtenir_tous_les_textes()
local test_nom = "Luigi"

local main = dark.pipeline()
main:basic()
main:model("postag-fr")
main:add(pUnivers)
main:add(pCameoSerie)
main:add(pPhysique)
main:add(pAmi)

for nom,texte in pairs(fichiers) do
    personage_tab = {}
    texte = texte:gsub("%p", " %0 ")
    texte = enlever_accents(texte)
	local seq = dark.sequence(texte)
	main(seq)
    personage_tab["createur"] = string_tag(seq, "#cre")
    personage_tab["date"] = string_tag(seq, "#date")
    personage_tab["premiere_apparition"] = string_tag(seq, "#fa")
    personage_tab["serie"] = string_tag(seq, "#serie")
    personage_tab["jeux"] = list_string_tag(seq, "#jeux")
    personage_tab["physique"] = {}
    personage_tab["physique"]["habitPorte"] = list_string_tag(seq, "#habitPorte")    
    personage_tab["physique"]["corps"] = list_string_tag(seq, "#caracCorps")
    personage_tab["physique"]["caracteristiques"] = list_string_tag(seq, "#caracGlobal")
    personage_tab["ami"] = list_string_tag(seq, "#lienFamille")
    data[nom] = personage_tab
end
ecrire_dans_la_bd(data)

--[[
test = obtenir_les_lignes_de(test_nom)
--print(test)
test = test:gsub("%p", " %0 ")
test = enlever_accents(test)
seq_test = dark.sequence(test)
main(seq_test)
print(seq_test:tostring(taps))
]]--

