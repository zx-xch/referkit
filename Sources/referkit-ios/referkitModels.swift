import Foundation

// MARK: - Match Request/Response

struct MatchRequest: Codable {
    let deviceModel: String
    let osVersion: String
    let installId: String
    
    enum CodingKeys: String, CodingKey {
        case deviceModel = "device_model"
        case osVersion = "os_version"
        case installId = "install_id"
    }
}

struct MatchResponse: Codable {
    let affiliateCode: String?
    let success: Bool
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case affiliateCode = "affiliate_code"
        case success
        case message
    }
}

// MARK: - Purchase Request/Response

struct PurchaseRequest: Codable {
    let amount: Double
    let currency: String
    let productId: String
    let affiliateCode: String
    let installId: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case productId = "product_id"
        case affiliateCode = "affiliate_code"
        case installId = "install_id"
    }
}

struct PurchaseResponse: Codable {
    let success: Bool
    let message: String?
} 