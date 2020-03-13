//
//  LeaveRequestViewController.swift
//  IMC-HR
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class LeaveRequestViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectLeaveView: DesignableView!
    @IBOutlet weak var lblLeaveTitle: UILabel!
    @IBOutlet weak var lblLeaveDayLeft: UILabel!
    @IBOutlet weak var selectStartDateView: DesignableView!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var selectEndDateView: DesignableView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var btnFullDay: UIButton!
    @IBOutlet weak var btnHalfDay: UIButton!
    @IBOutlet weak var selectHalfDayView: DesignableView!
    @IBOutlet weak var lblHalfDay: UILabel!
    @IBOutlet weak var tvReason: UITextView!
    
    var dashboardResponse : DashboardResponse?
    var leaveList : [String: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerKeyboardObserver()
        
        addGestureToView()
        
        initValues()
        
        self.leaveList = ["Casual Leave": dashboardResponse?.casualleave ?? 0,
                    "Annual Leave": dashboardResponse?.annualleave ?? 0,
                    "Medical Leave": dashboardResponse?.medicalleave ?? 0,
                    "Maternity Leave": dashboardResponse?.maternityleave ?? 0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.leaveList?.removeAll()
        scrollView.contentInset.bottom = 0
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func initValues () {
        btnFullDay.layer.backgroundColor = UIColor(named: "BGPrimary")?.cgColor
        btnFullDay.tintColor = UIColor.white

    }
    
    fileprivate func addGestureToView () {
        let selectLeaveGesture = UITapGestureRecognizer(target: self, action: #selector(selectLeave(_:)))
        selectLeaveView.addGestureRecognizer(selectLeaveGesture)
        
        let selectHalfDayGesture = UITapGestureRecognizer(target: self, action: #selector(selectHalfDayLeave(_:)))
        selectHalfDayView.addGestureRecognizer(selectHalfDayGesture)
    }
    
    @objc func selectLeave(_ sender:UITapGestureRecognizer) {
        showLeaveSelectionAlert(leaves: self.leaveList!)
    }
    
    @objc func selectHalfDayLeave(_ sender:UITapGestureRecognizer) {
        showHalfDaySelectionAlert ()
    }
    
    func showLeaveSelectionAlert (leaves : [String:Int]) {
        let alert = UIAlertController(title: "Leave Type", message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "BGPrimary")

        for leave in leaves {
            alert.addAction(UIAlertAction(title: leave.key, style: .default, handler: { (_) in
                self.lblLeaveTitle.text = leave.key
                self.lblLeaveDayLeft.text = "\(leave.value) days left"
            }))
        }
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    func showHalfDaySelectionAlert () {
        let alert = UIAlertController(title: "Select Type", message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "BGPrimary")
        
        alert.addAction(UIAlertAction(title: "Morning Leave", style: .default, handler: { (_) in
            self.lblHalfDay.text = "Morning Leave"
        }))
        
        alert.addAction(UIAlertAction(title: "Evening Leave", style: .default, handler: { (_) in
            self.lblHalfDay.text = "Evening Leave"
        }))
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTouchBtnFullDay(_ sender: Any) {
        self.radioButton(fullDay: true)
        
        self.selectHalfDayView.isUserInteractionEnabled = false
    }
    
    @IBAction func onTouchBtnHalfDay(_ sender: Any) {
        self.radioButton(fullDay: false)
        
        self.selectHalfDayView.isUserInteractionEnabled = true
    }
    
    fileprivate func radioButton(fullDay : Bool) {
        if fullDay{
            btnFullDay.layer.backgroundColor = UIColor(named: "BGPrimary")?.cgColor
            btnFullDay.tintColor = .white
            btnHalfDay.layer.backgroundColor = UIColor.white.cgColor
            btnHalfDay.tintColor = UIColor(named: "BGPrimary")
        }else{
            btnFullDay.layer.backgroundColor = UIColor.white.cgColor
            btnFullDay.tintColor = UIColor(named: "BGPrimary")
            btnHalfDay.layer.backgroundColor = UIColor(named: "BGPrimary")?.cgColor
            btnHalfDay.tintColor = .white
        }
    }
    
    // MARK:- Keyboard Notification
    fileprivate func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrame.size.height), animated: true)
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
