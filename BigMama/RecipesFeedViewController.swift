//
//  ViewController.swift
//  BigMama
//
//  Created by Chen Eini on 08/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class RecipesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Model.instance.getAllRecipes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RecipeViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeViewCell
        
        let recipe = data[indexPath.row]
        
        cell.userName.text = "user number : " + recipe.owner.id
        cell.recpieImg = nil
        cell.recipeTitle.text = recipe.title
        
        return cell
    }
}
