//
//  AuthProvider.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import Combine
import Foundation
import FirebaseAuth

public protocol AuthProviderProtocol: AnyObject {
    /// 現在サインインしているユーザー.
    var currentUser: FirebaseAuth.User? { get }
    
    /// サインインの処理を行う.
    ///
    /// - Parameters:
    ///   - email: Eメールアドレス.
    ///   - password: パスワード.
    func signIn(with email: String, password: String) -> Future<AuthDataResult, Error>
    
    /// 匿名でサインインを行う.
    func signInAnonymously() -> Future<AuthDataResult, Error>
    
    /// サインアウトの処理を行う.
    func signOut() -> Future<Void, Error>
}

public final class AuthProvider: AuthProviderProtocol {
    
    // MARK: Singleton
    
    public static let shared: AuthProvider = .init()
    
    // MARK: Properties
    
    private let auth = Auth.auth()
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Auth
    
    public var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }
    
    public func signIn(with email: String, password: String) -> Future<AuthDataResult, Error> {
        return Future { [weak self] promise in
            self?.auth.signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }
    }
    
    public func signInAnonymously() -> Future<AuthDataResult, Error> {
        return Future { [weak self] promise in
            self?.auth.signInAnonymously(completion: { (result, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            })
        }
    }
    
    public func signOut() -> Future<Void, Error> {
        return Future { [weak self] promise in
            do {
                try self?.auth.signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
}
