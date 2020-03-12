//
//  ProfileViewController.swift
//  IMC-HR
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmployeeId: UILabel!
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    var profile : DashboardResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfile.layer.masksToBounds = true
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.borderColor = UIColor(named: "BGPrimary")?.cgColor
        imgProfile.layer.cornerRadius = imgProfile.bounds.width / 2
        self.bindDataToView(data: profile)
    }
    
    private func bindDataToView(data : DashboardResponse) {
        let photoUrl = data.photoUrl ?? ""
        self.imgProfile.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "img_IMCLogo"))
        self.lblName.text = data.name
        self.lblEmployeeId.text = String(data.id ?? 0)
        self.lblDepartment.text = data.department1
        self.lblRole.text = data.jobTitle
        self.lblEmail.text = data.loginId
        self.lblPhone.text = data.phoneNo
    }

}
