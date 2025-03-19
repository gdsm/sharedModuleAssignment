//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Gagandeep on 19/02/24.
//

import Foundation
import Logging

public final class NetworkService: NetworkProtocol {
    private let session: URLSession
    public static let defaultTimeout: TimeInterval = 30
    private let cache = URLCache(memoryCapacity: 10 * 1_024 * 1_024, diskCapacity: 100 * 1_024 * 1_024)
    private let cacheResponse: Bool

    static func getService(
        cacheResponse: Bool,
        timeout: TimeInterval = defaultTimeout,
    ) -> NetworkProtocol {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        return NetworkService(config: config, cacheResponse: cacheResponse)
    }

    init(config: URLSessionConfiguration, cacheResponse: Bool) {
        session = URLSession(configuration: config)
        self.cacheResponse = cacheResponse
    }
    
    public func request<T: Codable>(urlRequest: URLRequest) async throws -> T {
        if let cacheResponse = cache.cachedResponse(for: urlRequest) {
            do {
                return try parse(urlResponse: cacheResponse.response, data: cacheResponse.data)
            } catch {
                Log.info("Failed to fetch cache response.")
            }
        }
        let response = try await session.data(for: urlRequest)
        if cacheResponse {
            cache.storeCachedResponse(
                CachedURLResponse(
                    response: response.1,
                    data: response.0,
                    storagePolicy: .allowed
                ),
                for: urlRequest
            )
        }
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
