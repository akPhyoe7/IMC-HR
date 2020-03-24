//
//  Routes.swift
//  IMC-HR
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct Routes {
    enum Get {
        
        /// Dashboard data route.
        static let campusRange = API.BASE_URL + "/rest/hr/campus"
        static let dashboard = API.BASE_URL + "/rest/hr/dashboard"
        
        /// Check in route.
        static let checkIn = API.BASE_URL + "/rest/hr/attendance/checkin"
        
        /// Check out route.
        static let checkOut = API.BASE_URL + "/rest/hr/attendance/checkout"
        
        /// Payslip list route.
        static let payslip = API.BASE_URL + "/rest/hr/payslip"
        
        /// Payslip detail route.
        /// must provide payslip id at the end
        static let payslipDetail = API.BASE_URL + "/rest/hr/payslip/detail/"
        
        /// Leave Approval List route.
        static let leaveList = API.BASE_URL + "/rest/hr/leave/leavelist"
    }
    
    enum Post {
        
        /// Sign in User
        static let signIn = API.BASE_URL + "/rest/user/auth"
        
        /// Attendance List route.
        static let attendanceList = API.BASE_URL + "/rest/hr/attendance"
        
        /// Leave Appriove
        /// must provide leave id
        static let leaveApprove = API.BASE_URL + "/rest/hr/leave/leaveapprove/"
        
        /// Leave Cancel
        static let leaveCancel = API.BASE_URL + "/rest/hr/leave/leavecancel/"
        
        /// Request Leave
        static let requestLeave = API.BASE_URL + "/rest/hr/leave/requestleave"
    }
}
