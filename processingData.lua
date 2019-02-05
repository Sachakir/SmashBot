dark = require("dark")
lol = require("Base_de_donnees/BD")
entree_sortie = require("entree_sortie")
-- On recupere les pipeline
pUnivers = require("patternUnivers")

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

local data = {}
local listNames = {"DKTest.txt","FoxTest.txt"}

local fichiers = obtenir_tous_les_textes()
local file = fichiers[Personnage]


for name,text in pairs(fichiers) do
	-- On applique le seq sur notre texte
	local seq = dark.sequence(text)
	pUnivers(seq)
	--print(serialize(seq["#cre"]))
	print(string_tag(seq, "#cre"))
	print(string_tag(seq, "#fa"))
	print(string_tag(seq, "#date"))
	--P(seq)
end


