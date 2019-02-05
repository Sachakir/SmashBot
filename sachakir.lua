local es = require("entree_sortie")
local model = dark.model("postag-fr")


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

function alltag(seq, tag)
	if not have_tag(seq, tag) then
        return
    end
	nombre_de_phrases = #seq[tag]
	local res = {}
	for i = 1,nombre_de_phrases do
		local pos = seq[tag][i]
    	local deb, fin = pos[1], pos[2]

    	--
    	restmp = {}
    	for j = deb,fin do
        restmp[#restmp+1] = seq[j].token
    	end
    
    	phrase = table.concat(restmp, " ")
    	--
		res[#res+1] = phrase
	end
	return res

end

local P = dark.pipeline()
P:basic()
P:lexicon("#personnage", { "Donkey Kong", "Mario", "Pauline","Luigi","Yoshi" })
P:lexicon("#famille", { "père", "mère", "frère","soeur","famille","parents","bébé","Bébé" })

local regle_phrase = dark.pattern([[
    [#phrase
       	.+? ("." | "?" | "!" | "...")
    ]
]])

local regle_4 = dark.pattern([[
    [#idee
       	"Mario" .*? "."
    ]
]])

local regle_detecte_perso = dark.pattern([[
    [#persoDetecte
       	#POS=NNP
    ]
]])

local regle_lien_famille = dark.pattern([[
    [#family
       	(.* [#lienFamille #personnage ] .* #famille .* [#lienFamille #personnage ] .* ) | (.* #famille .* [#lienFamille #personnage ] .* [#lienFamille #personnage ] .* ) | (.* [#lienFamille #personnage ] .* [#lienFamille #personnage ] .* famille .* )
    ]
]])

local taps = {
    --["#personnage"] = "red",
    --["#persoDetecte"] = "blue",
    ["#family"] = "green",
    ["#lienFamille"] = "yellow"
}

texte = es.obtenir_les_lignes_de("Mario")

text = texte[15]
text = text:gsub("%p"," %0 ")--Separation des virgules et des points...



local seq = dark.sequence(text)
P(seq)

regle_phrase(seq)
local phrases = alltag(seq, "#phrase")
for i, phrase in ipairs(phrases) do
	local seq2 = dark.sequence(phrase)
	P(seq2)
	model(seq2)
	regle_4(seq2)
	regle_detecte_perso(seq2)
	regle_lien_famille(seq2)
	print("")
	print(seq2:tostring(taps))
end
print("")
print(seq:tostring())



