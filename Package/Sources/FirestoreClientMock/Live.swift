//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/11.
//

@_exported import FirestoreClient
import Dependencies
import Foundation
import SharedModels

extension FirestoreClient: DependencyKey {
    public static var liveValue: FirestoreClient {
        Self.live()
    }

    private static func live() -> Self {
        let userDefaults = UserDefaults.standard

        return .init { session, date in
            let key = date.formatted(
                date: .numeric,
                time: .omitted
            )
            guard var dictionary = userDefaults.dictionary else {
                let dictionary: [String: [Session]] = [key: [session]]
                userDefaults.setDictionary(dictionary)
                return
            }
            if let storedSessions = dictionary[key] {
                let sessions = storedSessions + [session]
                dictionary[key] = sessions
            } else {
                dictionary[key] = [session]
            }

            userDefaults.setDictionary(dictionary)
        } getSessions: { date in
            let key = date.formatted(
                date: .numeric,
                time: .omitted
            )
            guard let dictionary = userDefaults.dictionary else {
                return []
            }
            return dictionary[key] ?? []
        } getCategories: { _ in
            .mock
        }
    }
}

private extension UserDefaults {
    var dictionary: [String: [Session]]? {
        guard let data = data(forKey: "SessionsMock"),
              let decoded = try? JSONDecoder().decode([String: [Session]].self, from: data) else {
            return nil
        }
        return decoded
    }

    func setDictionary(_ dictionary: [String: [Session]]) {
        guard let data = try? JSONEncoder().encode(dictionary) else {
            return
        }
        set(data, forKey: "SessionsMock")
    }
}

private extension Array where Element == SharedModels.Category {
    static var mock: [SharedModels.Category] {
        [
            .init(
                id: "1",
                title: "英語",
                color: .init(
                    hex: "#FFA500",
                    systemColorName: .orange
                )
            ),
            .init(
                id: "2",
                title: "数学",
                color: .init(
                    hex: "#007bff",
                    systemColorName: .blue
                )
            ),
            .init(
                id: "3",
                title: "国語",
                color: .init(
                    hex: "#ff2845",
                    systemColorName: .pink
                )
            )
        ]
    }
}

extension UserDefaults: @unchecked @retroactive Sendable {}
