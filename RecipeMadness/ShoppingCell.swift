//
//  ShoppingCell.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell
{
    @IBOutlet weak var SNO: UILabel!
    
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Qty: UILabel!
    
    @IBOutlet weak var Units: UILabel!
    
    func setup(sno:Int, name:String, units: String, qty: Double)
    {
        self.SNO.text = sno.description
        self.Name.text = name
        self.Units.text = units
        self.Qty.text = String(format: "%.2f", qty);
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
