//
//  GatewayViewController+Helpers.swift
//  SmallcaseGatewayAssignment
//
//  Created by noor on 29/09/23.
//

import UIKit
import AuthenticationServices


extension GatewayViewController {
    
    func setupUI(){
        self.view.addSubview(browserButton)
        self.view.addSubview(apiButton)
        configureLayouts()
        configureTargetActions()
    }
    
    func configureLayouts(){
        NSLayoutConstraint.activate([
            
            browserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            browserButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            apiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            apiButton.topAnchor.constraint(equalTo: browserButton.bottomAnchor,constant: 20)
        ])
    }
    
    private func configureTargetActions() {
        browserButton.addTarget(self, action: #selector(didTapOpenBrowserButton), for: .touchUpInside)
        apiButton.addTarget(self, action: #selector(didTapCallApiButton), for: .touchUpInside)
    }
    
    private func showAlertDialog(_ action: Action, message: String) {
        let alert = UIAlertController(title: action.title, message: message, preferredStyle: .alert)
        if action == .api{
            let copyAction = UIAlertAction(title: "Copy", style: .default){_ in
                UIPasteboard.general.string = message
            }
            alert.addAction(copyAction)
        }
        let closeAction = UIAlertAction(title: "Close", style: .default){_ in
            alert.dismiss(animated: true,completion: nil)
        }
        
        
        alert.addAction(closeAction)
        self.present(alert, animated: true,completion: nil)
    }
    
    @objc
    private func didTapOpenBrowserButton() {
        openBrowser()
    }
    
    @objc
    private func didTapCallApiButton() {
        self.viewModel.callApi()
    }
}

extension GatewayViewController: ASWebAuthenticationPresentationContextProviding{
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

extension GatewayViewController {
    func openBrowser(){
        guard let authURL = URL(string: "https://webcode.tools/generators/html/hyperlink") else {return}
        let scheme = "sc-assignment"
        
        
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { [weak self] callbackURL, error in
            guard error == nil else {
                self?.showAlertDialog(.error, message: error!.localizedDescription)
                return
            }
            guard let url = callbackURL else {return}
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false){
                var message:String = ""
                if let queryItems = components.queryItems {
                    
                    for queryItem in queryItems {
                        
                        if queryItem.name != "data"{
                            message.append("\(queryItem.name): \(queryItem.value ?? "")\n")
                        }
                        if queryItem.name == "data" , let jsonString = queryItem.value{
                            if let jsonData = jsonString.data(using: .utf8) {
                                do {
                                    message.append("\ndata:\n\n")
                                    if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                        
                                        for (key, innerDictionary) in jsonDictionary {
                                            message.append("\(key): \(innerDictionary)\n")
                                        }
                                    }
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                            }
                            
                        }
                        
                        
                    }
                }
                self?.showAlertDialog(.deeplink, message: message)
            } else {
                return
            }
            
            
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    
}

extension GatewayViewController: GatewayViewModelDelegate {
    func didGetResponse() {
        var message : String = ""
        for product in viewModel.message{
            message.append("\(product.title): \(type(of:(product.title)))\n\u{20B9}\(product.price): \(type(of:(product.price)))\n\n")
        }
        self.showAlertDialog(.api, message: message)
    }
    
    func didFail(error: Error) {
        showAlertDialog(.api, message: error.localizedDescription)
    }
    
    
}

enum Action {
    case deeplink , api , error
    
    var title:String{
        switch self {
        case .deeplink : return "Response from Deeplink"
        case .api : return "Response from API"
        case .error : return "Error"
            
        }
    }
}
