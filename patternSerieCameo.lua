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

-- Serie principale du personnage
P:pattern([[
        serie [#serie #W+ (of #W)* ]
]])

-- Apparition du personnage dans des jeux
P:pattern([[
        (/^jeu[x]?$/ | /^apparition[s]?$/ | cameo dans) #w{0,5}? ( Nintendo DS | Electronic Arts | Game Boy | Entertainment System)* [#jeux #W+ (#W+ | of #W | #d)?]
]])
P:pattern([[
        Dans [#jeux #W+ (#W+ | (of | et ) #W | #d)+]
]])



return P
