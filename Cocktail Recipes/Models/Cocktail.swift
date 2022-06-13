//
//  Cocktail.swift
//  Cocktail Recipes
//
//  Created by Scott Cox on 6/13/22.
//

import Foundation

class Cocktail {
    
    var name: String
    var description: String
    let uuid: String
    
    var cocktailData: [String: AnyHashable] {
    ["name": self.name,
     "description": self.description,
     "uuin": self.uuid]
    }
    
    init(name:String, description: String, uuid: String) {
        self.name = name
        self.description = description
        self.uuid = uuid
    }
}

extension Cocktail: Equatable {
    static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
