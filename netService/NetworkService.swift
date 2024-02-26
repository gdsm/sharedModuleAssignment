//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Gagandeep on 19/02/24.
//

import Foundation

public final class NetworkService: NetworkProtocol {
    private let session: URLSession
    public static let defaultTimeout: TimeInterval = 30
    
    static func getService(
        timeout: TimeInterval = defaultTimeout
    ) -> NetworkProtocol {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        return NetworkService(config: config)
    }

    init(config: URLSessionConfiguration) {
        session = URLSession(configuration: config)
    }
    
    public func request<T: Codable>(urlRequest: URLRequest) async throws -> Result<T, ServiceError> {
        let response = try await session.data(for: urlRequest)
        return try parse(urlResponse: response.1, data: response.0)
    }
    
    private func parse<T: Codable>(urlResponse: URLResponse, data: Data) throws -> Result<T, ServiceError> {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return Result.failure(ServiceError.unknown)
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            return Result.success(response)
        default:
            return Result.failure(ServiceError.responseCode(code: httpResponse.statusCode))
        }
    }
}
