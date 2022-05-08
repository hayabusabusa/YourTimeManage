//
//  StudiesCollectionReference.swift
//  
//
//  Created by Shunya Yamada on 2022/05/08.
//

import FirebaseFirestore
import Foundation

public struct StudiesCollectionReference: CollectionReferencable {

    let userID: String

    public func toReference(with db: Firestore) -> CollectionReference {
        return db.collection("users/\(userID)/studies")
    }
}
