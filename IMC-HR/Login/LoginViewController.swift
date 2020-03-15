//
//  LoginViewController.swift
//  IMC-HR
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 akp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var svBackground: UIScrollView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPwd: UIButton!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardObserver()
        
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func initSigninFetchRequest(uname : String, pwd : String) {
        CustomAlertView.shareInstance.showAlert(message: "Loading", alertType: .loading)
        DataFetcher.sharedInstance.fetchLogin(username: uname, password: pwd) { [weak self] (signinData) in
            DispatchQueue.main.async {
                self?.checkSigninAuth(data: signinData)
            }
        }
    }
    
    fileprivate func checkSigninAuth(data : SigninResponse) {
        CustomAlertView.shareInstance.hideAlert()
        if data.authenticated! {
            let saveStatus: Bool = KeychainWrapper.standard.set(data.authenticationToken!, forKey: "auth")
            print("Keychain save : ", saveStatus)
            if saveStatus {
                self.performSegue(withIdentifier: "gotoMain", sender: self)
            }else{
                CustomAlertView.shareInstance.showAlert(message: "Sign in Failed!", alertType: .statusFail)
            }
        }else{
            CustomAlertView.shareInstance.showAlert(message: data.errorMessage!, alertType: .statusFail)
        }
    }
    
    @IBAction func onTouchShowPwdBtn(_ sender: Any) {
    }
    
    @IBAction func onTouchSignInBtn(_ sender: Any) {
        let username = tfEmail.text
        let password = tfPassword.text
        
        if username!.isEmpty || password!.isEmpty {
            CustomAlertView.shareInstance.showAlert(message: "User Name or Pasword should not be empty!", alertType: .statusFail)
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.timeExpired), userInfo: nil, repeats: false)
        } else {
            self.initSigninFetchRequest(uname: username!, pwd: password!)
        }
    }
    
    @objc func timeExpired() {
        timer.invalidate()
        CustomAlertView.shareInstance.hideAlert()
    }
    
    //dismiss keyboard by return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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

        var contentInset:UIEdgeInsets = self.svBackground.contentInset
        contentInset.bottom = keyboardFrame.size.height
        svBackground.contentInset = contentInset
        svBackground.setContentOffset(CGPoint(x: 0, y: keyboardFrame.size.height), animated: true)
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        svBackground.contentInset = contentInset
        svBackground.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
