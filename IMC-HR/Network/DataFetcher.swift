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
    
    //MARK: - POST REQUESTS
    func fetchLogin (username : String, password : String, Completion : @escaping (SigninResponse) -> Void) {
        let route = URL(string: Routes.Post.signIn)!
        let postHeaders : HTTPHeaders = [
            "Content-Type" : "application/json",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        let params : Parameters = [
            "username" : username,
            "password" : password
        ]
        AF.request(route,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: postHeaders)
            .responseJSON{ (response) in
                //For Network Error
                guard response.error == nil else {
                    print(response.error!)
                    return
                }
                switch response.result {
                case .success(_):
                    if let result = try? JSONDecoder().decode(SigninResponse.self, from: response.data!) {
                        Completion(result)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
        }.resume()
    }
    
    func fetchLeaveRequest (leaveType : String, startDate : String, endDate : String, reason : String, Completion : @escaping (String) -> Void) {
        let route = URL(string: Routes.Post.requestLeave)!
        let postHeaders : HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : API.auth
        ]
        let params : Parameters = [
            "leaveType" : leaveType,
            "startDate" : startDate,
            "endDate" : endDate,
            "reason" : reason
        ]
        AF.request(route,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: postHeaders)
            .responseJSON { (response) in
                //For Network Error
                guard response.error == nil else {
                    print(response.error!)
                    return
                }
                switch response.result {
                case .success(let data):
                    let resData = data as? [String:String]
                    Completion(resData?["msg"] ?? "success")
                case let .failure(error):
                    print(error.localizedDescription)
                }
        }.resume()
    }
 
    //MARK: - GET REQUESTS
    func fetchCampusRange (Completion : @escaping ([CampusRangeResponse]) -> Void) {
        let route = URL(string: Routes.Get.campusRange)!
        AF.request(route,
                   method: .get,
                   headers: headers)
        .responseJSON{ (response) in
            switch response.result {
            case .success(_) :
                if let result = try? JSONDecoder().decode([CampusRangeResponse].self, from: response.data!) {
                    Completion(result)
                } else {
                    print("failed to decode data in campus range")
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
                        print("failed to decode data in dashboard")
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
                        print("failed to decode data in attendance list")
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
                        print("failed to decode data in payslip list")
                    }
                case let .failure(error):
                    print(error)
                }
        }.resume()
    }
    
    func fetchPayslipDetail (payslipId : Int!, Completion : @escaping (PayslipDetailResponse) -> Void) {
        let route = URL(string: "\(Routes.Get.payslipDetail)\(payslipId!)")!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON{ (response) in
                switch response.result {
                case .success(_):
                    if let result = try? JSONDecoder().decode(PayslipDetailResponse.self, from: response.data!) {
                        Completion(result)
                    } else {
                        print("failed to decode data in payslip detail")
                    }
                case let .failure(error):
                    print(error)
                }
        }.resume()
    }
    
    func fetchLeaveApprovalList (Completion : @escaping (LeaveApprovalListResponse) -> Void) {
        let route = URL(string: Routes.Get.leaveList)!
        AF.request(route,
                   method: .get,
                   headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let result = try? JSONDecoder().decode(LeaveApprovalListResponse.self, from: response.data!) {
                        Completion(result)
                    }
                case let .failure(error):
                    print(error)
                }
        }
    }
}
