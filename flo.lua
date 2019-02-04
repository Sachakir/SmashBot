dark = require("dark")

--print(dark.version)
--[[
]]--

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


--introduit #w* dans /%u*/ [#uni #W*(de|/[.,]/)

local regle_firstAppearance = dark.pattern([[
        introduit #w*? [#fa (/[A-Z][a-z]*/)+ ] ( de | . | /,/ ) 
]])
local regle_creator = dark.pattern([[
        /cre[a-z]*/ #w*? par [#cre (/[A-Z][a-z]*/)+ ] ( de | . | /,/ )
]])

local regle_dateCreation = dark.pattern([[
        introduit #w* en [#date #d ] ( de | . | /,/ )
]])
local regle_dateCreation2 = dark.pattern([[
        /cre[a-z]*/ #w* en [#date #d ] ( de | . | /,/ )
]])

local f = io.open("textes/floTests/DK.txt", "r")
local line = f:read("*all")

local seq = dark.sequence(line)
P(seq)
regle_firstAppearance(seq)
regle_creator(seq)
regle_dateCreation(seq)
regle_dateCreation2(seq)


local taps = {
    ["#fa"] = "green",
	["#cre"] = "red",
	["#date"] = "blue",
}

print(seq:tostring(taps))
print(serialize(seq["#monument"]))
print(have_tag(seq, "#monument"))
print(string_tag(seq, "#monument"))

