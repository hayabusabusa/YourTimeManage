//
//  AuthService.swift
//  
//
//  Created by Shunya Yamada on 2022/04/10.
//

import Combine
import FirebaseAuth

public struct AuthService {

    /// サインイン済みかどうか.
    public var isSignedIn: () -> Future<Bool, Never>

    /// 匿名認証でサインインする.
    public var signInAnonymously: () -> Future<FirebaseAuth.User, Error>
}

public extension AuthService {

    static let live = Self.init(
        isSignedIn: {
            return Future { promise in
                let isSignedIn = Auth.auth().currentUser != nil
                promise(.success(isSignedIn))
            }
        },
        signInAnonymously: {
            return Future { promise in
                Auth.auth().signInAnonymously { result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let result = result {
                        promise(.success(result.user))
                    }
                }
            }
        }
    )
}
