//
//  ProfileViewController.swift
//  IMC-HR
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

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
        var empID = String(data.employeeId ?? 0)
        if empID == "0" {
            empID = "-"
        }
        self.lblEmployeeId.text = empID
        self.lblDepartment.text = data.department1
        self.lblRole.text = data.jobTitle
        self.lblEmail.text = data.loginId
        self.lblPhone.text = data.phoneNo
    }

    @IBAction func onTouchLogoutBtn(_ sender: Any) {
        //remove store auth token and go to sign in view
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out!", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "BGPrimary")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            let removeKey: Bool = KeychainWrapper.standard.removeObject(forKey: "auth")
                if removeKey{
                    UserDefaults.standard.removeObject(forKey: "AccName")
                    let rootViewController = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    let navigationController = UINavigationController(rootViewController: rootViewController!)
        //            appDelegate.window?.rootViewController = navigationController
        //            appDelegate.window?.makeKeyAndVisible()
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }else{
                    print("error in removing auth key")
                }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
