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
        (/^jeu[x]?$/ | /^appar[aiston]*$/ | cameo dans) (video | notamment | dans | pour)* (Amerique | Wii | Nintendo DS | Nintendo | Electronic Arts | Game Boy | Entertainment System)? [#jeux #W+ (#W+ | of #W | "'"s #W| #d)*]
]])
P:pattern([[
        Dans [#jeux #W+ (#W+ | (of | et ) #W | #d)+]
]])



return P
