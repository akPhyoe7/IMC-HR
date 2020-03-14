//
//  SiginResponse.swift
//  IMC-HR
//
//  Created by admin on 15/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation

struct SigninResponse : Codable {
    let authenticated : Bool?
    let authenticationToken : String?
    let errorMessage : String?
}
