//
//  NetworkFactory.swift
//  NetworkServices
//
//  Created by Gagandeep on 20/02/24.
//

import Foundation

public struct NetworkFactory {
    
    public static func getService() -> NetworkProtocol {
        return NetworkService.getService()
    }
    
}
