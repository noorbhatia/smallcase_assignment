//
//  ViewModel.swift
//  SmallcaseGatewayAssignment
//
//  Created by noor on 28/09/23.
//

import Foundation
import AuthenticationServices


protocol GatewayViewModelDelegate: AnyObject{
    func didGetResponse()
    func didFail(error: Error)
}
final class GatewayViewModel {
    
    private(set) var apiService: APIServiceProtocol
    private(set) var message = [Product]()
    weak var delegate: GatewayViewModelDelegate?
    
    required init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
        
    }
    
    func callApi() {
        var params: [String : String]? = nil
        apiService.request("products", params: &params, type: Data.self, completion: completion)
    }
    
    private func completion(result: Result<Data, Error>){
        switch result {
        case .success(let response):
            message = response.products
            DispatchQueue.main.async{ [weak self] in
                self?.delegate?.didGetResponse()
            }
        case .failure(let error):
            DispatchQueue.main.async{[weak self] in
                self?.delegate?.didFail(error: error)
            }
        }
    }
    
}
