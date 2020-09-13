# Résolution de Sudoku en Ruby

## Préambule

Ce projet n'a pour ambition que de faire passer le temps :)g

## Use case

Résoudre en moins de 3 secondes n'importe quelle grille de Sudoku.

## Limitation

L'algorithme prend en entrée une grille de Sudoku qui admet au moins une solution.

Dans le cas où la grille ne respecte pas cette condition, le comportement est indéfini.

## Algorithme utilisé

La résolution de la grille de Sudoku se déroule en deux phases :
1. **Phase empirique** (systématique) : on tente de compléter toutes les cases "vides" à partir des informations contenues dans les cases déjà complétées. 
2. **Phase exploratoire** (le cas échéant) : [Algorithme de backtracking (🇬🇧)](https://en.wikipedia.org/wiki/Backtracking) ([Retour sur trace (🇫🇷)](https://fr.wikipedia.org/wiki/Retour_sur_trace))