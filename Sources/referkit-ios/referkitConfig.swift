//
//  File.swift
//  referkit-ios
//
//  Created by Zach Danielson! on 4/15/25.
//

import Foundation

public class ReferKitConfig {
    static var shared = ReferKitConfig()
    
    private(set) var apiKey: String = ""
    private(set) var baseURL: String = "https://api.referkit.com"
    private(set) var environment: Environment = .production
    
    enum Environment {
        case development
        case production
    }
    
    private init() {}
    
    func configure(apiKey: String, environment: Environment = .production) {
        self.apiKey = apiKey
        self.environment = environment
        
        // Update base URL based on environment
        switch environment {
        case .development:
            baseURL = "https://dev-api.referkit.com"
        case .production:
            baseURL = "https://api.referkit.com"
        }
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "X-API-Key": apiKey,
            "User-Agent": userAgent
        ]
    }
    
    private var userAgent: String {
        let device = UIDevice.current
        return "ReferKit-iOS/1.0 (\(device.systemName) \(device.systemVersion); \(device.model))"
    }
}
