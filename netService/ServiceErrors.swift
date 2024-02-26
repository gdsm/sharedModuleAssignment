//
//  ServiceErrors.swift
//  NetworkServices
//
//  Created by Gagandeep on 19/02/24.
//

import Foundation

public enum ServiceError: Error {
    case unknown
    case responseCode(code: Int)
    case noInternet
    case invalidCredentials
}

