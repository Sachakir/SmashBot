dark = require("dark")

local M = {}

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function lines_from(file)
    if not file_exists(file) then return {} end
    lines = ""
    for line in io.lines(file) do 
        lines = lines..line
    end
    return lines
end

function obtenir_tous_les_textes()
    local p = io.popen('find "'..'textes'..'" -type f')
    local fichiers = {}
    for fichier in p:lines() do
        fichiers[fichier:sub(8,-5)] = lines_from(fichier)
    end
    return fichiers
end

function obtenir_les_lignes_de(personnage)
    local fichiers = obtenir_tous_les_textes()
    local file = fichiers[personnage]
    local lines = lines_from(file)
    return lines
end

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

M.obtenir_tous_les_textes = obtenir_tous_les_textes
M.obtenir_les_lignes_de = obtenir_les_lignes_de
M.ecrire_dans_la_bd = ecrire_dans_la_bd
M.obtenir_objet_de_personnage_par_clef = obtenir_objet_de_personnage_par_clef

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

ecrire_dans_la_bd(test)


return M
