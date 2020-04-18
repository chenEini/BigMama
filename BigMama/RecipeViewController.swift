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
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var recipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserId = Model.instance.getCurrentUserId()
        
        editBtn.isHidden = currentUserId != recipe?.ownerId
        deleteBtn.isHidden = currentUserId != recipe?.ownerId
        
        userName.text = recipe?.ownerName
        recipeTitle.text = recipe?.title
        recipeImg.kf.setImage(with: URL(string: recipe!.image));
        recipeSteps.text = recipe?.steps
    }
    
    @IBAction func editRecipe(_ sender: Any) {
        if (recipe != nil) {
            performSegue(withIdentifier: "editRecipeSegue", sender: self)
        }
    }
    
    @IBAction func deleteRecipe(_ sender: Any) {
        if (recipe != nil) {
            Model.instance.deleteRecipe(recipe:recipe!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editRecipeSegue"){
            let vc:AddRecipeViewController = segue.destination as! AddRecipeViewController
            vc.recipe = recipe!
        }
    }
}
