//
//  Network Controller.swift
//  Cocktail Recipes
//
//  Created by Scott Cox on 6/13/22.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

protocol FirebaseSyncable {
    func save(_ cocktail: Cocktail, with image: UIImage)
    func loadCocktails(completion: @escaping (Result<[Cocktail], FirebaseError>) -> Void)
    func deleteCocktail(cocktail: Cocktail)
    func saveImage(_ image: UIImage, to cocktail: Cocktail, completion: @escaping() -> Void)
    func fetchImage(from cocktail: Cocktail, completion: @escaping (Result<UIImage, FirebaseError>) -> Void)
    func deleteImage(from cocktail: Cocktail)
}

enum FirebaseError: Error {
    case fireBaseError(Error)
    case failedToUnwrapData
    case noDataFound
}

struct FirebaseService: FirebaseSyncable {
    
    let reference = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    func save(_ cocktail: Cocktail, with image: UIImage) {
        saveImage(image, to: cocktail) {
            reference.collection(Cocktail.Keys.collectionType).document(cocktail.uuid).setData(cocktail.cocktailData)
        }
    }
    func loadCocktails(completion: @escaping (Result<[Cocktail], FirebaseError>) -> Void) {
        reference.collection(Cocktail.Keys.collectionType).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.fireBaseError(error)))
            }
            guard let data = snapshot?.documents else {
                completion(.failure(.noDataFound))
                return
            }
            let cocktailsArray = data.compactMap({ $0.data() })
            let cocktails = cocktailsArray.compactMap({ Cocktail(dictionary: $0)})
            completion(.success(cocktails))
        }
    }
    func deleteCocktail(cocktail: Cocktail) {
        reference.collection(Cocktail.Keys.collectionType).document(cocktail.uuid).delete()
    }
    
    func saveImage(_ image: UIImage, to cocktail: Cocktail, completion: @escaping () -> Void) {
        guard let imageData = image.pngData() else { return }
        storage.child("images").child(cocktail.uuid).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            self.storage.child("images").child(cocktail.uuid).downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion()
                    return
                }
                guard let url = url else { return }
                cocktail.imageURL = url
                completion()
            }            
        }
    }
    
    func fetchImage(from cocktail: Cocktail, completion: @escaping (Result<UIImage, FirebaseError>) -> Void) {
        storage.child("images").child(cocktail.uuid).getData(maxSize: 1024 * 1024) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.failedToUnwrapData))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(.fireBaseError(error)))
            }
        }
    }
    
    func deleteImage(from cocktail: Cocktail) {
        storage.child("images").child(cocktail.uuid).delete(completion: nil)
    }
}
