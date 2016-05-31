//
//  MealCalendarViewCell.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

class MealCalendarViewCell: UITableViewCell
{
    
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var Timing: UILabel!
    
    @IBOutlet weak var RecipeName: UILabel!
    
//∫    @IBOutlet var image: UIImageView?
    
    func setup(date: String, timing: String, recipeName: String, image: UIImage)
{
        self.Date.text = date
        self.Timing.text = timing
        self.RecipeName.text = recipeName
//    self.Image.image = image
//        
//        Image.layer.masksToBounds = true
//        Image.layer.cornerRadius = 8
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
