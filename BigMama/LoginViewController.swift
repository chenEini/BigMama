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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hook to the navigation back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        //        performSegue(withIdentifier: "cancelLoginSegue", sender: self)
        self.navigationController?.popViewController(animated: true);

        if let delegate = delegate{
            delegate.onLoginCancell()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        Model.instance.logIn(email: email.text!, pwd: pwd.text!) { (success) in
            if(success){
                //go back when logged in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
