dark = require("dark")
data = require("entree_sortie")

local regle_au_revoir = dark.pattern([[
    [#fin
        salut
    ]
]])

local function printBot(message)
    print("[SmashBot]: "..message)
end

local function traitement_reponse(reponse)
    reponse = dark.sequence(reponse)
    regle_au_revoir(reponse)
    print(reponse)
    return reponse
end

function main()
    print("*** SmashBot ***")
    printBot("Salut, je suis SmashBot. Tu as une question pour moi?")
    repeat
        print()
        reponse = io.read()
        reponse = traitement_reponse(reponse)
        printBot("okok.")
    until reponse == "ok"
    printBot("Ok, à la prochaine!")
end

main()
