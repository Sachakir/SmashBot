dark = require("dark")
data_traitement = require("entree_sortie")
data = require("Base_de_donnees/BD")
traitement = require("regle_reponse")
lev = require("levenshtein")

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
    if nom == nil then
        nom = memoire[2]['perso']
    end
    if nom == nil then
        nom = memoire[3]['perso']
    end
    return nom
end

local function obtenir_theme_reponse()
    if memoire[1]['theme'] == nil then
        return memoire[1]['theme']
    end
    if memoire[2]['theme'] == nil then
        nom = memoire[2]['theme']
    end
    if memoire[3]['theme'] == nil then
        return memoire[3]['theme']
    end
    return nil
end

local function obtenir_info_reponse(reponse, nom, info)
    res = data_traitement.obtenir_personnage_par_nom(data,nom)
    res = data_traitement.obtenir_objet_de_personnage_par_clef(res, info)
    return res
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
    return nil
end

local function preparation_reponse(reponse)
    string_reponse = ""
    nom = obtenir_nom_reponse(reponse)

    if nom == nil then
        return chercheCompatibiliteNom(reponse)
    end

    if nom == nil then
        return "De quel personnage parlez-vous ?"
    end
    
    if possede_tag(reponse, "#question_persos") then
        info = obtenir_tous_les_noms()
        liste = ""
        for k,v in pairs(info) do
            liste = liste..", "..v
        end
        return "Voilà tous les persos que je connais "..liste
    end
    
    if possede_tag(reponse, "#date_de_creation") then
        for k,v in pairs(nom) do
            info = obtenir_info_reponse(data,v,"date")
            if info == nil then
                string_reponse = string_reponse.."Je ne connais pas la date de création de "..v..". "
            else
                string_reponse = string_reponse.."La date de creation de "..v.." est "..info..". "
            end
        end
    elseif possede_tag(reponse, "#createur") then
        for k,v in pairs(nom) do
            info = obtenir_info_reponse(data,v,"createur")
            if info == nil then
                string_reponse = string_reponse.."Je ne connais pas le createur de "..v..". "
            else
                string_reponse = string_reponse.."Le/La createur/creatrice de "..v.." est "..info..". "
            end
        end
    elseif possede_tag(reponse, "#serie") then
        for k,v in pairs(nom) do
            info = obtenir_info_reponse(data,v,"serie")
            if info == nil then
                string_reponse = string_reponse.."Je ne connais pas la serie de "..v..". "
            else
                string_reponse = string_reponse.."La serie de "..v.." est "..info..". "
            end
        end
    elseif possede_tag(reponse, "#cameo") then
        for k,v in pairs(nom) do
            info = obtenir_info_reponse(data,v,"cameo")
            if info == nil then
                string_reponse = string_reponse.."Je ne connais pas le(s) cameo(s) de "..v..". "
            else
                string_reponse = string_reponse.."le(s) cameo(s) de "..v.." est/sont "..info..". "
            end
        end
    elseif possede_tag(reponse, "#premiere_apparition") then
        for k,v in pairs(nom) do
            info = obtenir_info_reponse(data,v,"premiere_apparition")
            if info == nil then
                string_reponse = string_reponse.."Je ne sais pas où "..v.." est apparu pour la première fois. "
            else
                string_reponse = string_reponse.."la première apparition de "..v.." est dans "..info..". "
            end
        end
    elseif possede_tag(reponse, "#ami") then
        for k,v in pairs(nom) do
            info = obtenir_info_reponse(data,v,"ami")
            if info == nil then
                string_reponse = string_reponse.."Je ne sais pas qui est l'ami de "..v..". "
            else
                string_reponse = string_reponse.."l'ami de "..v.." est "..info..". "
            end
        end
    end
    --[[
    if possede_tag(reponse, "#nom") then
        if obtenir_theme_reponse() == "#date_de_creation" then
            for k,v in pairs(nom) do
                info = obtenir_info_reponse(data,v,"date")
                if info == nil then
                    string_reponse = string_reponse.."Je ne connais pas la date de création de "..v..". "
                else
                    string_reponse = string_reponse.."La date de creation de "..v.." est "..info..". "
                end
            end
        elseif obtenir_theme_reponse() == "#createur" then
            info = obtenir_info_reponse(reponse, nom, "createur")
            if info == nil then
                return "Je ne sais pas."
            end
            return "Le createur de "..nom.." est "..info
        elseif obtenir_theme_reponse() == "#serie" then
            info = obtenir_info_reponse(reponse, nom, "serie")
            if info == nil then
                return "Je ne sais pas."
            end
            return "La serie de "..nom.." est "..info
        elseif obtenir_theme_reponse() == "#cameo" then
            info = obtenir_info_reponse(reponse, nom, "cameo")
            if info == nil then
                return "Je ne sais pas."
            end
            return nom.." est venu en caméo dans "..info
        elseif obtenir_theme_reponse() == "#premiere_apparition" then
            info = obtenir_info_reponse(reponse, nom, "premiere_apparition")
            if info == nil then
                return "Je ne sais pas."
            end
            return nom.." est vu pour la première fois dans "..info
        end
    end
    ]]--

    if string_reponse == "" then 
        return "Je n'ai pas compris votre question."
    end
    return string_reponse
end

local function creation_reponse(reponse, nom, string_reponse)

end

local function update_memoire(reponse)
    memoire[3]['perso'] = memoire[2]['perso']
    memoire[3]['theme'] = memoire[2]['theme']
    memoire[2]['perso'] = memoire[1]['perso']
    memoire[2]['theme'] = memoire[1]['theme']

    if possede_tag(reponse, "#nom") then
        memoire[1]['perso'] = obtenir_tab_de_mots_par_tag(reponse,"#nom")
    end
    if possede_tag(reponse, "#date_de_creation") then
        memoire[1]['theme'] = "#date_de_creation"
    elseif possede_tag(reponse, "#createur") then
        memoire[1]['theme'] = "#createur"
    elseif possede_tag(reponse, "#createur") then
        memoire[1]['theme'] = "#createur"
    elseif possede_tag(reponse, "#serie") then
        memoire[1]['theme'] = "#serie"
    elseif possede_tag(reponse, "#cameo") then
        memoire[1]['theme'] = "#cameo"
    elseif possede_tag(reponse, "#premiere_apparition") then
        memoire[1]['theme'] = "#premiere_apparition"
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
        print(serialize(ultra_memoire))
        --print(reponse:tostring(taps))
        print(serialize(obtenir_tab_de_mots_par_tag(reponse, "#nom")))
        if not possede_tag(reponse,"#fin") then 
            printBot(preparation_reponse(reponse))
        end
    until possede_tag(reponse,"#fin")
    printBot("Ok, à la prochaine!")
end

main()
