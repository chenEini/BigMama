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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pwd: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        Model.instance.logIn(email: email.text!, pwd: pwd.text!) { (success) in
            if(success){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
