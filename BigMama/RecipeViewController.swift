//
//  RecipeViewController.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeSteps: UITextView!
    
    var recipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if(!Model.instance.isLoggedIn()){
        //            let loginVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
        //            show(loginVc, sender: self)
        //        }
        
        userName.text = recipe?.owner.name
        recipeTitle.text = recipe?.title
        recipeImg.image = UIImage(named: "maffin")
        recipeSteps.text = recipe?.steps
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
