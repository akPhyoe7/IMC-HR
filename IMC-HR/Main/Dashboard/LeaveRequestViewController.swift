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
    var startDate : Date = Date()
    var timer = Timer()
    
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
        scrollView.contentInset.bottom = 0
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func initValues () {
        // set leave type
        self.lblLeaveTitle.text = "Casual Leave"
        self.lblLeaveDayLeft.text = "\(self.dashboardResponse?.casualleave ?? 0) day(s) left"
        // set start date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM,yyyy"
        self.lblStartDate.text = dateFormatter.string(from: Date())
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
        
        let selectDatePickingGesture = UITapGestureRecognizer(target: self, action: #selector(selectStartDatePicking(_:)))
        let selectDatePickingGesture2 = UITapGestureRecognizer(target: self, action: #selector(selectEndDatePicking(_:)))
        selectStartDateView.addGestureRecognizer(selectDatePickingGesture)
        selectEndDateView.addGestureRecognizer(selectDatePickingGesture2)
    }
    
    @objc func selectLeave(_ sender:UITapGestureRecognizer) {
        showLeaveSelectionAlert()
    }
    
    @objc func selectHalfDayLeave(_ sender:UITapGestureRecognizer) {
        showHalfDaySelectionAlert()
    }
    
    @objc func selectStartDatePicking(_ sender:UITapGestureRecognizer) {
        showDateTimePicker(startDate: Date()) { [weak self] (date) in
            self?.lblStartDate.text = date
        }
    }
    
    @objc func selectEndDatePicking(_ sender:UITapGestureRecognizer) {
        showDateTimePicker(startDate: self.startDate) { [weak self] (date) in
             self?.lblEndDate.text = date
         }
    }
    
    @IBAction func onTouchDiscardBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTouchApplyBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Are you Sure", message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "BGPrimary")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            self.confirmLeaveRequest()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func confirmLeaveRequest() {
        
        let type = self.lblLeaveTitle.text ?? ""
        let typearray = type.components(separatedBy: " ")
        let leaveType = typearray.first?.uppercased() ?? ""
        
        let sDateString = self.lblStartDate.text ?? ""
        let eDateString = self.lblEndDate.text ?? ""
        var startDate = ""
        var endDate = ""
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd MMM,yyyy"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatterGet.date(from: sDateString) {
            startDate = dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the date string")
        }
        if let date = dateFormatterGet.date(from: eDateString) {
            endDate = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the date string")
        }
        
        var reason = ""
        let reasonText = self.tvReason.text
        if reasonText != "Add a Reason" {
            reason = reasonText ?? ""
        }
        
        let remainDayString = self.lblLeaveDayLeft.text ?? ""
        let remainDayArray = remainDayString.components(separatedBy: " ")
        let remainDay = Int(remainDayArray[0])
        if remainDay == 0 {
            self.showAndHideCustomAlert(msg: "no leave day left")
        }else if endDate == "" {
            self.showAndHideCustomAlert(msg: "must select end date")
        }else {
            DataFetcher.sharedInstance.fetchLeaveRequest(leaveType: leaveType, startDate: startDate, endDate: endDate, reason: reason) { [weak self] status in
                CustomAlertView.shareInstance.showAlert(message: "Loading", alertType: .loading)
                DispatchQueue.main.async {
                    if status == "success" {
                        CustomAlertView.shareInstance.hideAlert()
                        self?.navigationController?.popViewController(animated: true)
                    }else{
                        CustomAlertView.shareInstance.hideAlert()
                        self?.showAndHideCustomAlert(msg: "error while connecting")
                    }
                }
            }
        }
    }
    
    @objc func timeExpired() {
        timer.invalidate()
        CustomAlertView.shareInstance.hideAlert()
    }
    
    //MARK: - Selection Alerts
    private func showLeaveSelectionAlert () {
        let alert = UIAlertController(title: "Leave Type", message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "BGPrimary")
        
        alert.addAction(UIAlertAction(title: "Casual Leave - \(self.dashboardResponse?.casualleave ?? 0) day(s) left", style: .default, handler: { (_) in
            self.lblLeaveTitle.text = "Casual Leave"
            self.lblLeaveDayLeft.text = "\(self.dashboardResponse?.casualleave ?? 0) days left"
        }))
        alert.addAction(UIAlertAction(title: "Annual Leave - \(self.dashboardResponse?.annualleave ?? 0) day(s) left", style: .default, handler: { (_) in
            self.lblLeaveTitle.text = "Annual Leave"
            self.lblLeaveDayLeft.text = "\(self.dashboardResponse?.annualleave ?? 0) days left"
        }))
        alert.addAction(UIAlertAction(title: "Medical Leave - \(self.dashboardResponse?.medicalleave ?? 0) day(s) left", style: .default, handler: { (_) in
            self.lblLeaveTitle.text = "Medical Leave"
            self.lblLeaveDayLeft.text = "\(self.dashboardResponse?.medicalleave ?? 0) days left"
        }))
        alert.addAction(UIAlertAction(title: "Maternity Leave - \(dashboardResponse?.maternityleave ?? 0) day(s) left", style: .default, handler: { (_) in
            self.lblLeaveTitle.text = "Maternity Leave"
            self.lblLeaveDayLeft.text = "\(self.dashboardResponse?.maternityleave ?? 0) days left"
        }))
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    private func showHalfDaySelectionAlert () {
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
    
    private func showDateTimePicker(startDate : Date, Completion : @escaping (String) -> Void){
        var selectedDate : String = ""
        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.minimumDate = startDate
        
        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 25).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -25).isActive = true
        datePicker.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant: 0).isActive = true
        datePicker.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: 0).isActive = true
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (_) in
            self.startDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM,yyyy"
            selectedDate = dateFormatter.string(from: datePicker.date)
            Completion(selectedDate)
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
    
    private func showAndHideCustomAlert(msg : String) {
        CustomAlertView.shareInstance.showAlert(message: msg, alertType: .fail)
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(self.timeExpired), userInfo: nil, repeats: false)
    }

}
