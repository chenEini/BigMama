//
//  RecipeViewCell.swift
//  BigMama
//
//  Created by Chen Eini on 13.04.20.
//  Copyright © 2020 BigMama. All rights reserved.
//

import UIKit

class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var recpieImg: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
