//
//  ViewController.swift
//  BigMama
//
//  Created by Chen Eini on 08/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class RecipesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    var data = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Model.instance.getAllRecipes{(data:[Recipe]?) in
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
        
        cell.userName.text = recipe.ownerName
        cell.recipeTitle.text = recipe.title
        cell.recipeImg.kf.setImage(with: URL(string: recipe.image));
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = data[indexPath.row]
        performSegue(withIdentifier: "recipeViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recipeViewSegue"){
            let vc:RecipeViewController = segue.destination as! RecipeViewController
            vc.recipe = selectedRecipe
        }
    }
}
