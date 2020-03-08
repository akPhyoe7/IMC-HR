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
        /// Dashboard data api.
        ///
        static let dashboard = API.BASE_URL + "/rest/hr/dashboard"
        
        /// Check in api.
        static let checkIn = API.BASE_URL + "/rest/hr/attendance/checkin"
        
        /// Check out api.
        static let checkOut = API.BASE_URL + "/rest/hr/attendance/checkout"
        
        /// Payslip list api.
        static let payslip = API.BASE_URL + "/rest/hr/payslip"
    }
    
    enum Post {
        
        static let signIn = API.BASE_URL + "/rest/user/auth"
    }
}
