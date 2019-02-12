dark = require("dark")
data_traitement = require("entree_sortie")

local M = {}
local P = dark.pipeline()

-- Jeux principaux
-- Date de création
-- Createur

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
        /^cree?e?s?$/ | creation | createur
    ]
]])

P:pattern([[
    [#date_de_creation
        #temps .{0,4} #creation 
    ]
]])

P:pattern([[
    [#createur
        /^[Qq]ui$/ .{0,4} #creation
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
        (/^[Qq]uel$/ .{0,4} #monde) | (/^[Oo]u$/ .{0,2} /vien[nst]$/)
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
        (/^[Qq]uel$/ #monde .{0,3} #apparaitre) | (/^[Oo]u$/ .{0,3} #apparaitre)
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

M.regles = P

return M
