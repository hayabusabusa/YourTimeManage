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
    public var isSignedIn: () -> Bool

    /// 匿名認証でサインインする.
    public var signInAnonymously: () -> Future<FirebaseAuth.User, Error>

    /// 現在サインインしているユーザー情報.
    public var currentUser: () -> FirebaseAuth.User?
}

public extension AuthService {

    static let live = Self.init(
        isSignedIn: {
            return Auth.auth().currentUser != nil
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
        },
        currentUser: {
            return Auth.auth().currentUser
        }
    )
}
