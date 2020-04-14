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
    @IBOutlet weak var errorLabel: UILabel!
    
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwdTv.isSecureTextEntry = true
        errorLabel.alpha = 0
        
        //hook to the navigation back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "cancelLoginSegue", sender: self)
        //self.navigationController?.popViewController(animated: true);
        self.navigationController?.popViewController(animated: true);
        if let delegate = delegate{
            delegate.onLoginCancell()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        Model.instance.logIn(email: emailTv.text!, pwd: pwdTv.text!) { (success) in
            if(success){
                //go back when logged in
                self.navigationController?.popViewController(animated: true)
                if let delegate = delegate{
                    delegate.onLoginSuccess()
                }
            }
        }
    }
    
    
    
    //   override func viewDidAppear(_ animated: Bool) {
    //       super.viewDidAppear(animated)
    //   }
    
    //   override func viewWillAppear(_ animated: Bool) {
    //       super.viewWillAppear(animated)
    //   }
    
}
