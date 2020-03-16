//
//  AttendanceViewController.swift
//  IMC-HR
//
//  Created by admin on 10/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {

    @IBOutlet weak var attendanceTableView: UITableView!
    
    var attendanceList : [AttendanceResponse]?
    @IBOutlet weak var lblMonth: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attendanceTableView.separatorColor = .clear
        initAttendanceListFetchRequest()
    }
    
    private func initAttendanceListFetchRequest() {
        DataFetcher.sharedInstance.fetchAttendanceList() { [weak self] attendanceList in
            DispatchQueue.main.async {
                self?.attendanceList = attendanceList
                self?.getMonthData()
                self?.attendanceTableView.reloadData()
            }
        }
    }
    
    private func getMonthData () {
        if !((self.attendanceList?.count) != nil) {
            let firstData = self.attendanceList?[0]
            let dateString = firstData?.date ?? ""
            var finalDateString = ""
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd-MM-yyyy"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "E MMMM dd yyyy"

            if let date = dateFormatterGet.date(from: dateString) {
                finalDateString = dateFormatterPrint.string(from: date)
                print(finalDateString)
            } else {
               print("There was an error decoding the date string")
            }
            let dateArray = finalDateString.components(separatedBy: " ")
            self.lblMonth.text = dateArray[1]
        }
    }
}

//MARK: - TableViewSources
extension AttendanceViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attendance = self.attendanceList?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceTableViewCell.identifier, for: indexPath) as? AttendanceTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.data = attendance
        return cell
    }
}

extension AttendanceViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - AttendanceTableView Cell
class AttendanceTableViewCell : UITableViewCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    
    var data : AttendanceResponse? {
        didSet {
            if let data = data {
                let dateString = data.date ?? ""
                var finalDateString = ""
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd-MM-yyyy"

                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "E MMMM dd yyyy"

                if let date = dateFormatterGet.date(from: dateString) {
                    finalDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the date string")
                }
                let dateArray = finalDateString.components(separatedBy: " ")
                lblDay.text = dateArray[0]
                lblDate.text = dateArray[2]
                lblArrivalTime.text = data.arrivalTime
                lblDepartureTime.text = data.departureTime
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}


//et dateString = "2018-12-24 18:00:00 UTC"
//let formatter = DateFormatter()
//formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
//guard let date = formatter.date(from: dateString) else {
//    return
//}
//
//formatter.dateFormat = "yyyy"
//let year = formatter.string(from: date)
//formatter.dateFormat = "MM"
//let month = formatter.string(from: date)
//formatter.dateFormat = "dd"
//let day = formatter.string(from: date)
//print(year, month, day) // 2018 12 24
