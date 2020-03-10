//
//  DashboardViewController.swift
//  IMC-HR
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var dashboardItems : [dashboardItem] = [
        dashboardItem(iconImg: "icon_attendance", itemLabel: "Attendance"),
        dashboardItem(iconImg: "icon_leave", itemLabel: "Leave"),
        dashboardItem(iconImg: "icon_leaveapproval", itemLabel: "Leave Approval"),
        dashboardItem(iconImg: "icon_payslip", itemLabel: "Payslip"),
        dashboardItem(iconImg: "icon_profile", itemLabel: "Profile"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///hide shadow under the navigation bar and change bar text color
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        CustomAlertView.shareInstance.showAlert(message: "Out of range! Move closer to office and try again.", alertType: CustomAlertView.alertType.loading)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension DashboardViewController {
    
}

// MARK:- Dashboard Items
// dashboard items struct
public struct dashboardItem {
    public let iconImg : String
    public let itemLabel : String
    
    public init(iconImg : String, itemLabel : String) {
        self.iconImg = iconImg
        self.itemLabel = itemLabel
    }
}
