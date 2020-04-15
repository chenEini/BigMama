//
//  RegisterViewController.swift
//  BigMama
//
//  Created by Chen Eini on 15/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTv: UITextField!
    @IBOutlet weak var emailTv: UITextField!
    @IBOutlet weak var pwdTv: UITextField!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        pwdTv.isSecureTextEntry = true
        msgLabel.alpha = 0
    }
    
    @IBAction func register(_ sender: UIButton){
        let error = validateFields()
        if error != nil{
            showMsg(error!)
        }
        else{
            let new_user = User(name: nameTv.text!, email: emailTv.text!, pwd: pwdTv.text!)
            Model.instance.register(user:new_user){(success) in
                if(success){
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    showMsg("Registration failed")
                }
            }
        }
    }
    
    func validateFields() -> String?{
        if nameTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pwdTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
    func showMsg(_ message:String){
        msgLabel.text = message
        msgLabel.alpha = 1
    }
}
