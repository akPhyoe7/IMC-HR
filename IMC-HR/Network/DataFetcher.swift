//
//  DataFetcher.swift
//  IMC-HR
//
//  Created by admin on 12/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import Foundation
import Alamofire

class DataFetcher {
    
    static let sharedInstance = DataFetcher()
    
    let headers : HTTPHeaders = [
        "auth" : API.auth
    ]
    
    private init() {}
    
    func fetchCampusRange (Completion : @escaping ([CampusRangeResponse]) -> Void) {
        let route = URL(string: Routes.Get.campusRange)!
        AF.request(route,
                   method: .get,
                   headers: headers)
        .responseJSON{ (response) in
            switch response.result {
            case .success(_) :
                if let result = try? JSONDecoder().decode([CampusRangeResponse].self, from: response.data!) {
                    print(result)
                    Completion(result)
                } else {
                    print("failed to decode data")
                    Completion([CampusRangeResponse]())
                }
            case let .failure(error):
                print(error)
            }
        }.resume()
    }
    
    func fetchDashboard (Completion : @escaping (DashboardResponse) -> Void) {
        let route = URL(string: Routes.Get.dashboard)!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON{ (response) in
                switch response.result {
                case .success(_):
                    if let result = try? JSONDecoder().decode(DashboardResponse.self, from: response.data!) {
                        Completion(result)
                    } else {
                        print("failed to decode data")
                    }
                case let .failure(error):
                    print(error)
                }
        }.resume()
    }
    
    func fetchCheckIn (Completion : @escaping (String) -> Void) {
        let route = URL(string: Routes.Get.checkIn)!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON{ (response) in
                var message = ""
                switch response.result {
                case .success(_):
                    if let result = response.value as? [String:String] {
//                        message = result
//                        let JSON = result as! NSDictionary
                        message = result["msg"] ?? ""
                    }
                    Completion(message)
                case let .failure(error):
                    print(error)
                    Completion("error")
                }
        }.resume()
    }
    
    func fetchCheckOut (Completion : @escaping (String) -> Void) {
        let route = URL(string: Routes.Get.checkOut)!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON{ (response) in
                var message = ""
                switch response.result {
                case .success(_):
                    if let result = response.value as? [String:String] {
//                        let JSON = result as! NSDictionary
//                        message = (JSON["msg"] as? String) ?? ""
                        message = result["msg"] ?? ""
                    }
                    Completion(message)
                case let .failure(error):
                    print(error)
                    Completion("error")
                }
        }.resume()
    }
    
    func fetchAttendanceList (Completion : @escaping ([AttendanceResponse]) -> Void) {
        let route = URL(string: Routes.Get.attendanceList)!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON{ (response) in
                switch response.result {
                case .success(_):
                    if let result = try? JSONDecoder().decode([AttendanceResponse].self, from: response.data!) {
                        Completion(result)
                    } else {
                        print("failed to decode data")
                    }
                case let .failure(error):
                    print(error)
                }
        }.resume()
    }
    
    func fetchPayslipList (Completion : @escaping ([PayslipResponse]) -> Void) {
        let route = URL(string: Routes.Get.payslip)!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON{ (response) in
                switch response.result {
                case .success(_):
                    if let result = try? JSONDecoder().decode([PayslipResponse].self, from: response.data!) {
                        Completion(result)
                    } else {
                        print("failed to decode data")
                    }
                case let .failure(error):
                    print(error)
                }
        }.resume()
    }
    
}
