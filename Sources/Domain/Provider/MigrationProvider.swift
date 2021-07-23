//
//  MigrationProvider.swift
//  
//
//  Created by Shunya Yamada on 2021/07/04.
//

import Foundation

/// 型消去用の `MigratorProtocol`.
public protocol AnyMigratorProtocol {
    func _isNeedMigration() -> Bool
    func _migration(completion: @escaping (Result<Any, Error>) -> Void)
}

public protocol MigratorProtocol: AnyMigratorProtocol {
    associatedtype MigrationOutput
    /// 非同期処理のために並列のキューを持っておく
    var dispatchQueue: DispatchQueue { get }
    /// マイグレーションが必要かどうかを返す
    func isNeedMigration() -> Bool
    /// 実施するマイグレーションの内容
    func migration(completion: @escaping (Result<MigrationOutput, Error>) -> Void)
}

public extension MigratorProtocol {
    func _isNeedMigration() -> Bool {
        return isNeedMigration()
    }
    
    func _migration(completion: @escaping (Result<Any, Error>) -> Void) {
        migration { (result) in
            switch result {
            case .success(let output):
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public final class MigrationProvider {
    
    // MARK: Singletone
    
    public static let shared: MigrationProvider = .init()
    
    // MARK: Properties
    
    private var migrators: [AnyMigratorProtocol] = []
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Migration
    
    public func setMigrators<T: AnyMigratorProtocol>(_ migrators: [T]) {
        self.migrators = migrators
    }
    
    /// 特定のマイグレーション処理を行う
    /// - Parameters:
    ///   - version: 実行したいマイグレーションの番号
    ///   - completion: 完了時は `Result<Void, Error>` が返される
    public func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        migrators.forEach { migrator in
            guard migrator._isNeedMigration() else {
                return
            }
            migrator._migration { result in
                if case .failure(let error) = result {
                    completion(.failure(error))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
}
