//
//  APIService.swift
//  SmallcaseGatewayAssignment
//
//  Created by noor on 28/09/23.
//

import Foundation


protocol APIServiceProtocol {
    func request<T: Codable>(_ path: String,params: inout [String:String]?, type: T.Type, completion: @escaping (Result<T,Error>) -> Void)
}

final class APIService: APIServiceProtocol{
    static let shared = APIService()
    let jsonDecoder = JSONDecoder()
    
    let apiURLScheme = "https"
    let apiHost = "dummyjson.com"
    private init() {}
    
    func request<T: Codable>(_ path: String, params: inout [String:String]?, type: T.Type, completion: @escaping (Result<T,Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = apiURLScheme
        components.host = apiHost
        components.path = "/\(path)"
        
        if let parameters = params {
            components.setQueryItems(with: parameters)
        }
        
        guard let url = components.url else{
            completion(.failure(APIError.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            print("Endpoint URL => \(url)")

            if let httpBody = request.httpBody {
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: .utf8) {
                    let message = "\n\n------------------------------------------------ Request HTTP Body JSON: BEGIN ------------------------------------------------\n\n"+json+"\n\n--------------------------------------------------- Request HTTP Body JSON: END ------------------------------------------------\n\n"
                    print(message)
                    
                } else {
                    print("Unable to convert Data to JSON String")
                }
                
            }
            
            
            if error != nil {
                completion(.failure(APIError.custom(error: error!)))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                completion(.failure(APIError.invalidStatusCode(statusCode: statusCode)))
                return
                
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                let res  = try self.jsonDecoder.decode(T.self, from: data)
                
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: .utf8) {
                    let jsonMessage = "\n\n------------------------------------------------ Raw JSON Object: BEGIN ------------------------------------------------\n\n"+json+"\n\n--------------------------------------------------- Raw JSON Object: END ------------------------------------------------\n\n"
                    print(jsonMessage)
                }
                
                
                completion(.success(res))
            } catch {
                completion(.failure(APIError.failedToDecode(error: error)))
                print(error)
            }
        }
        dataTask.resume()
    }
}

extension APIService {
    enum APIError: Error {
        case invalidURL
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
}
