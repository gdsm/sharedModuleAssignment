//
//  NetworkProtocol.swift
//  NetworkServices
//
//  Created by Gagandeep on 19/02/24.
//

import Foundation

public protocol NetworkProtocol {
    func request<T: Codable>(urlRequest: URLRequest) async throws -> Result<T, ServiceError>
}

public enum HTTPMethod: String {
    case GET = "GET", POST = "POST", PUT = "PUT", DELETE = "DELETE", PATCH = "PATCH"
}

public enum HTTPStatusCode: Int {
    case ok = 200
    case noContent = 204
    case resetContent = 205
    case multipleChoices = 300
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
}
