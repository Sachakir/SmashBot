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

local title = dark.pattern([[
    [#title
        (/[A-Z][a-z]*/) (/[A-Za-z][a-z]*/)+? 
    ]
]])

local afterTitle = dark.pattern([[
    [#afterTitle
        ( de | /[.]/ | /[,]/)
    ]
]])

local regle_serie = dark.pattern([[    
        (heros|personnage|symbole|protagoniste) #w*? (serie|franchise|saga) [#serie (/^[A-Z][A-Za-z]*$/) #w*?  ] (et | dans | "de" | "." | ",")
    ]
]])

--personnage #w*? (serie|franchise) [#serie (/[A-Z][a-z]*/) (/[A-Za-z][a-z]*/)+?  ] ( de | /[.]/ | /[,]/)

local regle_universe = dark.pattern([[
        introduit #w*? dans #w*? [#uni (/[A-Z][a-z]*/) (/[A-Za-z][a-z]*/)+? ] ( de | /[.]/ | /[,]/)
]])

--introduit #w* dans /%u*/ [#uni #W*(de|/[.,]/)

local regle_universe2 = dark.pattern([[
    [#uni2
        suite #w*? #W* /[.,]/
    ]
]])

local regle_appearance = dark.pattern([[
        /[a-z]ppar[a-z]*/ #w*? dans #w*? [#appearance (/^[A-Z][A-Za-z]*$/) #w*? ] ("et" | "dans" | "de" | "." | ",")
]])

local regle_cameo = dark.pattern([[
        cameo dans #w*? [#cameo #title ] #afterTitle
]])

local regle_appearance2 = dark.pattern([[
    [#cameo
        cameo dans #w* #W*/[.,]/
    ]
]])


local f = io.open("Link.txt", "r")
local line = f:read("*all")

local seq = dark.sequence(line)
P(seq)
title(seq)
afterTitle(seq)
regle_serie(seq)
regle_universe(seq)
regle_appearance(seq)

print(seq)
print(serialize(seq[3]))
for k,v in pairs(seq[3]) do
    print(k, v)
end

local taps = {
    ["#serie"] = "yellow",
    ["#appearance"] = "blue",
    ["#uni"] = "red",
}

print(seq:tostring(taps))
print(serialize(seq["#monument"]))
print(have_tag(seq, "#monument"))
print(string_tag(seq, "#monument"))

