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
    
    var pancakes = Recipe(id: "1", owner: User(id: "1"))
    var cake = Recipe(id: "2", owner: User(id: "2"))
    var maffin = Recipe(id: "3", owner: User(id: "3"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        data.append(pancakes)
        data.append(cake)
        data.append(maffin)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        return cell
    }
}
