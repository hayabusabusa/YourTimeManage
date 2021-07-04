//
//  MigrationProvider.swift
//  
//
//  Created by Shunya Yamada on 2021/07/04.
//

import Foundation

public protocol MigratorProtocol {
    associatedtype MigrationOutput
    /// 非同期処理のために並列のキューを持っておく
    var dispatchQueue: DispatchQueue { get }
    /// マイグレーションが必要かどうかを返す
    func isNeedMigration() -> Bool
    /// 実施するマイグレーションの内容
    func migration(completion: @escaping (Result<MigrationOutput, Error>) -> Void)
}


public final class MigrationProvider {
    
    // MARK: Singletone
    
    public static let shared: MigrationProvider = .init()
    
    // MARK: Initializer
    
    private init() {}
    
    /// 特定のマイグレーション処理を行う
    /// - Parameters:
    ///   - version: 実行したいマイグレーションの番号
    ///   - completion: 完了時は `Result<Void, Error>` が返される
    public func execute<T: MigratorProtocol>(with migrators: [T], completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        migrators.forEach { migrator in
            guard migrator.isNeedMigration() else {
                return
            }
            migrator.migration { result in
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
