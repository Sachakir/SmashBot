# SmashBot
Projet SmashBot ET5. 
Doisneau Vincent / Jardet Quentin / Kirillov Alexandre / Le Pallec Florian / Mayaki Oummar

########## Base de Donnees ##########
Base_de_donnes/BD.lua
Fichier contenant les informations stockées par notre analyseur.
Les informations disponibles actuellement sont :
- createur : Createur du personnage
- serie : Nom de la serie du personnage
- cameo : Apparitions du personnage en dehors de sa serie
- date : Date de creation du personnage
Toutes les informations ne sont pas encore extraites pour chacun des personnages comme il s'agit d'une premiere version.

Veuillez aussi noter que des analyses concernant les relations des personnages ainsi que leurs caractéristiques physiques sont écrites dans les fichiers lua (relations.lua et physique.lua)

########## Fichiers de Patterns ##########
patternUnivers.lua
relations.lua
physique.lua
serieCameo.lua

########## Lancement du Bot ##########
Commande a utiliser : ./dark Smashbot.lua

Le bot va etre lance et vous pourrez lui poser differentes questions.

Pour l'instant il est possible de poser des questions pour recuperer des informations concernant :
- Createur d un personnage
- Date de creation d un personnage

Exemple de questions possibles :
- Quand a ete cree Fox
- Qui a cree Yoshi
- Qui a cree Mario

L'analyseur etant encore en developpement, les questions sont dont assez limites.
Comme la BD n'est pas remplit pour tous les personnges, il affichera une erreur si l'information n'est pas présente.