dark = require("dark")
data_traitement = require("entree_sortie")

local M = {}
local P = dark.pipeline()

function obtenir_tab_de_mots_par_tag(seq, tag)
    if not possede_tag(seq, tag) then
        return
    end
    liste = {}
    for k,v in pairs(seq[tag]) do
        local pos = v
        local deb, fin = pos[1], pos[2]
        
        local res = {}
        for i = deb,fin do
            res[#res+1] = seq[i].token
        end
        
        res = table.concat(res, " ")
        table.insert(liste, res)
    end
    
    return liste
end

-- Basic
P:basic()

-- Nom perso
P:lexicon("#nom", obtenir_tous_les_noms())

-- Date de création & Createur
P:pattern([[
    [#temps
        /^[Qq]uand$/ | /^[Dd]ate$/
    ]
]])

P:pattern([[
    [#creation
        /^cree?e?s?$/ | creation | /^createurs?$/
    ]
]])

P:pattern([[
    [#date_de_creation
        #temps .{0,4} #creation 
    ]
]])

P:pattern([[
    [#createur
        (/^[Qq]ui$/ .{0,4} #creation) | createur
    ]
]])

-- Serie
P:pattern([[
    [#monde
        /^[Ss]erie$/ | /^[Uu]nivers$/ | /^[Mm]onde$/
    ]
]])

P:pattern([[
    [#serie
        (/^[Qq]uell?e?$/ .{0,4} #monde) | (/^[Oo]u$/ .{0,2} /vien[nst]$/)
    ]
]])

-- Cameo
P:pattern([[
    [#apparaitre
        /^apparue?$/ | /^voi[tsr]$/ | /^vue?$/ | /^[Aa]pparition$/
    ]
]])

P:pattern([[
    [#cameo
        (/^[Qq]uel$/ #monde .{0,3} #apparaitre) | (/^[Oo]u$/ .{0,3} #apparaitre) | /^[cC]ameos?$/
    ]
]])

-- Premiere apparition
P:pattern([[
    [#premiere
        /^premiere?$/
    ]
]])

P:pattern([[
    [#premiere_apparition
        #temps .{0,4} #apparaitre .{0,4} #premiere
    ]
]])

P:pattern([[
    [#premiere_apparition
       #premiere .{0,4} #apparaitre
    ]
]])

-- Lien Famille
P:pattern([[
    [#ami
        /^[aA]mie?s?$/
    ]
]])


-- Physique
P:pattern([[
    [#physiqueGeneral
        /^[Dd][ée]cri[ts]?$/ moi #nom    
    ]
]])
-- /^[Dd][ée]cri[ts]?$/


-- Liste de personnages
P:pattern([[
    [#all
        /^[Tt]ou[st]$/ | /^[Tt]oute?s?$/ 
    ]
]])

P:pattern([[
    [#personnage
        /^[Pp]ersonnages?$/ | /^[Pp]ersos?$/
    ]
]])

P:pattern([[
    [#question_persos
        (/^[Qq]uels?$/ .{0,3} #personnage) | (#all .{0,2} #personnage)
    ]
]])

-- Regle pluralité persos
P:pattern([[
    [#ET
        #nom et #nom
    ]
]])

M.regles = P
M.obtenir_tab_de_mots_par_tag = obtenir_tab_de_mots_par_tag

return M
