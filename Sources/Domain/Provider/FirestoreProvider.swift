//
//  FirestoreProvider.swift
//  
//
//  Created by Shunya Yamada on 2021/07/08.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

public protocol FirestoreProviderProtocol: AnyObject {
    
}

public final class FirestoreProvider: FirestoreProviderProtocol {
    
    // MARK: Singleton
    
    public static let shared: FirestoreProvider = .init()
    
    // MARK: Properties
    
    private let db = Firestore.firestore()
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Collection References
    
    public enum CollectionRefs: String {
        case studies = "studies"
        case users = "users"
    }
    
    /// 単一のドキュメントを取得する
    public func getDocument<T: Decodable>(from collection: CollectionRefs, path: String, type: T.Type) -> Future<T, Error> {
        return Future { [weak self] promise in
            self?.db.collection(collection.rawValue)
                .document(path)
                .getDocument { (snapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else if let data = snapshot?.data() {
                        do {
                            let decoded = try Firestore.Decoder().decode(T.self, from: data)
                            promise(.success(decoded))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
        }
    }
    
    public func setDocument<T: Encodable>(to collection: CollectionRefs, data: T) -> Future<Void, Error> {
        return Future { [weak self] promise in
            do {
                try self?.db.collection(collection.rawValue)
                    .document()
                    .setData(from: data) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
            } catch {
                promise(.failure(error))
            }
        }
    }
}
