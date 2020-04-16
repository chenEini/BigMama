//
//  UserProfileViewController.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginViewControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var recipeTableView: UITableView!
    
    var data = [Recipe]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        avatar.image = UIImage(named: "avatar")
//        if (currentUser?.avatar != "")
//        {
//            avatar.kf.setImage(with: URL(string: currentUser!.avatar));
//        }
        
        Model.instance.getUserRecipes{(data:[Recipe]?) in
            if data != nil{
                self.data = data!
                self.recipeTableView.reloadData()
            }
        }
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
        userName.text = Model.instance.getCurrentUserName()
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
    
    var selectedRecipe:Recipe?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RecipeViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeViewCell
        
        let recipe = data[indexPath.row]
        
        cell.recipeTitle.text = recipe.title
        cell.recpieImg.image = UIImage(named: "maffin") // TEMP
        
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
