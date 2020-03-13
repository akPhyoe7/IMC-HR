//
//  PayslipDetailResponse.swift
//  IMC-HR
//
//  Created by admin on 13/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct PayslipDetailResponse : Codable {
    let id : Int?
    let staffName : String?
    let basicSalary : Int?
    let totalOTEarning : Int?
    let totalLeavePayCut : Int?
    let totalLatePayCut : Int?
    let netPay : Int?
    let issueDate : String?
    let startDate : String?
    let endDate : String?
    let paySlipItemRepList : [paySlipItemRepList]
}

struct paySlipItemRepList : Codable {
    let id : Int?
    let name : String?
    let amount : String?
    let salaryType : String?
    let accountingEntry : String?
}
