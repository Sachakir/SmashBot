dark = require("dark")

local P = dark.pipeline()

P:basic()
P:lexicon("#unit", { "centimètres", "mètres", "mètres carrés", "kilomètres" })

--- Premier jeu ou le personnage a fait une apparition
P:pattern([[
        introduit #w{1,10}? [#fa #W+ ] #w{0,10}? | ( #d | de | "." | "," )
]])
P:pattern([[
        premiere apparition #w{1,10}? [#fa #W+ ] #w{0,10}? | ( #d | de | "." | "," )
]])
P:pattern([[
        premiere apparition #w{1,5}? jeux de premiere [#fa generation #W+ ] #w{0,10}? | ( #d | "(" | de | "." | "," )
]])
P:pattern([[
        issu du jeu [#fa #W+ ] #w{0,10}? | ( #d | de | "." | "," )
]])

---introduit #w+? [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ )
---introduit /^%u/+ [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ ) 

--- Nom du createur du personnage
P:pattern([[
        /[cC]re[a-z]*/ #w*? par #w{0,5}? [#cre (/[A-Z][a-z]*/)+ ] #w{0,6}? ( de | "." | "," )
]])

--- Date de creation du personnage
P:pattern([[
        introduit #w* en [#date #d ] ( de | . | /,/ )
]])
P:pattern([[
        /^cre[ea][sz]?$/ #w{1,8}? en [#date #d ] ( de | "." | "," )
]])
P:pattern([[
        premiere apparition #w{0,12}? "," sorti en [#date #d ] ","
]])
P:pattern([[
        apparu #w{0,12}? ( #p | #d )*? #w{0,3}? "(" [#date #d ] 
]])
P:pattern([[
        apparu #w{0,8}? en [#date #d] avec
]])
P:pattern([[
        issu du jeu #W+ "(" [#date #d]
]])
P:pattern([[
        compagnon de #W+ depuis #W+ "(" [#date #d]
]])
P:pattern([[
        debuts dans #w{0,4}? #W+ en [#date #d]
]])
P:pattern([[
        celebre #w{0,6}? #W+ "(" [#date #d]
]])
P:pattern([[
        vu le jour #w{0,6}? #W+ en [#date #d]
]])
P:pattern([[
        /^[Dd]epuis$/ ses debuts en [#date #d]
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
