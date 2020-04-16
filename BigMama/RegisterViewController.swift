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
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
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
        
        let error = validateFields()
        if error != nil{
            showMsg(error!)
        }
        else{
            let new_user = User(name: nameTv.text!, email: emailTv.text!, pwd: pwdTv.text!)
            guard let selectedImage = selectedImage else {
                self.regAddition(user: new_user)
                return
            }
            
            Model.instance.saveImage(image: selectedImage) {(url) in
                new_user.avatar = url
                self.regAddition(user: new_user)
            }
        }
    }
      
    func regAddition(user:User){
        Model.instance.register(user:user){(success) in
        if(success){
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            showMsg("Registration failed")
        }}
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
