//
//  V200Migrator.swift
//  
//
//  Created by Shunya Yamada on 2022/04/05.
//

import Combine
import Core
import Foundation

/// バージョン `1.x` 系のアプリからアップデートする際に実行するマイグレーション.
public struct V200Migrator: MigratorProtocol {
    public var isNeedMigration: () -> Bool
    public var migration: () -> AnyPublisher<Void, Error>
}

public enum V200MigrationError: Error {
    case failed(message: String)
}

public extension V200Migrator {
    static func live(
        firestoreService: FirestoreService = .live(),
        userDefaultsService: UserDefaultsService = .live()
    ) -> Self {
        return Self.init(
            isNeedMigration: {
                return userDefaultsService.object(.oldList) != nil
            },
            migration: {
                return Future<Void, Error> { promise in
                    // ここが `nil` の場合、以前のデータは存在しないのでマイグレーションの必要なし.
                    if let data = userDefaultsService.object(.oldList) as? Data {
                        // ここが `nil` の場合、データの取得に失敗している可能性がある.
                        do {
                            // モジュール名が変わるため `setClass(_:forClassName:)` でクラス名を紐付けしておく.
                            NSKeyedUnarchiver.setClass(YourStudyData.self, forClassName: YourStudyData.className)
                            if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [YourStudyData] {
                                //return promise(.success(unarchivedData))
                                return promise(.success(()))
                            }
                        } catch {
                            return promise(.failure(V200MigrationError.failed(message: "\(error)")))
                        }
                    }
                    return promise(.success(()))
                }
                .eraseToAnyPublisher()
            }
        )
    }
}
