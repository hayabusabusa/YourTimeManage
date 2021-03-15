//
//  Migrator.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/12.
//

import Foundation
import Domain

enum MigrationError: Error, CustomStringConvertible {
    case failedV200Migration(message: String)
    
    var description: String {
        switch self {
        case .failedV200Migration(let message):
            return "旧アプリのデータマイグレーションに失敗しました: \(message)"
        }
    }
}

struct Migrator {
    
    enum Version {
        case v200
    }
    
    /// 特定のマイグレーション処理を行う
    /// - Parameters:
    ///   - version: 実行したいマイグレーションの番号
    ///   - completion: 完了時は `Result<Void, Error>` が返される
    static func execute(of version: Version, completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        switch version {
        case .v200:
            dispatchGroup.enter()
            
            migrationToV200 { error in
                if let error = error {
                    completion(.failure(error))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    /// マイグレーションが必要かどうかを返す
    /// - Parameter version: 実行したいマイグレーションの番号
    /// - Returns: マイグレーションが必要か不必要か
    static func isNeedMigration(of version: Version) -> Bool {
        switch version {
        case .v200:
            // NOTE: `nil` の場合、以前のデータは存在しないのでマイグレーションの必要なし
            return UserDefaultsProvider.shared.object(type: Data.self, forKey: .oldList) != nil
        }
    }
    
    private static func migrationToV200(completion: @escaping (Error?) -> Void) {
        // NOTE: 並列のキュー( concurrent queue ) を生成する
        let queue = DispatchQueue(label: "Migrator.V200.Queue", attributes: .concurrent)
        
        queue.async {
            // NOTE: ここが `nil` の場合、以前のデータは存在しないのでマイグレーションの必要なし
            if let data = UserDefaultsProvider.shared.object(type: Data.self, forKey: .oldList) {
                // NOTE: ここが `nil` の場合、データの取得に失敗している可能性がある
                do {
                    if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [YourStudyData] {
                        let entity = unarchivedData.map { StudyEntity(date: $0.date, title: $0.title, seconds: $0.hour * 3600 + $0.minute * 60, memo: $0.memo) }
                        print(entity)
                    }
                } catch {
                    completion(MigrationError.failedV200Migration(message: "\(error)"))
                }
            }
            completion(nil)
        }
    }
}

/// 旧アプリで使用していた勉強のデータ
/// - Note:
///     `NSCoding` を利用してアーカイブを行うために、以前と同じターゲット、ソースを用意する必要がある.
///     よって、**このクラスはマイグレーション以外で使用しない**.
final class YourStudyData: NSObject, NSCoding {
    public let date: String?
    public let title: String?
    public let hour: Int
    public let minute: Int
    public let memo: String?
    
    public required init?(coder: NSCoder) {
        date = coder.decodeObject(forKey: "studyDate") as? String
        title = coder.decodeObject(forKey: "studyTitle") as? String
        hour = coder.decodeInteger(forKey: "studyHour")
        minute = coder.decodeInteger(forKey: "studyMinute")
        memo = coder.decodeObject(forKey: "studyMemo") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "studyDate")
        coder.encode(title, forKey: "studyTitle")
        coder.encode(hour, forKey: "studyHour")
        coder.encode(minute, forKey: "studyMinute")
        coder.encode(memo, forKey: "studyMemo")
    }
}
