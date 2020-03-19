//
//  WidgetGenerator.swift
//  IMC-HR
//
//  Created by admin on 17/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation
import UIKit

class WidgetGenerator {
    
    static func getPayslipListView(info : String, amt : Int, entry : String, width : CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        let lblInfo = UILabel()
        let lblAmt = UILabel()
        
        lblInfo.font = UIFont.systemFont(ofSize: 13)
        lblInfo.numberOfLines = 1
        lblInfo.textColor = UIColor.darkGray
        lblInfo.text = info
        view.addSubview(lblInfo)
        lblInfo.translatesAutoresizingMaskIntoConstraints = false
        lblInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        lblInfo.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        lblInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        lblInfo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
        lblAmt.font = UIFont.systemFont(ofSize: 13)
        lblAmt.numberOfLines = 1
        if entry == "CREDIT" {
            lblAmt.textColor = UIColor.darkGray
            lblAmt.text = "\(amt) MMK"
        } else {
            lblAmt.textColor = UIColor.red
            lblAmt.text = "-\(amt) MMK"
        }
        lblAmt.textAlignment = .right
        view.addSubview(lblAmt)
        lblAmt.translatesAutoresizingMaskIntoConstraints = false
        lblAmt.leftAnchor.constraint(equalTo: lblInfo.rightAnchor, constant: 10).isActive = true
        lblAmt.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        lblAmt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        lblAmt.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        return view
        
    }
    
    static func getLabel(_ text : String = "") -> UILabel {
        let ui = UILabel()
        ui.font = UIFont.systemFont(ofSize: 15)
        ui.numberOfLines = 0
        ui.text = text
        ui.textColor = UIColor.darkGray
        return ui
    }
}
