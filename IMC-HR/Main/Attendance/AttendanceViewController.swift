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
    @IBOutlet weak var scSelectMonth: UISegmentedControl!
    
    var attendanceList : Attendance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attendanceTableView.separatorColor = .clear
        customizeSC()
        initAttendanceListFetchRequest(month: "")
    }
    
    private func customizeSC() {
        self.scSelectMonth.backgroundColor = .clear
        self.scSelectMonth.tintColor = .clear
        self.scSelectMonth.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)], for: .normal)

        // Change text color and the font of the selected segment
        self.scSelectMonth.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(named: "BGPrimary") ?? UIColor.blue,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)], for: .selected)
        self.scSelectMonth.selectedSegmentIndex = 2
    }
    
    private func initAttendanceListFetchRequest(month : String) {
        CustomAlertView.shareInstance.showAlert(message: "Loading...", alertType: .loading)
        DataFetcher.sharedInstance.fetchAttendanceList(month: month) { [weak self] attendanceList in
            DispatchQueue.main.async {
                CustomAlertView.shareInstance.hideAlert()
                self?.attendanceList = attendanceList
                self?.setDataToMonthSegment(months: attendanceList.monthlist)
                self?.attendanceTableView.reloadData()
            }
        }
    }
    
    private func setDataToMonthSegment(months : [String]) {
        self.scSelectMonth.setTitle(months[0], forSegmentAt: 2)
        self.scSelectMonth.setTitle(months[1], forSegmentAt: 1)
        self.scSelectMonth.setTitle(months[2], forSegmentAt: 0)
    }
    
    @IBAction func selectMonthSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let monthList = self.attendanceList?.monthlist.count ?? 3
        let selectedMonth = self.attendanceList?.monthlist[monthList - selectedIndex - 1]
        initAttendanceListFetchRequest(month: selectedMonth ?? "")
    }
    //    private func getMonthData () {
//        if !((self.attendanceList?.staffAttendanceRep.count) != nil) {
//            let firstData = self.attendanceList?.staffAttendanceRep[0]
//            let dateString = firstData?.date ?? ""
//            var finalDateString = ""
//            let dateFormatterGet = DateFormatter()
//            dateFormatterGet.dateFormat = "dd-MM-yyyy"
//
//            let dateFormatterPrint = DateFormatter()
//            dateFormatterPrint.dateFormat = "E MMMM dd yyyy"
//
//            if let date = dateFormatterGet.date(from: dateString) {
//                finalDateString = dateFormatterPrint.string(from: date)
//                print(finalDateString)
//            } else {
//               print("There was an error decoding the date string")
//            }
//            let dateArray = finalDateString.components(separatedBy: " ")
//            self.lblMonth.text = dateArray[1]
//        }
//    }
}

//MARK: - TableViewSources
extension AttendanceViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceList?.staffAttendanceRep.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attendance = self.attendanceList?.staffAttendanceRep[indexPath.row]
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
    @IBOutlet weak var lblAttendanceStatus: UILabel!
    
    var data : StaffAttendanceRep? {
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
                lblAttendanceStatus.text = data.attendanceStatus
                if data.attendanceStatus == "PRESENT" {
                    lblAttendanceStatus.backgroundColor = UIColor(named: "BGGreen")
                }else{
                    lblAttendanceStatus.backgroundColor = UIColor.red
                }
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
