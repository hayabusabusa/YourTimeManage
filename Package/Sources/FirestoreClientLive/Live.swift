//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

@_exported import FirestoreClient
import Dependencies
import FirebaseFirestore
import Foundation
import SharedModels

// TODO: Firestore 用の Entity を用意して、`@DocumentID` 等の Firestore 特有の機能を使うようにする.
//extension FirestoreClient: DependencyKey {
//    public static var liveValue: FirestoreClient {
//        Self.live()
//    }
//
//    private static func live() -> Self {
//        let db = Firestore.firestore()
//        let encoder = Firestore.Encoder()
//        let decoder = Firestore.Decoder()
//
//        return .init {}
//    }
//}
