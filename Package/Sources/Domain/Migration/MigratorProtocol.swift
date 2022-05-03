//
//  MigratorProtocol.swift
//  
//
//  Created by Shunya Yamada on 2022/04/03.
//

import Combine

/// マイグレーションを行うオブジェクトに適合させる Protocol.
public protocol MigratorProtocol {
    /// マイグレーションが必要かどうかを返す.
    var isNeedMigration: () -> Bool { get }
    /// 実施するマイグレーションの内容.
    var migration: () -> AnyPublisher<Void, Error> { get }
}
