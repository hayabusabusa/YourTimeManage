//
//  V200Migrator.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/04.
//

import Foundation
import Domain

public enum V200MigrationError: Error, CustomStringConvertible {
    case failed(message: String)
    
    public var description: String {
        switch self {
        case .failed(let message):
            return "旧アプリのデータマイグレーションに失敗しました: \(message)"
        }
    }
}

struct V200Migrator: MigratorProtocol {
    typealias MigrationOutput = [YourStudyData]
    
    var dispatchQueue: DispatchQueue {
        return DispatchQueue(label: "Migration.V200.Queue", attributes: .concurrent)
    }
    
    func isNeedMigration() -> Bool {
        return UserDefaultsProvider.shared.object(type: Data.self, forKey: .oldList) != nil
    }
    
    func migration(completion: @escaping (Result<[YourStudyData], Error>) -> Void) {
        dispatchQueue.async {
            // ここが `nil` の場合、以前のデータは存在しないのでマイグレーションの必要なし
            if let data = UserDefaultsProvider.shared.object(type: Data.self, forKey: .oldList) {
                // ここが `nil` の場合、データの取得に失敗している可能性がある
                do {
                    if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [YourStudyData] {
                        completion(.success(unarchivedData))
                    }
                } catch {
                    completion(.failure(V200MigrationError.failed(message: "\(error)")))
                }
            }
            completion(.success([]))
        }
    }
}

/// 旧アプリで使用していた勉強のデータ
/// - Note: `NSCoding` を利用してアーカイブを行うために、以前と同じターゲット、ソースを用意する必要がある.
///          よって、**このクラスはマイグレーション以外で使用しない**.
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
