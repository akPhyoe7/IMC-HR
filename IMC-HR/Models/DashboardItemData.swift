//
//  DashboardItemData.swift
//  IMC-HR
//
//  Created by admin on 12/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

// MARK:- Dashboard Items
// dashboard item struct
public struct itemData {
    public let iconImg : String
    public let itemLabel : String
    public let segueName : String
    
    public init(iconImg : String, itemLabel : String, segueName : String) {
        self.iconImg = iconImg
        self.itemLabel = itemLabel
        self.segueName = segueName
    }
}

// dashboard item list class
class dashboardItemsData {
    static let sharedInstance = dashboardItemsData()
    var items : [itemData] = []
    let leaveApprovalItem : itemData = itemData(iconImg: "icon_leaveapproval", itemLabel: "Leave Approval", segueName: "gotoLeaveApproval")
    
    private init() {
        items = [
            itemData(iconImg: "icon_attendance", itemLabel: "Attendance", segueName: "gotoAttendance"),
            itemData(iconImg: "icon_leave", itemLabel: "Leave", segueName: "gotoLeaveRequest"),
            itemData(iconImg: "icon_payslip", itemLabel: "Payslip", segueName: "gotoPayslip"),
            itemData(iconImg: "icon_profile", itemLabel: "Profile", segueName: "gotoProfile")
        ]
    }
    
    func addLeaveApproval() {
        items.append(leaveApprovalItem)
    }
    
    func count() -> Int{
        return items.count
    }
}
