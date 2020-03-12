//
//  DashboardVO.swift
//  IMC-HR
//
//  Created by admin on 12/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

class DashbaordVO {
    var id : Int?
    var name : String?
    var photoUrl : String?
    var jobTitle : String?
    var loginId : String?
    var phoneNo : String?
    var department1 : String?
    var department2 : String?
    var casualleave : Int?
    var annualleave : Int?
    var medicalleave : Int?
    var maternityleave : Int?
    
    init() {}
    
    init(id: Int, name: String, photoUrl: String, jobTitle: String, loginId: String, phoneNo: String, department1: String, department2: String, casualleave: Int, annualleave: Int, medicalleave: Int, maternityleave: Int) {
        self.id = id
        self.name = name
        self.photoUrl = photoUrl
        self.jobTitle = jobTitle
        self.loginId = loginId
        self.phoneNo = phoneNo
        self.department1 = department1
        self.department2 = department2
        self.casualleave = casualleave
        self.annualleave = annualleave
        self.medicalleave = medicalleave
        self.maternityleave = maternityleave
    }
}
