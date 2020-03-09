//
//  CustomAlertView.swift
//  IMC-HR
//
//  Created by admin on 09/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation
import UIKit

class CustomAlertView: UIView {
    static let shareInstance = CustomAlertView()
    
    @IBOutlet var parientView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frontView: DesignableView!
    @IBOutlet weak var frontViewHeight: NSLayoutConstraint!
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let imgStatus = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let lblMessage = UILabel()
    enum alertType{
        case loading
        case warning
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        parientView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        parientView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func showAlert(message : String, alertType : alertType) {
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 2
        lblMessage.font = lblMessage.font.withSize(15)
        lblMessage.text = message
        switch alertType {
        case .loading:
            //adding loading indicator
            loadingIndicator.style = .large
            loadingIndicator.color = .gray
            loadingIndicator.startAnimating()
            frontView.addSubview(loadingIndicator)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -20).isActive = true
            
            //adding label
            lblMessage.textColor = .darkGray
            frontView.addSubview(lblMessage)
            lblMessage.translatesAutoresizingMaskIntoConstraints = false
            lblMessage.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10).isActive = true
            lblMessage.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
            lblMessage.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true
        case .warning: break
        }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.addSubview(parientView)
    }
    
    func hideAlert() {
        parientView.removeFromSuperview()
    }
}
