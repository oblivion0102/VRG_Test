import Foundation
import Alamofire
import WebKit

class Network {
    
    func fetchRec(URL url: String, completion: @escaping ([Article]) -> Void) {
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response { responce in
                switch responce.result {
                case .success (let data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(NetworkData.self, from: data!)
                        completion(result.results)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print (error.localizedDescription)
                }
            }
    }
}

