//
//  MigratorProtocol.swift
//  
//
//  Created by Shunya Yamada on 2022/04/03.
//

import Foundation

/// 型消去用の Protocol.
public protocol AnyMigrator {
    func _isNeedMigration() -> Bool
    func _migration(completion: @escaping (Result<Any, Error>) -> Void)
}

/// マイグレーションを行うオブジェクトに適合させる Protocol.
public protocol MigratorProtocol: AnyMigrator {
    /// マイグレーションの結果として返す型.
    associatedtype Output
    
    /// マイグレーションが必要かどうかを返す.
    func isNeedMigration() -> Bool
    /// 実施するマイグレーションの内容.
    func migration(completion: @escaping (Result<Output, Error>) -> Void)
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
