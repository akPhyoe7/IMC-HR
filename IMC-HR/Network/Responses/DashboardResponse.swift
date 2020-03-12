//
//  DashboardResponse.swift
//  IMC-HR
//
//  Created by admin on 12/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct CampusRangeResponse : Codable {
    let id : Int?
    let longitude : String?
    let latitude : String?
    let range : Int?
}

struct DashboardResponse : Codable {
    let id : Int?
    let name : String?
    let photoUrl : String?
    let jobTitle : String?
    let loginId : String?
    let phoneNo : String?
    let department1 : String?
    let department2 : String?
    let casualleave : Int?
    let annualleave : Int?
    let medicalleave : Int?
    let maternityleave : Int?
    
    static func mapToVO (data : DashboardResponse) -> DashbaordVO {
        
        let dashboard = DashbaordVO()
        dashboard.id = data.id
        dashboard.name = data.name
        dashboard.photoUrl = data.photoUrl
        dashboard.jobTitle = data.jobTitle
        dashboard.loginId = data.loginId
        dashboard.phoneNo = data.phoneNo
        dashboard.department1 = data.department1
        dashboard.department2 = data.department2
        dashboard.casualleave = data.casualleave
        dashboard.annualleave = data.annualleave
        dashboard.medicalleave = data.medicalleave
        dashboard.maternityleave = data.medicalleave
        
        return dashboard
    }
}
