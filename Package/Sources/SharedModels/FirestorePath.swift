//
//  FirestorePath.swift
//
//
//  Created by Shunya Yamada on 2024/09/08.
//

import Foundation

/// Firestore のコレクションやドキュメントまでのパス.
public enum FirestorePath {
    private static var base: String {
        "public/v2"
    }

    public static func users() -> String {
        base + "/users"
    }

    public static func user(id: String) -> String {
        users() + "/\(id)"
    }

    public static func studies(userID: String) -> String {
        user(id: userID) + "/studies"
    }

    public static func study(userID: String, id: String) -> String {
        studies(userID: userID) + "/\(id)"
    }
}
