//
//  RegisterViewController.swift
//  BigMama
//
//  Created by Chen Eini on 15/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameTv: UITextField!
    @IBOutlet weak var emailTv: UITextField!
    @IBOutlet weak var pwdTv: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        spinner.isHidden = true
        pwdTv.isSecureTextEntry = true
        msgLabel.alpha = 0
    }
    
    var selectedImage:UIImage?
    
    @IBAction func image(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        self.imageView.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func register(_ sender: UIButton){
        imageBtn.isEnabled = false
        registerBtn.isHidden = true
        spinner.isHidden = false
        msgLabel.isHidden = true
        
        validateFields(){ (error) in
            if error != "" {
                self.showMsg(error!)
                self.spinner.isHidden = true
                self.registerBtn.isHidden = false
                self.imageBtn.isEnabled = true
            }
            else{
                let new_user = User(name: self.nameTv.text!, email: self.emailTv.text!, pwd: self.pwdTv.text!)
                guard let selectedImage = self.selectedImage
                    else {
                        self.regAddition(user: new_user)
                        return
                    }
                
                Model.instance.saveImage(image: selectedImage) {(url) in
                    new_user.avatar = url
                    self.regAddition(user: new_user)
                }
            }
        }
        
    }
    
    func regAddition(user:User){
        Model.instance.register(user:user){(success) in
            if (success) {
                self.spinner.isHidden = true
                self.registerBtn.isHidden = false
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                self.showMsg("Registration failed")
            }
        }
    }
    
    func validateFields(callback: @escaping (String?) -> Void){
        if nameTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pwdTv.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback("Please fill in all fields")
        }
        
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        if !emailCheck.evaluate(with: emailTv.text){
            callback("Invalid email address")
        }
        
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        if !passwordCheck.evaluate(with: pwdTv.text){
           callback("Check your password contains 8 digits, at least one upper case and one lower case")
        }

        callback("")
    }
    
    func showMsg(_ message:String){
        msgLabel.text = message
        msgLabel.alpha = 1
    }
}
