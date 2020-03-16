//
//  LeaveApprovalListResponse.swift
//  IMC-HR
//
//  Created by admin on 16/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct LeaveApprovalListResponse : Codable {
    let canApprove : Bool?
    let leaveList : [leaveList]
}

struct leaveList : Codable {
    let id : Int?
    let name : String?
    let photoUrl : String?
    let submitDate : String?
    let leaveType : String?
    let startDate : String?
    let endDate : String?
    let leaveApproveStatus : String?
}
