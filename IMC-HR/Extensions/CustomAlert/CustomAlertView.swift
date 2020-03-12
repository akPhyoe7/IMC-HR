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
        case success
        case fail
        case statusSuccess
        case statusFail
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
        //adding label
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 2
        lblMessage.font = lblMessage.font.withSize(15)
        lblMessage.text = message
        frontView.addSubview(lblMessage)
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
        lblMessage.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true
        
        switch alertType {
        case .loading:
            frontViewHeight.constant = 140
            //adding loading indicator
            loadingIndicator.style = .large
            loadingIndicator.color = .gray
            loadingIndicator.startAnimating()
            frontView.addSubview(loadingIndicator)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -20).isActive = true
            
            //label color
            lblMessage.textColor = .darkGray
            lblMessage.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10).isActive = true
            
        case .warning:
            frontViewHeight.constant = 130
            imgStatus.image = UIImage(named: "icon_locwarning")
            imgStatus.contentMode = .scaleAspectFit
            frontView.addSubview(imgStatus)
            imgStatus.translatesAutoresizingMaskIntoConstraints = false
            imgStatus.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            imgStatus.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -20).isActive = true
            
            //label color
            lblMessage.textColor = .red
            lblMessage.topAnchor.constraint(equalTo: imgStatus.bottomAnchor, constant: 10).isActive = true
        case .success:
            frontViewHeight.constant = 130
            imgStatus.image = UIImage(named: "icon_success")
            imgStatus.contentMode = .scaleAspectFit
            frontView.addSubview(imgStatus)
            imgStatus.translatesAutoresizingMaskIntoConstraints = false
            imgStatus.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            imgStatus.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -20).isActive = true
            
            //adding label
            lblMessage.textColor = UIColor(named: "BGGreen")
            lblMessage.topAnchor.constraint(equalTo: imgStatus.bottomAnchor, constant: 10).isActive = true
        case .fail:
            frontViewHeight.constant = 130
            imgStatus.image = UIImage(named: "icon_fail")
            imgStatus.contentMode = .scaleAspectFit
            frontView.addSubview(imgStatus)
            imgStatus.translatesAutoresizingMaskIntoConstraints = false
            imgStatus.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            imgStatus.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -20).isActive = true
            
            //adding label
            lblMessage.textColor = .red
            lblMessage.topAnchor.constraint(equalTo: imgStatus.bottomAnchor, constant: 10).isActive = true
        case .statusSuccess:
            frontViewHeight.constant = 200
            imgStatus.image = UIImage(named: "icon_success")
            imgStatus.contentMode = .scaleAspectFit
            frontView.addSubview(imgStatus)
            imgStatus.translatesAutoresizingMaskIntoConstraints = false
            imgStatus.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            imgStatus.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -30).isActive = true
            
            //adding label
            lblMessage.textColor = UIColor(named: "BGGreen")
            lblMessage.topAnchor.constraint(equalTo: imgStatus.bottomAnchor, constant: 30).isActive = true
        case .statusFail:
            frontViewHeight.constant = 200
            imgStatus.image = UIImage(named: "icon_fail")
            imgStatus.contentMode = .scaleAspectFit
            frontView.addSubview(imgStatus)
            imgStatus.translatesAutoresizingMaskIntoConstraints = false
            imgStatus.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
            imgStatus.centerYAnchor.constraint(equalTo: frontView.centerYAnchor, constant: -30).isActive = true
            
            //adding label
            lblMessage.textColor = .red
            lblMessage.topAnchor.constraint(equalTo: imgStatus.bottomAnchor, constant: 30).isActive = true
        }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.addSubview(parientView)
    }
    
    func hideAlert() {
        for view in self.frontView.subviews {
            view.removeFromSuperview()
        }
        parientView.removeFromSuperview()
    }
}
