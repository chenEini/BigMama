//
//  LoginViewController.swift
//  BigMama
//
//  Created by Chen Eini on 15/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func onLoginSuccess();
    func onLoginCancell();
}

class LoginViewController: UIViewController {
    var delegate:LoginViewControllerDelegate?
    
    @IBOutlet weak var emailTv: UITextField!
    @IBOutlet weak var pwdTv: UITextField!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginBtn: UIButton!
    
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.isHidden = true
        pwdTv.isSecureTextEntry = true
        msgLabel.alpha = 0
        
        //hook to the navigation back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
        
        if(Model.instance.isLoggedIn()){
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
        if let delegate = delegate {
            delegate.onLoginCancell()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        loginBtn.isHidden = true
        spinner.isHidden = false
        msgLabel.isHidden = true
        
        validateFields(){ (error) in
            if error != ""{
                self.showMsg(error!)
                self.spinner.isHidden = true
                
            }
            else{
                Model.instance.logIn(email: self.emailTv.text!, pwd: self.pwdTv.text!){ (success) in
                    
                    if(success){
                        //go back when the user logged in
                        self.navigationController?.popToRootViewController(animated: true)
                        if let delegate = self.delegate{
                            delegate.onLoginSuccess()
                        }
                    }
                    else{
                        self.showMsg("Login failed")
                    }
                    
                    self.loginBtn.isHidden = false
                    self.spinner.isHidden = true
                }
            }
        }
    }
    
    func validateFields(callback: @escaping (String?) -> Void){
        if emailTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pwdTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback("Please fill in all fields")
        }
        else {callback("")}
    }
    
    
    func showMsg(_ message:String){
        msgLabel.isHidden = false
        msgLabel.text = message
        msgLabel.alpha = 1
        loginBtn.isHidden = false
        
    }
}
