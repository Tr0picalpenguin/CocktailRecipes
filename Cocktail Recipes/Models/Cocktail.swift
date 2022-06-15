//
//  Cocktail.swift
//  Cocktail Recipes
//
//  Created by Scott Cox on 6/13/22.
//

import Foundation

class Cocktail {
    
    enum Keys {
        static let collectionType = "cocktails"
        static let name = "name"
        static let description = "dexcription"
        static let uuid = "uuid"
        static let imageURL = "imageURL"
    }
    
    // MARK: - Properties
    var name: String
    var description: String
    let uuid: String
    var imageURL: URL?
    
    var cocktailData: [String: AnyHashable] {
        [Keys.name: self.name,
         Keys.description: self.description,
         Keys.uuid: self.uuid,
         Keys.imageURL: self.imageURL]
    }
    
    init(name:String, description: String, uuid: String, imageURL: String = "") {
        self.name = name
        self.description = description
        self.uuid = uuid
        self.imageURL = URL(string: imageURL)
    }
}

extension Cocktail {
    
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[Keys.name] as? String,
              let description = dictionary[Keys.description] as? String,
              let imageURL = dictionary[Keys.imageURL] as? String,
              let uuid = dictionary[Keys.uuid] as? String else { return nil }
        
        self.init(name: name,
                  description: description,
                  uuid: uuid,
                  imageURL: imageURL)
    }
}

extension Cocktail: Equatable {
    static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
