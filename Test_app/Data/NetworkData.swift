import Foundation

struct NetworkData: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

struct Article: Codable {
    let id: Int
    let title: String
    let url: String
    let published_date: String
}

struct CombinedResponse {
    var response1: [Article]
    var response2: [Article]
    var response3: [Article]
}

