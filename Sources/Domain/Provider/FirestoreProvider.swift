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
    /// 単一のドキュメントを取得する
    ///
    /// `public/vx/{Collection}/{path}` にドキュメントを取りに行く.
    /// - Parameters:
    ///   - collection: `{Collection}` に入るパス.
    ///   - path: `{path}` に入る `Document` のパス.
    ///   - type: `Document` の型.
    /// - Returns: `Future<T, Error>` を返す.
    func getDocument<T: Decodable>(from collection: FirestoreProvider.Collection, path: String, type: T.Type) -> Future<T, Error>
    
    /// 単一のドキュメントを取得する.
    ///
    /// `public/vx/{Collection}/{path}/{SubCollection}/{subPath}` にドキュメントを取りに行く.
    /// - Parameters:
    ///   - collection: `{Collection}` に入るパス.
    ///   - path: `{path}` に入る `Document` のパス.
    ///   - subCollection: `{SubCollection}` に入るパス.
    ///   - subPath: `{subPath}` に入る `Document` のパス.
    ///   - type: 取得する `Document` の型.
    /// - Returns: `Future<T, Error>` を返す.
    func getDocument<T: Decodable>(from collection: FirestoreProvider.Collection, path: String, subCollection: FirestoreProvider.SubCollection, subPath: String, type: T.Type) -> Future<T, Error>
    
    /// 単一のドキュメントを追加する.
    ///
    /// `public/vx/{Collection}/{path}` にドキュメントを追加する.
    /// - Parameters:
    ///   - collection: `{Collection}` に入るパス.
    ///   - data: ドキュメントとして追加するデータ.
    func setDocument<T: Encodable>(to collection: FirestoreProvider.Collection, data: T) -> Future<Void, Error>
    
    /// 単一のドキュメントを追加する.
    ///
    /// `public/vx/{Collection}/{path}/{SubCollection}/{subPath}` にドキュメントを追加する.
    /// - Parameters:
    ///   - collection: `{Collection}` に入るパス.
    ///   - path: `{path}` に入る `Document` のパス.
    ///   - subCollection: `{SubCollection}` に入るパス.
    ///   - data: ドキュメントとして追加するデータ.
    func setDocument<T: Encodable>(to collection: FirestoreProvider.Collection, path: String, subCollection: FirestoreProvider.SubCollection, data: T) -> Future<Void, Error>
}

public final class FirestoreProvider: FirestoreProviderProtocol {
    
    // MARK: Singleton
    
    public static let shared: FirestoreProvider = .init()
    
    // MARK: Properties
    
    private let db = Firestore.firestore()
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Collection References
    
    private enum Version: String {
        /// DB のバージョン
        case v2 = "v2"
    }
    
    private enum Root: String {
        /// ユーザーがアクセス可能なコレクション.
        case `public` = "public"
        /// 主に開発で使用する予定のコレクション.
        case `private` = "private"
    }
    
    public enum Collection: String {
        /// ユーザー一覧.
        case users = "users"
    }
    
    public enum SubCollection: String {
        /// 勉強のデータ一覧.
        case studies = "studies"
    }
    
    public func getDocument<T: Decodable>(from collection: Collection,
                                          path: String,
                                          type: T.Type) -> Future<T, Error> {
        return Future { [weak self] promise in
            self?.db.collection(Root.public.rawValue)
                .document(Version.v2.rawValue)
                .collection(collection.rawValue)
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
    
    public func getDocument<T: Decodable>(from collection: Collection,
                                          path: String,
                                          subCollection: SubCollection,
                                          subPath: String,
                                          type: T.Type) -> Future<T, Error> {
        return Future { [weak self] promise in
            self?.db.collection(Root.public.rawValue)
                .document(Version.v2.rawValue)
                .collection(collection.rawValue)
                .document(path)
                .collection(subCollection.rawValue)
                .document(subPath)
                .getDocument(completion: { (snapshot, error) in
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
                })
        }
    }
    
    public func setDocument<T: Encodable>(to collection: Collection,
                                          data: T) -> Future<Void, Error> {
        return Future { [weak self] promise in
            do {
                try self?.db.collection(Root.public.rawValue)
                    .document(Version.v2.rawValue)
                    .collection(collection.rawValue)
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
    
    public func setDocument<T: Encodable>(to collection: Collection,
                                          path: String,
                                          subCollection: SubCollection,
                                          data: T) -> Future<Void, Error> {
        return Future { [weak self] promise in
            do {
                try self?.db.collection(Root.public.rawValue)
                    .document(Version.v2.rawValue)
                    .collection(collection.rawValue)
                    .document(path)
                    .collection(subCollection.rawValue)
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
