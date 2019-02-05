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

---introduit #w+? [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ )
---introduit /^%u/+ [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ ) 

--- Nom du createur du personnage
P:pattern([[
        /cre[a-z]*/ #w*? par #w{0,5}? [#cre (/[A-Z][a-z]*/)+ ] #w{0,6}? ( de | "." | "," )
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
