//
//  AddRecipeViewController.swift
//  BigMama
//
//  Created by Chen Eini on 15/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, LoginViewControllerDelegate {
    
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeSteps: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    func onLoginSuccess() {
    }
    
    func onLoginCancell() {
        //self.navigationController?.popViewController(animated: true);
        self.tabBarController?.selectedIndex = 0;
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    var newRecipe:Recipe?
    
    @IBAction func add(_ sender: Any) {
        addBtn.isEnabled = false;
        imageBtn.isEnabled = false;
        
        let recipe = Recipe(ownerId:Model.instance.getCurrentUserId());
        
        recipe.title = self.recipeTitle.text!
        recipe.steps = self.recipeSteps.text!
        
        guard let selectedImage = selectedImage else {
            Model.instance.addRecipe(recipe: recipe);
            newRecipe = recipe
            performSegue(withIdentifier: "newRecipeViewSegue", sender: self)
            return;
        }
        
        Model.instance.saveImage(image: selectedImage) { (url) in
            recipe.image = url;
            Model.instance.addRecipe(recipe: recipe);
            self.newRecipe = recipe
            self.performSegue(withIdentifier: "newRecipeViewSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newRecipeViewSegue"){
            let vc:RecipeViewController = segue.destination as! RecipeViewController
            vc.recipe = newRecipe
        }
    }
}
