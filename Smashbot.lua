dark = require("dark")
data_traitement = require("entree_sortie")
data = require("Base_de_donnees/BD")
traitement = require("regle_reponse")

-- Jeux principaux
-- Date de création
-- Createur

local regle_au_revoir = dark.pattern([[
    [#fin
        ((Au|au) revoir) | /[Ss]alut/ | /[Bb]ye/
    ]
]])

local function printBot(message)
    print("[SmashBot]: "..message)
end

local function traitement_reponse(reponse)
    reponse = dark.sequence(reponse)
    regle_au_revoir(reponse)
    traitement.regles(reponse)
    return reponse
end

local function preparation_reponse(reponse)
    if possede_tag(reponse, "#date_de_creation") then
        nom = string_tag(reponse,"#nom")
        la_date = data_traitement.obtenir_objet_de_personnage_par_clef(data,nom)
        la_date = data_traitement.obtenir_objet_de_personnage_par_clef(la_date,"date")
        return "La date de creation de "..nom.." est "..la_date
    elseif possede_tag(reponse, "#createur") then
        nom = string_tag(reponse,"#nom")
        la_date = data_traitement.obtenir_objet_de_personnage_par_clef(data,nom)
        la_date = data_traitement.obtenir_objet_de_personnage_par_clef(la_date,"createur")
        return "Le createur de "..nom.." est "..la_date
    end
    return "Je n'ai pas compris."
end

function possede_tag(seq, tag)
    return #seq[tag] ~= 0
end

function string_tag(seq, tag)
    if not possede_tag(seq, tag) then
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

function main()
    print("*** SmashBot ***")
    printBot("Salut, je suis SmashBot. Tu as une question pour moi?")
    repeat
        print()
        reponse = io.read()
        reponse = traitement_reponse(reponse)
        if not possede_tag(reponse,"#fin") then 
            printBot(preparation_reponse(reponse))
        end
    until possede_tag(reponse,"#fin")
    printBot("Ok, à la prochaine!")
end

main()
