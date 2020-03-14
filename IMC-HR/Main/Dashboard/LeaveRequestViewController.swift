//
//  LeaveRequestViewController.swift
//  IMC-HR
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit

class LeaveRequestViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectLeaveView: DesignableView!
    @IBOutlet weak var lblLeaveTitle: UILabel!
    @IBOutlet weak var lblLeaveDayLeft: UILabel!
    @IBOutlet weak var selectStartDateView: DesignableView!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var selectEndDateView: DesignableView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var scLeaveTime: UISegmentedControl!
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
        self.leaveList = ["Casual Leave": dashboardResponse?.casualleave ?? 0,
        "Annual Leave": dashboardResponse?.annualleave ?? 0,
        "Medical Leave": dashboardResponse?.medicalleave ?? 0,
        "Maternity Leave": dashboardResponse?.maternityleave ?? 0]
        // selected option color
        scLeaveTime.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "BGPrimary")!], for: .selected)
        // color of other options
        scLeaveTime.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        self.setupToHideKeyboardOnTapOnView()
        self.tvReason.delegate = self
        tvReason.text = "Add a Reason"
        tvReason.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a Reason"
            textView.textColor = UIColor.lightGray
        }
    }
    
    fileprivate func addGestureToView () {
        let selectLeaveGesture = UITapGestureRecognizer(target: self, action: #selector(selectLeave(_:)))
        selectLeaveView.addGestureRecognizer(selectLeaveGesture)
        
        let selectHalfDayGesture = UITapGestureRecognizer(target: self, action: #selector(selectHalfDayLeave(_:)))
        selectHalfDayView.addGestureRecognizer(selectHalfDayGesture)
        
        let selectDatePickingGesture = UITapGestureRecognizer(target: self, action: #selector(selectDatePicking(_:)))
        let selectDatePickingGesture2 = UITapGestureRecognizer(target: self, action: #selector(selectDatePicking(_:)))
        selectStartDateView.addGestureRecognizer(selectDatePickingGesture)
        selectEndDateView.addGestureRecognizer(selectDatePickingGesture2)
    }
    
    @objc func selectLeave(_ sender:UITapGestureRecognizer) {
        showLeaveSelectionAlert(leaves: self.leaveList!)
    }
    
    @objc func selectHalfDayLeave(_ sender:UITapGestureRecognizer) {
        showHalfDaySelectionAlert()
    }
    
    @objc func selectDatePicking(_ sender:UITapGestureRecognizer) {
        showDateTiemPicker()
    }
    
    //MARK: - Selection Alerts
    func showLeaveSelectionAlert (leaves : [String:Int]) {
        let alert = UIAlertController(title: "Leave Type", message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "BGPrimary")

        for leave in leaves {
            alert.addAction(UIAlertAction(title: "\(leave.key) - \(leave.value) day(s) left", style: .default, handler: { (_) in
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
    
    private func showDateTiemPicker() {
        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
        datePicker.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant: 0).isActive = true
        datePicker.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: 0).isActive = true
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ontouchLeaveSegment(_ sender: Any) {
        switch scLeaveTime.selectedSegmentIndex {
        case 0:
            self.selectHalfDayView.isUserInteractionEnabled = false
        case 1:
            self.selectHalfDayView.isUserInteractionEnabled = true
        default:
            break;
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
