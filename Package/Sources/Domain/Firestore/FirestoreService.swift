//
//  FirestoreService.swift
//  
//
//  Created by Shunya Yamada on 2022/04/06.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

public struct FirestoreService {

    /// Firestore のシングルトンインスタンス.
    public var db: () -> Firestore

    /// 任意のドキュメントを取得する.
    public var document: (_ reference: DocumentReference) -> Future<DocumentSnapshot, Error>

    /// 単一のドキュメントを追加する.
    public var addDocument: (_ reference: DocumentReference, _ data: [String: Any], _ merge: Bool) -> Future<Void, Error>

    /// 任意のコレクションからドキュメント一覧を取得する.
    public var documents: (_ reference: CollectionReference) -> Future<QuerySnapshot, Error>

    /// 任意のクエリでドキュメント一覧を取得する.
    public var query: (_ query: Query) -> Future<QuerySnapshot, Error>

    /// リファレンスから任意のドキュメントを取得する.
    public func document<T: DocumentReferencable, U: Decodable>(for referencable: T, type: U.Type) -> AnyPublisher<U, Error> {
        let reference = referencable.toReference(with: db())
        let decoder = Firestore.Decoder()
        return document(reference)
            .tryMap { try decoder.decode(type, from: $0.data() ?? [:], in: reference) }
            .eraseToAnyPublisher()
    }

    /// リファレンスにドキュメントを追加する.
    public func addDocument<T: DocumentReferencable, U: Encodable>(to referencable: T, data: U, merge: Bool) -> AnyPublisher<Void, Error> {
        let reference = referencable.toReference(with: db())
        let encoder = Firestore.Encoder()
        return Just(data)
            .tryMap { try encoder.encode($0) }
            .flatMap { addDocument(reference, $0, merge) }
            .eraseToAnyPublisher()
    }

    /// リファレンスのコレクションからドキュメント一覧を取得する.
    public func documents<T: CollectionReferencable, U: Decodable>(for referencable: T, type: U.Type) -> AnyPublisher<[U], Error> {
        let reference = referencable.toReference(with: db())
        let decoder = Firestore.Decoder()
        return documents(reference)
            .tryMap { try $0.documents.map { document in try decoder.decode(type, from: document.data()) } }
            .eraseToAnyPublisher()
    }

    /// クエリからドキュメント一覧を取得する.
    public func documents<T: QueryReferencable, U: Decodable>(for referencable: T, type: U.Type) -> AnyPublisher<[U], Error> {
        let reference = referencable.toReference(with: db())
        let decoder = Firestore.Decoder()
        return query(reference)
            .tryMap { try $0.documents.map { document in try decoder.decode(type, from: document.data()) } }
            .eraseToAnyPublisher()
    }
}

public extension FirestoreService {

    static func live(
        db: Firestore = Firestore.firestore()
    ) -> Self {
        return Self.init(
            db: {
                return db
            },
            document: { reference in
                return reference.getDocument()
            },
            addDocument: { reference, data, merge in
                return reference.setData(data, merge: merge)
            },
            documents: { reference in
                return reference.getDocuments()
            },
            query: { query in
                return query.getDocuments()
            }
        )
    }
}

