//
//  File.swift
//  referkit-ios
//
//  Created by Zach Danielson! on 4/15/25.
//

import Foundation

internal class ReferKitNetwork {
    static let shared = ReferKitNetwork()
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Match Request
    
    func sendMatchRequest(completion: @escaping (Result<MatchResponse, Error>) -> Void) {
        let device = UIDevice.current
        let installId = ReferKitStorage.shared.getInstallId() ?? ReferKitStorage.shared.generateAndSaveInstallId()
        
        let request = MatchRequest(
            deviceModel: device.model,
            osVersion: "\(device.systemName) \(device.systemVersion)",
            installId: installId.uuidString
        )
        
        let endpoint = "/api/match-user"
        performRequest(endpoint: endpoint, body: request, completion: completion)
    }
    
    // MARK: - Purchase Request
    
    func sendPurchaseEvent(amount: Double, currency: String, productId: String, completion: @escaping (Result<PurchaseResponse, Error>) -> Void) {
        guard let affiliateCode = ReferKitStorage.shared.getAffiliateCode(),
              let installId = ReferKitStorage.shared.getInstallId()?.uuidString else {
            completion(.failure(ReferKitError.missingAffiliateData))
            return
        }
        
        let request = PurchaseRequest(
            amount: amount,
            currency: currency,
            productId: productId,
            affiliateCode: affiliateCode,
            installId: installId
        )
        
        let endpoint = "/api/track-purchase"
        performRequest(endpoint: endpoint, body: request, completion: completion)
    }
    
    // MARK: - Generic Request Handler
    
    private func performRequest<T: Encodable, U: Decodable>(
        endpoint: String,
        body: T,
        completion: @escaping (Result<U, Error>) -> Void
    ) {
        guard let url = URL(string: ReferKitConfig.shared.baseURL + endpoint) else {
            completion(.failure(ReferKitError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ReferKitConfig.shared.headers
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ReferKitError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ReferKitError.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(ReferKitError.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// MARK: - Errors

enum ReferKitError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case missingAffiliateData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .noData:
            return "No data received from server"
        case .missingAffiliateData:
            return "Missing affiliate code or install ID"
        }
    }
}
