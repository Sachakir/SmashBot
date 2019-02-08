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

P:pattern([[
        (heros|personnage|symbole|protagoniste) #w*? (serie|franchise|saga) [#serie (/^[A-Z][A-Za-z]*$/) #w*?  ] (et | dans | "de" | "." | ",")
    ]
]])

--personnage #w*? (serie|franchise) [#serie (/[A-Z][a-z]*/) (/[A-Za-z][a-z]*/)+?  ] ( de | /[.]/ | /[,]/)

P:pattern([[
        introduit #w*? dans #w*? [#uni (/[A-Z][a-z]*/) (/[A-Za-z][a-z]*/)+? ] ( de | /[.]/ | /[,]/)
]])

--introduit #w* dans /%u*/ [#uni #W*(de|/[.,]/)

P:pattern([[
    [#uni2
        suite #w*? #W* /[.,]/
    ]
]])

P:pattern([[
        [#serie #W ] #w+? (heros|personnage|symbole|protagoniste)  #w*? (serie|franchise|saga) eponyme
    ]
]])

P:pattern([[
        /[a-z]ppar[a-z]*/ #w*? dans #w*? [#appearance (/^[A-Z][A-Za-z]*$/) #w*? ] ("et" | "dans" | "de" | "." | ",")
]])

P:pattern([[
        cameo dans #w*? [#cameo #title ] #afterTitle
]])

local regle_appearance2 = dark.pattern([[
    [#cameo
        cameo dans #w* #W*/[.,]/
    ]
]])

return P
