dark = require("dark")

local P = dark.pipeline()

P:basic()
P:lexicon("#unit", { "centimètres", "mètres", "mètres carrés", "kilomètres" })

--- Premier jeu ou le personnage a fait une apparition
P:pattern([[
        introduit #w{1,10}? [#fa #W+]
]])
-- P:pattern([[
        -- premiere apparition #w{1,10}? [#fa #W+]
-- ]])
P:pattern([[
        premiere apparition (#w){0,10}? dans [#fa #W+]
]])
P:pattern([[
        premiere apparition #w{1,5}? jeux de premiere [#fa generation #W+]
]])
P:pattern([[
        premiere fois dans #w{0,5}? [#fa #W+]
]])
P:pattern([[
        debuts dans [#fa #W+]
]])
P:pattern([[
        issu du jeu [#fa #W+]
]])
P:pattern([[
        present dans #w{0,5}? [#fa #W+] depuis
]])
---introduit #w+? [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ )
---introduit /^%u/+ [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ ) 

--- Nom du createur du personnage
P:pattern([[
        (/[cC]onc[a-z]*/ | /[cC]re[a-z]*/) #w*? par #w{0,5}? [#cre #W+]
]])

--- Date de creation du personnage
P:pattern([[
        (/^cre[ea][sz]?$/ | debuts | vu le jour | issu | premiere (fois | apparition) | introduit | apparu) (#w | "," | #W+){0,12}? (en | "(")? [#date #d ]
]])

P:pattern([[
        compagnon de #W+ depuis #W+ "(" [#date #d]
]])
P:pattern([[
        celebre #w{0,6}? #W+ "(" [#date #d]
]])


local taps = {
    ["#fa"] = "green",
	["#cre"] = "red",
	["#date"] = "blue",
}

--print(seq:tostring(taps))
--print(serialize(seq["#cre"]))
--test = serialize(seq[292])
--print(test["token"])
--print(string_tag(seq, "#cre"))
--print(have_tag(seq, "#monument"))
--print(string_tag(seq, "#monument"))

return P
