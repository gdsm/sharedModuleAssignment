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
    
    public func request<T: Codable>(urlRequest: URLRequest) async throws -> T {
        let response = try await session.data(for: urlRequest)
        return try parse(urlResponse: response.1, data: response.0)
    }
    
    private func parse<T: Codable>(urlResponse: URLResponse, data: Data) throws -> T {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw ServiceError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        default:
            throw ServiceError.responseCode(code: httpResponse.statusCode)
        }
    }
}
