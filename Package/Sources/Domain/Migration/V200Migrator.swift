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
    case notSignedIn
}

public extension V200Migrator {
    static func live(
        authService: AuthService = .live,
        firestoreService: FirestoreService = .live(),
        userDefaultsService: UserDefaultsService = .live()
    ) -> Self {
        return Self.init(
            isNeedMigration: {
                return userDefaultsService.object(.oldList) != nil
            },
            migration: {
                return Future<[YourStudyData], Error> { promise in
                    // ここが `nil` の場合、以前のデータは存在しないのでマイグレーションの必要なし.
                    if let data = userDefaultsService.object(.oldList) as? Data {
                        // ここが `nil` の場合、データの取得に失敗している可能性がある.
                        do {
                            // モジュール名が変わるため `setClass(_:forClassName:)` でクラス名を紐付けしておく.
                            NSKeyedUnarchiver.setClass(YourStudyData.self, forClassName: YourStudyData.className)
                            if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [YourStudyData] {

                                return promise(.success(unarchivedData))
                            }
                        } catch {
                            return promise(.failure(V200MigrationError.failed(message: "\(error)")))
                        }
                    }
                    return promise(.success([]))
                }
                .map { unarchivedData -> [Study] in
                    // 旧データから新データへの変換も行う
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"

                    let studies = unarchivedData.map { studyData -> Study in
                        // 日付のデータがない場合は今日の日付にしておく.
                        let date = formatter.date(from: studyData.date ?? "") ?? Date()
                        return Study(
                            date: date,
                            title: studyData.title ?? "タイトルなし",
                            seconds: studyData.hour * 3600 + studyData.minute * 60,
                            memo: studyData.memo
                        )
                    }
                    return studies
                }
                .flatMap { studies -> AnyPublisher<Void, Error> in
                    guard let user = authService.currentUser() else {
                        return Fail<Void, Error>(error: V200MigrationError.notSignedIn).eraseToAnyPublisher()
                    }

                    let reference = StudiesCollectionReference(userID: user.uid)
                    return firestoreService.addDocuments(for: reference, data: studies)
                }
                .eraseToAnyPublisher()
            }
        )
    }
}
