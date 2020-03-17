//
//  PayslipDetailViewController.swift
//  IMC-HR
//
//  Created by admin on 10/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class PayslipDetailViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblBasicSalary: UILabel!
    @IBOutlet weak var lblNetSalary: UILabel!
    @IBOutlet weak var creditStackView: UIStackView!
    @IBOutlet weak var debitStackView: UIStackView!
    @IBOutlet weak var lblAmtBasicSalary: UILabel!
    @IBOutlet weak var lblAmtOfficeLate: UILabel!
    @IBOutlet weak var lblAmtWithoutPay: UILabel!
    @IBOutlet weak var lblAmtOTAllowance: UILabel!
    
    var id : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPayslipDetailFetchRequest(id: id!)
    }
    
    private func initPayslipDetailFetchRequest(id : Int) {
        DataFetcher.sharedInstance.fetchPayslipDetail(payslipId: id) { [weak self] payslip in
            DispatchQueue.main.async {
                self?.bindDataToView(data: payslip)
            }
        }
    }
    
    private func bindDataToView(data : PayslipDetailResponse) {
        let photoUrl = ""
        self.imgProfile.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "img_IMCLogo"))
        self.lblName.text = data.staffName
        self.lblBasicSalary.text = "\(data.basicSalary ?? 0) MMK"
        self.lblNetSalary.text = "\(data.netPay ?? 0) MMK"
        self.lblAmtBasicSalary.text = "\(data.basicSalary ?? 0) MMK"
        self.lblAmtOTAllowance.text = "\(data.totalOTEarning ?? 0) MMK"
        self.lblAmtOfficeLate.text = "-\(data.totalLatePayCut ?? 0) MMK"
        self.lblAmtWithoutPay.text = "-\(data.totalLeavePayCut ?? 0) MMK"
        for item in data.paySlipItemRepList {
            if item.accountingEntry == "CREDIT"{
                creditStackView.addArrangedSubview(WidgetGenerator.getPayslipListView(info: item.name ?? "", amt: item.amount ?? 0, entry: item.accountingEntry ?? "", width: creditStackView.frame.width))
//                creditStackView.spacing = 30
            } else {
                debitStackView.addArrangedSubview(WidgetGenerator.getPayslipListView(info: item.name ?? "", amt: item.amount ?? 0, entry: item.accountingEntry ?? "", width: debitStackView.frame.width))
//                debitStackView.spacing = 30
            }
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
