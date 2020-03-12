//
//  DashboardViewController.swift
//  IMC-HR
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit
import SDWebImage

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var ViewReqAnnual: UIView!
    @IBOutlet weak var lblAnnualDays: UILabel!
    @IBOutlet weak var ViewReqCasual: UIView!
    @IBOutlet weak var lblCasualDays: UILabel!
    @IBOutlet weak var ViewReqMedical: UIView!
    @IBOutlet weak var lblMedicalDays: UILabel!
    @IBOutlet weak var ViewReqMaternity: UIView!
    @IBOutlet weak var lblMaternityDays: UILabel!
    @IBOutlet weak var dashboardItemCollectionView: UICollectionView!
    
    let dashboardItemList : [itemData] = dashboardItemsData.sharedInstance.items
    var dashboardData : DashboardResponse!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///hide shadow under the navigation bar and change bar text color
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "BGPrimary")!]
        
        self.imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        
        initCampusRangeFetchRequest()
        
        initDashboardFetchRequest()
        
        setCollectionViewLayout()
        
        dashboardItemCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func onTouchCheckInBtn(_ sender: Any) {
        DataFetcher.sharedInstance.fetchCheckIn() { message in
            if message == "success" {
                CustomAlertView.shareInstance.showAlert(message: "Checkin Successful", alertType: .success)
            } else {
                CustomAlertView.shareInstance.showAlert(message: "Checkin Fail", alertType: .fail)
            }
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(self.timeExpired), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func onTouchCheckOutBtn(_ sender: Any) {
        DataFetcher.sharedInstance.fetchCheckOut() { message in
            if message == "success" {
                CustomAlertView.shareInstance.showAlert(message: "Checkout Successful", alertType: .success)
            } else {
                CustomAlertView.shareInstance.showAlert(message: "Checkout Fail", alertType: .fail)
            }
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(self.timeExpired), userInfo: nil, repeats: false)
        }
    }
    
    @objc func timeExpired() {
        timer.invalidate()
        CustomAlertView.shareInstance.hideAlert()
    }
    
    fileprivate func initCampusRangeFetchRequest() {
        DataFetcher.sharedInstance.fetchCampusRange() { campusRanges in
            DispatchQueue.main.async {
                campusRanges.forEach{ CampusRange in
                    print("campus ranges : ", CampusRange)
                }
            }
        }
    }
    
    fileprivate func initDashboardFetchRequest() {
        CustomAlertView.shareInstance.showAlert(message: "Loading", alertType: .loading)
        DataFetcher.sharedInstance.fetchDashboard() { [weak self] dashboardResponse in
            DispatchQueue.main.async {
                self?.dashboardData = dashboardResponse
                //Bind data to View
                self?.bindDashboardData(data: dashboardResponse)
            }
        }
    }
    
    fileprivate func bindDashboardData(data : DashboardResponse) {
        CustomAlertView.shareInstance.hideAlert()
        let photoUrl = data.photoUrl ?? ""
        self.imgProfile.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "img_IMCLogo"))
        self.lblName.text = data.name
        self.lblPosition.text = data.jobTitle
        self.lblAnnualDays.text = String(data.annualleave ?? 0)
        self.lblCasualDays.text = String(data.casualleave ?? 0)
        self.lblMedicalDays.text = String(data.medicalleave ?? 0)
        self.lblMaternityDays.text = String(data.maternityleave ?? 0)
    }
    
    //Setup CollectionView Layout
    fileprivate func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        self.dashboardItemCollectionView?.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoProfile" {
            if let nextViewController = segue.destination as? ProfileViewController {
                nextViewController.profile = self.dashboardData
            }
        }
    }
    
//    func touchAnimation(view: UIView) {
//        //tap recoginze animation
//        UIView.animate(withDuration: 0.1) {
//            view.backgroundColor = .lightGray
//        }
//        UIView.animate(withDuration: 0.1) {
//            view.backgroundColor = .white
//        }
//    }
}

extension DashboardViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dashboardItemList[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardItemCollectionViewCell.identifier, for: indexPath) as? DashboardItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.data = item
        return cell
    }
}

extension DashboardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dashboardItemList[indexPath.row]
        let segueName = item.segueName
        self.performSegue(withIdentifier: segueName, sender: self)
    }
}

extension DashboardViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 30)/3;
        return CGSize(width: width, height: 130)
    }
    
    
}

class DashboardItemCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imgItemIcon: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    
    var data : itemData? {
        didSet {
            if let data = data {
                imgItemIcon.image = UIImage(named: data.iconImg)
                lblItemName.text = data.itemLabel
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 5
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}