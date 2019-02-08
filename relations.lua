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
    	restmp = {}
    	for j = deb,fin do
        restmp[#restmp+1] = seq[j].token
    	end
    	phrase = table.concat(restmp, " ")
		res[#res+1] = phrase
	end
	return res
end

local P = dark.pipeline()
P:basic()
P:lexicon("#personnage", 
	{ 	"Mario","Donkey Kong","Link","Samus","Samus Sombre",
		"Yoshi","Kirby","Fox","Pikachu","Luigi","Ness",
		"Captain Falcon","Rondoudou","Peach","Daisy","Bowser",
		"Ice Climbers","Sheik","Zelda","Dr. Mario","Pichu",
		"Falco","Marth","Lucina","Link Enfant","Ganondorf",
		"Mewtwo","Roy","Chrom","Mr. Game & Watch","Meta Knight",
		"Pit","Pit Malefique","Samus Sans Armure","Wario","Snake",
		"Ike","Dresseur De Pokemon","Diddy Kong","Lucas","Sonic",
		"Roi Dadidou","Olimar","Lucario","R.O.B.","Link Cartoon",
		"Wolf","Villageois","Mega Man","Entraineuse Wii Fit",
		"Harmonie & Luma","Little Mac","Amphinobi",
		"Combattant Mii","Palutena","Pac-Man","Daraen","Shulk",
		"Bowser Jr.","Duo Duck Hunt","Ryu","Ken","Cloud","Corrin",
		"Bayonetta","Inkling","Ridley","Simon","Richter",
		"King K. Rool","Marie","Felinferno","Plante Pirahna"
	})
P:lexicon("#famille", { "pere", "mere", "frere","soeur","famille","parents","bebe","Bebe" })--TODO a ajouter plus de mots

P:pattern([[
    [#phrase
       	.+? ("." | "?" | "!" | "...")
    ]
]])

P:pattern([[
    [#family
       	(.* [#lienFamille #personnage ] .* #famille .* [#lienFamille #personnage ] .* ) | (.* #famille .* [#lienFamille #personnage ] .* [#lienFamille #personnage ] .* ) | (.* [#lienFamille #personnage ] .* [#lienFamille #personnage ] .* famille .* )
    ]
]])

local taps = {
    ["#personnage"] = "red",
    ["#lienFamille"] = "blue"
}

text = es.obtenir_les_lignes_de("Luigi")
text = text:gsub("%p"," %0 ")--Separation des virgules et des points...

local seq = dark.sequence(text)
P(seq)
local phrases = alltag(seq, "#phrase")--phrases est la liste des phrases du texte
for i, phrase in ipairs(phrases) do
	local seq2 = dark.sequence(phrase)
	P(seq2)
	--print(seq2:tostring(taps))
end

return P
--Tag : #lienFamille