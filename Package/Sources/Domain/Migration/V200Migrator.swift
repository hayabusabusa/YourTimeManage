//
//  V200Migrator.swift
//  
//
//  Created by Shunya Yamada on 2022/04/05.
//

import Core
import Foundation

/// バージョン `1.x` 系のアプリからアップデートする際に実行するマイグレーション.
public struct V200Migrator: MigratorProtocol {
    public typealias Output = [YourStudyData]

    /// 旧アプリのデータを `UserDefauls` に保存しているかどうか.
    public var isStoredOldData: () -> Bool
    /// 旧データを変換するマイグレーションを実行する.
    public var migration: () -> Result<[YourStudyData], Error>

    public func isNeedMigration() -> Bool {
        return isStoredOldData()
    }

    public func migration(completion: @escaping (Result<[YourStudyData], Error>) -> Void) {
        completion(migration())
    }
}

public enum V200MigrationError: Error {
    case failed(message: String)
}

public extension V200Migrator {

    static func live(
        userDefaultsService: UserDefaultsService = .live()
    ) -> Self {
        return Self.init(
            isStoredOldData: {
                return userDefaultsService.object(.oldList) != nil
            },
            migration: {
                // ここが `nil` の場合、以前のデータは存在しないのでマイグレーションの必要なし.
                if let data = userDefaultsService.object(.oldList) as? Data {
                    // ここが `nil` の場合、データの取得に失敗している可能性がある.
                    do {
                        // モジュール名が変わるため `setClass(_:forClassName:)` でクラス名を紐付けしておく.
                        NSKeyedUnarchiver.setClass(YourStudyData.self, forClassName: YourStudyData.className)
                        if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [YourStudyData] {
                            return .success(unarchivedData)
                        }
                    } catch {
                        return .failure(V200MigrationError.failed(message: "\(error)"))
                    }
                }
                return .success([])
            }
        )
    }
}
