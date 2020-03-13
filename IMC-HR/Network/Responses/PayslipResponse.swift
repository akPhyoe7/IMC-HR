//
//  PayslipResponse.swift
//  IMC-HR
//
//  Created by admin on 13/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct PayslipResponse : Codable {
    let id : Int?
    let staffName : String?
    let netPay : Int?
    let department1 : String?
    let department2 : String?
    let month : String?
    let year : String?
}
