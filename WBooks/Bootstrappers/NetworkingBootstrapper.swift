//
//  NetworkingBootstrapper.swift
//  WBooks
//
//  Created by Argentino Ducret on 05/08/2018.
//  Copyright © 2018 Wolox. All rights reserved.
//

import Foundation
import Networking
import ReactiveSwift
import AlamofireNetworkActivityIndicator
import AlamofireNetworkActivityLogger
import UIKit

class NetworkingBootstrapper {

    static let shared = NetworkingBootstrapper()

    fileprivate let _sessionManager = SessionManager()

    fileprivate let networkingConfiguration: NetworkingConfiguration = {
        var config = NetworkingConfiguration()

        config.useSecureConnection = true
        config.domainURL = "wbooks-api-stage.herokuapp.com"
        config.subdomainURL = "/api/v1"
        config.usePinningCertificate = false

        return config
    }()

    private init() { }

    func bootstrap() {
        enableAlamofireNetworkActivityLogger()
        enableNetworkActivityIndicatorManager()
        bootstrapSessionManager()
        injectCurrentUserFetcher()
    }

    func createWBooksRepository() -> BookRepository{
        let repository = BookRepository(
            networkingConfiguration: networkingConfiguration,
            sessionManager: _sessionManager)
        
        return repository
    }
    
    func createUserCommentRepository() -> CommentRepository{
        let repository = CommentRepository(
            networkingConfiguration: networkingConfiguration,
            sessionManager: _sessionManager)
        
        return repository
    }
}

// MARK: Private Methods
fileprivate extension NetworkingBootstrapper {

    func enableAlamofireNetworkActivityLogger() {
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
    }

    func enableNetworkActivityIndicatorManager() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }

    func bootstrapSessionManager() {
        _sessionManager.bootstrap()
    }

    func injectCurrentUserFetcher() {
        if !_sessionManager.isLoggedIn {
            let currentUser = AuthUser()
            _sessionManager.login(user: currentUser)
        } else {
            print("User is already logged")
        }
    }

}
