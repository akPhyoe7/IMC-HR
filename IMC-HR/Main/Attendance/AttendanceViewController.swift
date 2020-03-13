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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attendanceTableView.separatorColor = .clear
        initAttendanceListFetchRequest()
    }
    
    private func initAttendanceListFetchRequest() {
        DataFetcher.sharedInstance.fetchAttendanceList() { [weak self] attendanceList in
            DispatchQueue.main.async {
                self?.attendanceList = attendanceList
                self?.attendanceTableView.reloadData()
            }
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
                lblDay.text = data.date
                lblDate.text = "9"
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
