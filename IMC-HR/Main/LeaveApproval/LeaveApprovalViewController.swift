//
//  LeaveApprovalViewController.swift
//  IMC-HR
//
//  Created by admin on 10/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class LeaveApprovalViewController: UIViewController, ReloadFormCell {
    
    @IBOutlet weak var leaveApprovalTableView: UITableView!
    
    var leaveApproveList : LeaveApprovalListResponse?
    var lblNotApprove = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.leaveApprovalTableView.separatorColor = .clear
        self.leaveApprovalTableView.allowsSelection = false
        
        initLeaveApprovalListFetchRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.lblNotApprove.removeFromSuperview()
        self.leaveApprovalTableView.isHidden = false
    }
    
    private func initLeaveApprovalListFetchRequest() {
        DataFetcher.sharedInstance.fetchLeaveApprovalList() { [weak self] leaveList in
            DispatchQueue.main.async {
                self?.leaveApproveList = leaveList
                let canApprove = leaveList.canApprove ?? false
                if canApprove {
                    self?.leaveApprovalTableView.reloadData()
                } else {
                    self?.addCantApproveLbl()
                }
            }
        }
    }
    
    fileprivate func addCantApproveLbl() {
        self.leaveApprovalTableView.isHidden = true
        self.lblNotApprove = WidgetGenerator.getLabel("You Can't Approve Leaves!")
        self.view.addSubview(self.lblNotApprove)
        self.lblNotApprove.translatesAutoresizingMaskIntoConstraints = false
        self.lblNotApprove.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.lblNotApprove.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
    }
    
    func UpdateTableView() {
        self.leaveApprovalTableView.setContentOffset(.zero, animated: true)
        self.initLeaveApprovalListFetchRequest()
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
        cell.delegate = self
        cell.data = leaveList
        return cell
    }
}

extension LeaveApprovalViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

protocol ReloadFormCell: class {
    func UpdateTableView()
}

class LeaveApprovalTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblApproverName: UILabel!
    @IBOutlet weak var lblLeaveStatus: UILabel!
    @IBOutlet weak var btnStackView: UIStackView!
    
    weak var delegate: ReloadFormCell?
    var timer = Timer()
    
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
                if data.leaveApproveStatus == "PENDING" {
                    lblLeaveStatus.backgroundColor = UIColor(named: "BGYellow")
                    btnStackView.isHidden = false
                } else if data.leaveApproveStatus == "APPROVED" {
                    lblLeaveStatus.backgroundColor = UIColor(named: "BGGreen")
                    btnStackView.isHidden = true
                } else {
                    lblLeaveStatus.backgroundColor = UIColor.red
                    btnStackView.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onTouchApproveBtn(_ sender: Any) {
        guard let id = data?.id else {
            return
        }
        DataFetcher.sharedInstance.fetchLeaveApprove(leaveID: id) { [weak self] message in
            DispatchQueue.main.async {
                if message == "success" {
                    CustomAlertView.shareInstance.showAlert(message: "Approve Success", alertType: .success)
                } else {
                    CustomAlertView.shareInstance.showAlert(message: "Approve Fail", alertType: .fail)
                }
                self?.hideCustomAlert()
            }
        }
    }
    
    @IBAction func onTouchRejectBtn(_ sender: Any) {
        guard let id = data?.id else {
            return
        }
        DataFetcher.sharedInstance.fetchLeaveApprove(leaveID: id) { [weak self] message in
            DispatchQueue.main.async {
                if message == "success" {
                    CustomAlertView.shareInstance.showAlert(message: "Reject Success", alertType: .success)
                } else {
                    CustomAlertView.shareInstance.showAlert(message: "Reject Fail", alertType: .fail)
                }
                self?.hideCustomAlert()
            }
        }
    }
    
    private func hideCustomAlert() {
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(self.timeExpired), userInfo: nil, repeats: false)
    }
    
    @objc func timeExpired() {
        timer.invalidate()
        CustomAlertView.shareInstance.hideAlert()
        self.delegate?.UpdateTableView()
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
