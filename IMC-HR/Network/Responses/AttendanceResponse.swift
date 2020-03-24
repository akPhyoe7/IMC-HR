//
//  AttendanceResponse.swift
//  IMC-HR
//
//  Created by admin on 12/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct Attendance: Codable {
    let staffAttendanceRep: [StaffAttendanceRep]
    let monthlist: [String]
}

// MARK: - StaffAttendanceRep
struct StaffAttendanceRep: Codable {
    let date, arrivalTime, departureTime: String?
    let leaveType: String?
    let remark, attendanceStatus: String?
    let holidayName: String?
}
