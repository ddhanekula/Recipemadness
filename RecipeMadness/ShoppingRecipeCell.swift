//
//  ShoppingRecipeCell.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/22/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit

class ShoppingRecipeCell: UITableViewCell
{
    @IBOutlet weak var SNO: UILabel!
    
    @IBOutlet weak var Name: UILabel!
    
    func setup(sno:Int, name:String)
    {
        self.SNO.text = sno.description
        self.Name.text = name
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
