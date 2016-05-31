//
//  RecipeCellTableViewCell.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

class RecipeCellTableViewCell: UITableViewCell
{

    @IBOutlet weak var RecipeName: UILabel!
    
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var Procedure: UILabel!
    
    func setup(name: String, image: UIImage, procedure: String)
    {
        self.RecipeName.text = name
        self.Image.image = image
        self.Procedure.text = procedure        
        
        Image.layer.masksToBounds = true
        Image.layer.cornerRadius = 8
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
