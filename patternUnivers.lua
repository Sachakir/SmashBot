dark = require("dark")

--print(dark.version)
--[[
]]--
local struct = {}

function have_tag(seq, tag)
    return #seq[tag] ~= 0
end

function string_tag(seq, tag)
    if not have_tag(seq, tag) then
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

local P = dark.pipeline()

P:basic()
P:lexicon("#unit", { "centimètres", "mètres", "mètres carrés", "kilomètres" })

--- Premier jeu ou le eprsonnage a fait une apparition
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
        /cre[a-z]*/ #w*? par #w{0,5}? [#cre (/[A-Z][a-z]*/)+ ] ( de | . | /,/ )
]])

P:pattern([[
        introduit #w* en [#date #d ] ( de | . | /,/ )
]])
P:pattern([[
        /^cre[ea][sz]?$/ #w* en [#date #d ] ( de | . | /,/ )
]])

local f = io.open("textes/DKTest.txt", "r")
local line = f:read("*all")

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
