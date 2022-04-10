//
//  Referencable.swift
//  
//
//  Created by Shunya Yamada on 2022/04/06.
//

import FirebaseFirestore

/// Firestore のリファレンスを表す Protocol.
public protocol Referencable {
    associatedtype ReferenceType

    /// ドキュメントへのリファレンスを作成する.
    /// - Returns: 任意のリファレンスの形式.
    func toReference(with db: Firestore) -> ReferenceType
}

/// 単一のドキュメントに対するリファレンスを作成する Protocol.
public protocol DocumentReferencable: Referencable {
    associatedtype ReferenceType = DocumentReference
    func toReference(with db: Firestore) -> DocumentReference
}

/// コレクションに対するリファレンスを作成する Protocol.
public protocol CollectionReferencable: Referencable {
    associatedtype ReferenceType = CollectionReference
    func toReference(with db: Firestore) -> CollectionReference
}

/// クエリを利用したリファレンスを作成する Protocol.
public protocol QueryReferencable: Referencable {
    associatedtype ReferenceType = Query
    func toReference(with db: Firestore) -> Query
}
