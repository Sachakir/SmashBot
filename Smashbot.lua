dark = require("dark")
data_traitement = require("entree_sortie")
data = require("Base_de_donnees/BD")
traitement = require("regle_reponse")
lev = require("levenshtein")
creationstring = require("creationReponse")

-- Objet qui enregistre un nom de perso ET un thème.
local memoire = {
    [1] = {},
    [2] = {},
    [3] = {},
}
local ultra_memoire = {}


local taps = {
    ["#date_de_creation"] = "yellow",
    ["#createur"] = "blue",
    ["#serie"] = "green",
    ["#nom"] = "red",
    ["#monde"] = "red",
    ["#question_persos"] = "red",
    ["#all"] = "red",
    ["#physiqueGeneral"] = "cyan",
}

local regle_au_revoir = dark.pattern([[
    [#fin
        ((Au|au) revoir) | /[Ss]alut/ | /[Bb]ye/
    ]
]])

local function printBot(message)
    print("[SmashBot]: "..message)
end

local function traitement_reponse(reponse)
    reponse = reponse:gsub("%p", " %0 ")
    reponse = dark.sequence(reponse)
    regle_au_revoir(reponse)
    traitement.regles(reponse)
    return reponse
end

local function obtenir_nom_reponse(reponse)
    nom = obtenir_tab_de_mots_par_tag(reponse,"#nom")
    if nom == nil then
        nom = memoire[1]['perso']
    end
    if next(nom) == nil then
        nom = memoire[2]['perso']
    end
    if next(nom) == nil then
        nom = memoire[3]['perso']
    end
    return nom
end

local function obtenir_theme_reponse(theme)
    res = {}
    if memoire[1]['theme'] == nil then
        return false
    end
    if next(memoire[1]['theme']) ~= nil then
        res = memoire[1]['theme']
    elseif next(memoire[2]['theme']) ~= nil then
        res = memoire[2]['theme']
    elseif next(memoire[3]['theme']) ~= nil then
        res = memoire[3]['theme']
    end
    if next(res) == nil then return false end
    for k,v in pairs(res) do
        if v == theme then
            return true
        end
    end
    return false
end

local function chercheCompatibiliteNom(chaine)
    local noms = data_traitement.obtenir_tous_les_noms()

    for i = 1, #chaine do
        for k,v in pairs(noms) do
            for k = 1, #chaine[i] do
                if chaine[i][k].name == "#W" then 
                    if lev.distance_levenshtein(v, chaine[i].token) <= string.len(v)/2 and lev.distance_levenshtein(v, chaine[i].token)  <= string.len(chaine[i].token)/2 and string.len(chaine[i].token) > 3 then
                        return "Vous voulez dire "..v.." ?"
                    end
                end
            end
        end
    end 
    
    return "De quel personnage parlez-vous ?"
end

local function preparation_reponse(reponse)
    string_reponse = ""
    nom = obtenir_nom_reponse(reponse)
    
    if possede_tag(reponse, "#question_persos") then
        info = obtenir_tous_les_noms()
        liste = ""
        for k,v in pairs(info) do
            liste = liste..", "..v
        end
        return "Voilà tous les persos que je connais "..liste
    end
    
    if possede_tag(reponse, "#date_de_creation") then
        string_reponse = dateCreation(data, nom, string_reponse)
    end
    if possede_tag(reponse, "#createur") then
        string_reponse = Createur(data, nom, string_reponse)
    end
    if possede_tag(reponse, "#serie") then
        string_reponse = Serie(data, nom, string_reponse)
    end
    if possede_tag(reponse, "#cameo") then
        string_reponse = Cameo(data, nom, string_reponse)
    end
    if possede_tag(reponse, "#premiere_apparition") then
        string_reponse = PremiereApparition(data, nom, string_reponse)
    end
    if possede_tag(reponse, "#ami") then
        string_reponse = Ami(data, nom, string_reponse)
    end
    
    if possede_tag(reponse, "#physiqueGeneral") then
        string_reponse = Physique(data, nom, string_reponse)
    end

    print(obtenir_theme_reponse("#date_de_creation"))
    
    if possede_tag(reponse, "#nom") and string_reponse == "" then
        if obtenir_theme_reponse("#date_de_creation") then
            string_reponse = dateCreation(data, nom, string_reponse)
        end
        if obtenir_theme_reponse("#createur") then
            string_reponse = Createur(data, nom, string_reponse)
        end
        if obtenir_theme_reponse("#serie") then
            string_reponse = Serie(data, nom, string_reponse)
        end
        if obtenir_theme_reponse("#cameo") then
            string_reponse = Cameo(data, nom, string_reponse)
        end
        if obtenir_theme_reponse("#premiere_apparition") then
            string_reponse = PremiereApparition(data, nom, string_reponse)
        end
        if obtenir_theme_reponse("#ami") then
            string_reponse = Ami(data, nom, string_reponse)
        end

        if obtenir_theme_reponse("#physiqueGeneral") then
        	string_reponse = Physique(data, nom, string_reponse)
    	end

    end
    
    if string_reponse == "" then 
        return "Je n'ai pas compris votre question."
    end
    return string_reponse
end

local function update_memoire(reponse)
    memoire[3]['perso'] = memoire[2]['perso']
    memoire[3]['theme'] = memoire[2]['theme']
    memoire[2]['perso'] = memoire[1]['perso']
    memoire[2]['theme'] = memoire[1]['theme']
    memoire[1]['theme'] = {}

    if possede_tag(reponse, "#nom") then
        memoire[1]['perso'] = obtenir_tab_de_mots_par_tag(reponse,"#nom")
    end
    if possede_tag(reponse, "#date_de_creation") then
        table.insert(memoire[1]['theme'], "#date_de_creation")
    end
    if possede_tag(reponse, "#createur") then
        table.insert(memoire[1]['theme'], "#createur")
    end
    if possede_tag(reponse, "#serie") then
        table.insert(memoire[1]['theme'], "#serie")
    end
    if possede_tag(reponse, "#cameo") then
        table.insert(memoire[1]['theme'], "#cameo")
    end
    if possede_tag(reponse, "#premiere_apparition") then
        table.insert(memoire[1]['theme'], "#premiere_apparition")
    end
    if possede_tag(reponse, "#ami") then
        table.insert(memoire[1]['theme'], "#ami")
    end

    if possede_tag(reponse, "#physiqueGeneral") then
        table.insert(memoire[1]['theme'], "#physiqueGeneral")
    end
    
    tempo = {
        ["perso"] = memoire[3]['perso'],
        ["theme"] = memoire[3]['theme'],
    }
    table.insert(ultra_memoire, tempo)
    
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
    -- SmashBot en lui-même
    print("*** SmashBot ***")
    printBot("Salut, je suis SmashBot. Tu as une question pour moi?")
    repeat
        print()
        reponse = io.read()
        reponse = traitement_reponse(reponse)
        memoire = update_memoire(reponse)
        print(serialize(memoire))
        --print(serialize(ultra_memoire))
        --print(reponse:tostring(taps))
        --print(serialize(obtenir_tab_de_mots_par_tag(reponse, "#nom")))
        if not possede_tag(reponse,"#fin") then 
            printBot(preparation_reponse(reponse))
        end
    until possede_tag(reponse,"#fin")
    printBot("Ok, à la prochaine!")
end

main()
