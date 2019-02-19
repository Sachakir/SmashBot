dark = require("dark")
data_traitement = require("entree_sortie")

local M = {}

local function obtenir_info_reponse(reponse, nom, info)
    res = data_traitement.obtenir_personnage_par_nom(data,nom)
    res = data_traitement.obtenir_objet_de_personnage_par_clef(res, info)
    return res
end

function dateCreation(data, nom, string_reponse)
    for k,v in pairs(nom) do
        info = obtenir_info_reponse(data,v,"date")
        if info == nil then
            string_reponse = string_reponse.."Je ne connais pas la date de création de "..v..". "
        else
            string_reponse = string_reponse.."La date de creation de "..v.." est "..info..". "
        end
    end
    return string_reponse
end

function Createur(data, nom, string_reponse)
    for k,v in pairs(nom) do
        info = obtenir_info_reponse(data,v,"createur")
        if info == nil then
            string_reponse = string_reponse.."Je ne connais pas le createur de "..v..". "
        else
            string_reponse = string_reponse.."Le/La createur/creatrice de "..v.." est "..info..". "
        end
    end
    return string_reponse
end

function Serie(data, nom, string_reponse)
    for k,v in pairs(nom) do
        info = obtenir_info_reponse(data,v,"serie")
        if info == nil then
            string_reponse = string_reponse.."Je ne connais pas la serie de "..v..". "
        else
            string_reponse = string_reponse.."La serie de "..v.." est "..info..". "
        end
    end
    return string_reponse
end

function Cameo(data, nom, string_reponse)
    for k,v in pairs(nom) do
        info = obtenir_info_reponse(data,v,"cameo")
        if info == nil then
            string_reponse = string_reponse.."Je ne connais pas le(s) cameo(s) de "..v..". "
        else
            string_reponse = string_reponse.."le(s) cameo(s) de "..v.." est/sont "..info..". "
        end
    end
    return string_reponse
end

function PremiereApparition(data, nom, string_reponse)
    for k,v in pairs(nom) do
        info = obtenir_info_reponse(data,v,"premiere_apparition")
        if info == nil then
            string_reponse = string_reponse.."Je ne sais pas où "..v.." est apparu pour la première fois. "
        else
            string_reponse = string_reponse.."la première apparition de "..v.." est dans "..info..". "
        end
    end
    return string_reponse
end

function Ami(data, nom, string_reponse)
    for k,v in pairs(nom) do
        info = obtenir_info_reponse(data,v,"ami")
        if info == nil then
            string_reponse = string_reponse.."Je ne sais pas qui est l'ami de "..v..". "
        else
            string_reponse = string_reponse.."l'ami de "..v.." est "..info..". "
        end
    end
    return string_reponse
end

M.dateCreation = dateCreation
M.Createur = Createur
M.Serie = Serie
M.Cameo = Cameo
M.PremiereApparition = PremiereApparition
M.Ami = Ami

return M
