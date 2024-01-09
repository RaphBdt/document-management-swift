# Réponses

# 1-Environnement
## Exercice 1
### Structure d'un projet iOS

- Les targets
Il s'agit d'un ensemble de configurations (cible de compilation, point d'entrée) qui répond à une cible précise. Exemple : on pourrait avoir un target pour WatchOS, Siri...

- Les fichiers
1) AppDelegate : Init APP
2) SceneDelegate : UI Delegate
3) ViewController : Notre code

Le Main.StoryBoard est une interface. C'est ce que notre app présente à l'écran quand elle est en cours d'eécution.

Info.plist : Paramètre de l'app (nom, etc...)

- Les assets
Toutes les ressources utiles à notre application telles que les images, les médias, les icons, les fonts...

## Exercice 2
### Des raccourcis
- A quoi sert le raccourci Cmd + R ?
Il sert a relancer le build de l'application

- A quoi sert le raccourci Cmd + Shift + O ?
Il sert à ouvrir un fichier en cherchant son nom (pratique sur des projets qui deviennent volumineux)

- Le raccourci pour indenter le code ?
le raccourci est ctrl+i (de préférence il vaut mieux selectionner tout le texte avant, donc faire cmd+a)

- Le raccourci pounr commenter la sélecttion ?
Le raccourci est cmd+/

# 3 - Delegation
## Exercice 1
- L'intérêt d'une variable statique en prog ?
ici la variable statiqueest intéressante car elle nous permet d'avoir les mêmes fausse données partout ou nous allons appeler notre struct

## Exercice 2
- Expliquer pourquoi dequeueReusableCell est important pour les performances de l’application.
Il est important car il permet d'alléger la mémoire. La fonction permet à la vue de ne générer qu'un certain nombre de cellules, qui lorsqu'elles sortent de la vue perdent leurs données et sont ensuite transportées de l'autre côté pour être ré-employés et re-remplies avec de nouvelles informations.

# 4 - Navigation
## Exercice 1
- Que venont nous de faire en réalité ? Quel est le rôle du NavigationController ?
Gérer une pile qui peut contenir plusieurs ViewControllers, mais n'en afficher qu'un seul à l'écran

- Est-ce que la NavigationBar est la même chose que le NavigationController ?
La NavigationBar est un élément de l'interface qui permet de naviguer entre les pages au clique.

# 6 - Ecran Détail
## Exercice 1
- Expliquer ce qu’est un Segue et à quoi il sert.
  un Segue est une transition entre deux vues, un Segue définit le lien entre le View Controller source (d'où la transition commence) et le View Controller de destination (où la transition aboutit).

## Exercice 2
- Qu’est-ce qu’une constraint ? A quoi sert-elle ? Quel est le lien avec AutoLayout ?
 une règle qui définit comment un élément se place et se comporte dans une interface. AutoLayout est un mécanisme de disposition automatique qui permet de créer des interfaces utilisateur flexibles et adaptables à différentes tailles d'écran et orientations.

# 9 - QLPreview
## Exercice 1
- Pourquoi serait-il plus pertinent de changer l’accessory de nos cellules pour un disclosureIndicator ?
Il serait plus judicieux d'utiliser le disclosureIndicator car il est utilisé pour indiquer qu'il y a une hiérarchie de contenue. Utile si on doit permettre aux utilisateurs d'accéder aux sous-vues d'une liste ou d'une ligne de tableau

# 10 - Importations
## Questions
- Qu'est-ce qu'un #selector en swift ?
#selector sert à avoir une référence d'une méthode ou une fonction lors de la mise en place d'actions avec de la gestion d'événements

- Que représente .add dans notre appel ?
 .add indique un bouton d'ajout prédéfini. Différentes valeurs sont possibles comme .done, .edit, etc., chacune représentant un style de bouton prédéfini.
  
- Expliquez également pourquoi XCode vous demande de mettre le mot clé @objc devant la fonction ciblée par le #selector
La plupart des processus d'action d'interface utilisateur, tels que les boutons et les gestes, sont basés sur Objective-C.

- Peut-on ajouter plusieurs boutons dans la barre de navigation ? Si oui, comment en code ?
créer un tableau de UIBarButtonItem et les attribuer à la propriété rightBarButtonItems ou leftBarButtonItems de la propriété navigationItem

Exemple --> 
let editImage    = UIImage(named: "plus")!
  let searchImage  = UIImage(named: "search")!

  let editButton   = UIBarButtonItem(image: editImage,  style: .Plain, target: self, action: "didTapEditButton:")
  let searchButton = UIBarButtonItem(image: searchImage,  style: .Plain, target: self, action: "didTapSearchButton:")

  navigationItem.rightBarButtonItems = [editButton, searchButton]

- A quoi sert la fonction defer  ?
A éxécuter du code, peu importe sa taille / son importance avant que le scope dans lequel il est ne disparaisse
