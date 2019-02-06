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

M.regles = P

return M
