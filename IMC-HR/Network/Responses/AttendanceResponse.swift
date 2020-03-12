//
//  AttendanceResponse.swift
//  IMC-HR
//
//  Created by admin on 12/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct AttendanceResponse : Codable {
    let date : String?
    let arrivalTime : String?
    let departureTime : String?
    let leaveType : String?
    let remark : String?
    let attendanceStatus : String?
    let holidayName : String?
}
