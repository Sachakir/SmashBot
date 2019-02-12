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

local function obtenir_nom_reponse(reponse, memoire)
    nom = string_tag(reponse,"#nom")
    if nom == nil then
        nom = memoire['perso']
    end
    return nom
end

local function obtenir_info_reponse(reponse, nom, info)
    res = data_traitement.obtenir_objet_de_personnage_par_clef(data,nom)
    res = data_traitement.obtenir_objet_de_personnage_par_clef(res, info)
    return res
end

local function preparation_reponse(reponse, memoire)
    nom = obtenir_nom_reponse(reponse, memoire)
    if nom == nil then
        return "De qui parlez-vous ?!?"
    end
    
    if possede_tag(reponse, "#date_de_creation") then
        info = obtenir_info_reponse(reponse, nom, "date")
        if info == nil then
            return "Je ne sais pas."
        end
        return "La date de creation de "..nom.." est "..info
    elseif possede_tag(reponse, "#createur") then
        info = obtenir_info_reponse(reponse, nom, "createur")
        if info == nil then
            return "Je ne sais pas."
        end
        return "Le createur de "..nom.." est "..info
    end
    
    if possede_tag(reponse, "#nom") then
        if memoire['theme'] == "#date_de_creation" then
              info = obtenir_info_reponse(reponse, nom, "date")
            if info == nil then
                return "Je ne sais pas."
            end
            return "La date de creation de "..nom.." est "..info
        elseif memoire['theme'] == "#createur" then
            info = obtenir_info_reponse(reponse, nom, "createur")
            if info == nil then
                return "Je ne sais pas."
            end
            return "Le createur de "..nom.." est "..info
        end
    end
        
    return "Je n'ai pas compris."
end

local function update_memoire(reponse, memoire)
    if possede_tag(reponse, "#nom") then
        memoire['perso'] = string_tag(reponse,"#nom")
    end
    if possede_tag(reponse, "#date_de_creation") then
        memoire['theme'] = "#date_de_creation"
    elseif possede_tag(reponse, "#createur") then
        memoire['theme'] = "#createur"
    end
    return memoire
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
    -- Objet qui enregistre un nom de perso ET un thème.
    memoire = {}
    
    -- SmashBot en lui-même
    print("*** SmashBot ***")
    printBot("Salut, je suis SmashBot. Tu as une question pour moi?")
    repeat
        print()
        reponse = io.read()
        reponse = traitement_reponse(reponse)
        memoire = update_memoire(reponse, memoire)
        --print(serialize(memoire))
        if not possede_tag(reponse,"#fin") then 
            printBot(preparation_reponse(reponse, memoire))
        end
    until possede_tag(reponse,"#fin")
    printBot("Ok, à la prochaine!")
end

main()
