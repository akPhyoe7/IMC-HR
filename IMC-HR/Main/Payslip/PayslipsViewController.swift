//
//  PayslipsViewController.swift
//  IMC-HR
//
//  Created by admin on 10/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class PayslipsViewController: UIViewController {

    @IBOutlet weak var payslipsTableView: UITableView!
    
    var payslipList : [PayslipResponse]?
    var firstMonth : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.payslipsTableView.separatorColor = .clear
        initPayslipListFetchRequest()
    }
    
    private func initPayslipListFetchRequest() {
        DataFetcher.sharedInstance.fetchPayslipList() { [weak self] payslips in
            DispatchQueue.main.async {
                self?.payslipList = payslips
                self?.firstMonth = payslips[0].month
                self?.payslipsTableView.reloadData()
            }
        }
    }
    
//MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoPayslipDetail" {
            if let detailViewController = segue.destination as? PayslipDetailViewController {
                detailViewController.id = sender as? Int
            }
        }
    }
}

//MARK: - TableViewSources
extension PayslipsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payslipList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sameMonth = false
        let payslip = self.payslipList?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PayslipTableViewCell.identifier, for: indexPath) as? PayslipTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row != 0{
            if self.firstMonth == payslip?.month {
                sameMonth = true
            }else{
                self.firstMonth = payslip?.month
                sameMonth = false
            }
        }
        cell.sameM = sameMonth
        cell.data = payslip
        return cell
    }
}

extension PayslipsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payslip = self.payslipList?[indexPath.row]
        let id = payslip?.id
        self.performSegue(withIdentifier: "gotoPayslipDetail", sender: id)
    }
}

//MARK: - TableView Cell
class PayslipTableViewCell : UITableViewCell {
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var lblBasicSalary: UILabel!
    
    var sameM : Bool?
    var data : PayslipResponse? {
        didSet{
            if let data = data {
                if sameM == true{
                    lblMonth.text = ""
                    lblYear.text = ""
                }else{
                    lblMonth.text = data.month
                    lblYear.text = data.year
                }
                lblName.text = data.staffName
                lblDepartment.text = data.department1
                lblBasicSalary.text = String(data.netPay ?? 0)
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
