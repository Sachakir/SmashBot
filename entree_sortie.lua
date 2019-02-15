dark = require("dark")

local M = {}

-- verifie si le fichier existe
function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

-- returne les lignes de texte d'un fichier
function lines_from(file)
    if not file_exists(file) then return {} end
    lines = ""
    for line in io.lines(file) do 
        lines = lines..line
    end
    return lines
end

-- retourne la liste contenant les fichiers de texte
function obtenir_tous_les_textes()
    local p = io.popen('find "'..'textes'..'" -type f')
    local fichiers = {}
    for fichier in p:lines() do
        fichiers[fichier:sub(8,-5)] = lines_from(fichier)
    end
    return fichiers
end

function obtenir_tous_les_noms()
    local p = io.popen('find "'..'textes'..'" -type f')
    local nom = {}
    for fichier in p:lines() do
        table.insert(nom,fichier:sub(8,-5))
    end
    return nom
end

-- retourne les lignes de texte d'un personnage
function obtenir_les_lignes_de(personnage)
    local fichiers = obtenir_tous_les_textes()
    return fichiers[personnage]
end

-- ecriture de l objet contenant les informations dans la database
function ecrire_dans_la_bd(objet)
    local db_file = io.open("Base_de_donnees/BD.lua", "wb")
    io.output(db_file)
    io.write("return "..serialize(objet))
    io.close(db_file)
end

function obtenir_objet_de_personnage_par_clef(personnage, clef)
    if type(personnage) == "string" then return end
    for k,v in pairs(personnage) do
        if k == clef then
            return v
        else
            resultat = obtenir_objet_de_personnage_par_clef(v,clef)
            if resultat ~= nil then
                return resultat
            end
        end
    end
    return
end

function obtenir_personnage_par_nom(data, nom)
    for k,v in pairs(data) do
        if k == nom then
            return v
        end
    end
    return nil
end

local function obtenir_boolean_par_clef_valeur(noeud, clef, valeur)
    if type(noeud) == "string" then return false end
    for k,v in pairs(noeud) do
        if k == clef then
            if type(v) == "string" and v == valeur then
                return true
            end
        else
            resultat = obtenir_boolean_par_clef_valeur(v, clef, valeur)
            if resultat ~= false then
                return resultat
            end
        end
    end
    return false
end

function obtenir_liste_persos_avec_clef_valeur(data, clef, valeur)
    liste_persos = {}
    for k,v in pairs(data) do
        if obtenir_boolean_par_clef_valeur(v, clef, valeur) then
            table.insert(liste_persos, k)
        end
    end
    return liste_persos
end

M.obtenir_tous_les_textes = obtenir_tous_les_textes
M.obtenir_les_lignes_de = obtenir_les_lignes_de
M.ecrire_dans_la_bd = ecrire_dans_la_bd
M.obtenir_objet_de_personnage_par_clef = obtenir_objet_de_personnage_par_clef
M.obtenir_tous_les_noms = obtenir_tous_les_noms
M.obtenir_liste_persos_avec_clef_valeur = obtenir_liste_persos_avec_clef_valeur
M.obtenir_personnage_par_nom = obtenir_personnage_par_nom

test = {
    ["Mario"] = {
        ["Nom"] = "Mario",
        ["Couleur"] = "rouge",
        ["Physique"] = {
            ["Nom"] = "Mario",
            ["Vetement"] = {
                ['slip'] = 'ok',
            },
        },
        ["date"] = "1981",
        ["createur"] = "Miyamoto",
    },
}

--ecrire_dans_la_bd(test)
--data = require("Base_de_donnees/BD")
--print(serialize(obtenir_personnage_par_nom(data, "Mario")))
--print(serialize(obtenir_liste_persos_avec_clef_valeur(data, "cameo", "Super Smash Bros")))

return M
