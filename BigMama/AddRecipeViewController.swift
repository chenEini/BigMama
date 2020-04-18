//
//  AddRecipeViewController.swift
//  BigMama
//
//  Created by Chen Eini on 15/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit
import Kingfisher

class AddRecipeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, LoginViewControllerDelegate {
    
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeSteps: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var recipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.isHidden = true
        
        if (recipe != nil)
        {
            recipeTitle.text = recipe?.title
            recipeSteps.text = recipe?.steps
            imageView.kf.setImage(with: URL(string: recipe!.image));
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        // if not logged in: go to login page
        if(!Model.instance.isLoggedIn()){
            let loginVc = LoginViewController.factory()
            loginVc.delegate = self
            show(loginVc, sender: self)
        }
    }
    
    func onLoginSuccess() {
    }
    
    func onLoginCancell() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    var selectedImage:UIImage?;
    
    @IBAction func image(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self;
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
    
    @IBAction func save(_ sender: Any) {
        spinner.isHidden = false
        saveBtn.isEnabled = false;
        imageBtn.isEnabled = false;
        
        if (recipe == nil){
            recipe = Recipe(ownerId:Model.instance.getCurrentUserId())
            recipe?.ownerName = Model.instance.getCurrentUserName()
        }
        
        recipe?.title = recipeTitle.text!
        recipe?.steps = recipeSteps.text!
        
        guard let selectedImage = selectedImage else {
            self.upsertRecipe(recipe: recipe!)
            return;
        }
        
        Model.instance.saveImage(image: selectedImage) { (url) in
            self.recipe?.image = url;
            self.upsertRecipe(recipe: self.recipe!)
        }
    }
    
    func upsertRecipe(recipe:Recipe){
        Model.instance.upsertRecpie(recipe: recipe);
        self.clear()
        
        if(self.tabBarController?.selectedIndex != 1)
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            let recipesVC = (self.tabBarController?.viewControllers![0])! as! UINavigationController
            recipesVC.popToRootViewController(animated: true)
            self.tabBarController?.selectedIndex = 0;
        }
    }
    
    func clear(){
        recipeTitle.text = ""
        recipeSteps.text = ""
        imageView.image = nil
        selectedImage = nil
        imageBtn.isEnabled = true
        saveBtn.isEnabled = true
        spinner.isHidden = true
    }
}
