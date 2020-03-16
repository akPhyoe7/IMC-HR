//
//  LeaveApprovalViewController.swift
//  IMC-HR
//
//  Created by admin on 10/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class LeaveApprovalViewController: UIViewController {

    @IBOutlet weak var leaveApprovalTableView: UITableView!
    
    var leaveApproveList : LeaveApprovalListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.leaveApprovalTableView.separatorColor = .clear
        
        initLeaveApprovalListFetchRequest()
    }
    
    private func initLeaveApprovalListFetchRequest() {
        DataFetcher.sharedInstance.fetchLeaveApprovalList() { [weak self] leaveList in
            DispatchQueue.main.async {
                self?.leaveApproveList = leaveList
                self?.leaveApprovalTableView.reloadData()
            }
        }
    }
}

extension LeaveApprovalViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaveApproveList?.leaveList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leaveList = self.leaveApproveList?.leaveList[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeaveApprovalTableViewCell.identifier, for: indexPath) as? LeaveApprovalTableViewCell else {
            return UITableViewCell()
        }
        cell.data = leaveList
        return UITableViewCell()
    }
}

extension LeaveApprovalViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

class LeaveApprovalTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblApproverName: UILabel!
    @IBOutlet weak var lblLeaveStatus: UILabel!
    
    var data : leaveList? {
        didSet{
            if let data = data {
                let photoUrl = data.photoUrl ?? ""
                self.imgProfile.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "img_IMCLogo"))
                self.lblName.text = data.name
                let leavetype = data.leaveType?.lowercased() ?? "-"
                self.lblLeaveType.text = "\(leavetype) leave request"
                self.lblDate.text = data.submitDate
                self.lblApproverName.text = UserDefaults.standard.string(forKey: "AccName")
                self.lblLeaveStatus.text = " \(data.leaveApproveStatus ?? "-") "
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onTouchApproveBtn(_ sender: Any) {
    }
    
    @IBAction func onTouchRejectBtn(_ sender: Any) {
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
