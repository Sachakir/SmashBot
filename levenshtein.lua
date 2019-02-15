local M = {}

function distance_levenshtein(chaine1, chaine2)
    d = {}
    tailleChaine1 = string.len(chaine1)
    tailleChaine2 = string.len(chaine2)
    coutSubstitution = 0
    for i = 0,tailleChaine1 do
        d[i] = {}
        d[i][0] = i
    end

    for j = 0,tailleChaine2 do
        d[0][j] = j
    end

    for i = 1,tailleChaine1 do
        for j = 1,tailleChaine2 do

            if string.sub(chaine1, 1, i-1) == string.sub(chaine2, 1, j-1) then
                coutSubstitution = 0
            else
                coutSubstitution = 1
            end

            d[i][j] = math.min(d[i-1][j]+1,d[i][j-1]+1,d[i-1][j-1]+coutSubstitution)

            if i > 1 and j > 1 and string.sub(chaine1, 1, i) == string.sub(chaine2, 1, j-1) and string.sub(chaine1, 1, i-1) == string.sub(chaine2, 1, j) then
                d[i][j] = math.min(d[i][j],d[i-2][j-2]+coutSubstitution)
            end

        end
    end
    return d[tailleChaine1][tailleChaine2]
end


M.distance_levenshtein = distance_levenshtein

return M