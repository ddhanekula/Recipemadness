//
//  LaunchController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/23/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit

class LaunchController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func fgewfew(sender: AnyObject)
    {
        
    }
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var index = 0
        switch(segue.identifier!)
        {
        case "RecipeBook":
            index = 1
            break
        case "MealCalendar":
            index = 2
            break
        case "ShoppingCart":
            index = 3
            break
        default: index = 0
            break
        }
        (segue.destinationViewController as! TabBarController).selectedIndex = index
    }


}
