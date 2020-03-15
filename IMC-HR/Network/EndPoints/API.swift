//
//  API.swift
//  IMC-HR
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct API {
    static let BASE_URL = "http://www.infomyanmar.cloud"
    
    static let auth: String! = KeychainWrapper.standard.string(forKey: "auth") ?? ""
    
//    static let auth = "Bearer eyJzdHVkZW50aWQiOm51bGwsInNjaG9vbGlkIjoyLCJuYW1lIjoiTWF2IFRlc3QgU3RhZmYgSm9obiIsImFjY291bnR0eXBlIjoiU1RBRkYiLCJ0eXAiOiJKV1QiLCJ1c2VyaWQiOjMzMjEsImFsZyI6IkhTMjU2In0.eyJzdWIiOiJNYXYgVGVzdCBTdGFmZiBKb2huIiwibmFtZSI6Ik1hdiBUZXN0IFN0YWZmIEpvaG4iLCJpc3MiOiJzaG1nbXQiLCJleHAiOjE1ODQ0MzU5NTcsImlhdCI6MTU4NDAwMzk1N30.eL22lfvHV_1-oji5z8UN2VaoEt7wNOGW7W8J3_BlVqY"
}
