//
//  Network Controller.swift
//  Cocktail Recipes
//
//  Created by Scott Cox on 6/13/22.
//

import Foundation
import Firebase

class NetworkController {
    
    let reference = Firebase.Database.database().reference()
    
    func save(cocktails: [Cocktail]) {
        let encodedCocktails = cocktails.compactMap({[$0.uuid : $0.cocktailData]})
        reference.child("cocktails").setValue(encodedCocktails)
    }
    
    func update(cocktail: Cocktail) {
        reference.child("cocktails").updateChildValues([cocktail.uuid : cocktail.cocktailData])
    }
}
