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
}
