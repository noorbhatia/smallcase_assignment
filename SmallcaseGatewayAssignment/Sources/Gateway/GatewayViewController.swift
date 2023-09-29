//
//  GatewayViewController.swift
//  SmallcaseGatewayAssignment
//
//  Created by noor on 28/09/23.
//

import UIKit
import AuthenticationServices

class GatewayViewController: UIViewController {
    var viewModel = GatewayViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        viewModel.delegate = self
    }
    
    // MARK: - Initializers
    
    lazy var browserButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open In App Browser", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    lazy var apiButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call API", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
}



