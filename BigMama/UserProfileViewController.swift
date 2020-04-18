//
//  UserProfileViewController.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginViewControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var recipeTableView: UITableView!
    
    var data = [Recipe]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.userName.text = Model.instance.getCurrentUserName()
        
        let userAvatar = Model.instance.getCurrentUserAvatar()
        if userAvatar != "" { avatar.kf.setImage(with: URL(string: userAvatar)) }
        else { avatar.image = UIImage(named: "avatar") }
        
        ModelEvents.RecipesDataEvent.observe {
            self.getUserRecipes()
        }
        
        getUserRecipes()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
        
        if(!Model.instance.isLoggedIn()){
            let loginVc = LoginViewController.factory()
            loginVc.delegate = self
            show(loginVc, sender: self)
        }
    }
    
    func onLoginSuccess(){
        self.recipeTableView.reloadData()
    }
    
    func onLoginCancell(){
        self.tabBarController?.selectedIndex = 0;
    }
    
    func onLogOut(){
        self.tabBarController?.selectedIndex = 0;
    }
    
    @IBAction func logout(_ sender: UIButton){
        Model.instance.logOut(){(success) in
            if (success) { onLogOut() }
        }
    }
    
    func getUserRecipes(){
        Model.instance.getUserRecipes{(data:[Recipe]?) in
            if data != nil{
                self.data = data!
                self.recipeTableView.reloadData()
            }
        }
    }
    
    var selectedRecipe:Recipe?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RecipeViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeViewCell
        
        let recipe = data[indexPath.row]
        
        cell.recipeTitle.text = recipe.title
        cell.recipeImg.image = UIImage(named: "recipe")
    
        if recipe.image != "" { cell.recipeImg.kf.setImage(with: URL(string: recipe.image)) }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = data[indexPath.row]
        performSegue(withIdentifier: "myRecipeViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myRecipeViewSegue"){
            let vc:RecipeViewController = segue.destination as! RecipeViewController
            vc.recipe = selectedRecipe
        }
    }
}
