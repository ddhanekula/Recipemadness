//
//  AddRecipeIngredientController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/12/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

class AddRecipeIngredientController: UIViewController
{
    @IBOutlet weak var txtProcedure: UITextView!
    
    var appy = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    var parent: UIViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = appy.viewBackground
        
        txtProcedure.layer.masksToBounds = true
        txtProcedure.layer.cornerRadius = 8
        txtProcedure.backgroundColor = appy.labelViewBackground
        
        if let parentController = parent as? IngredientController
        {
            txtProcedure.text = parentController.recipeProcedure
        }
        else if let parentController = parent as? EditRecipeController
        {
            txtProcedure.text = parentController.recipe.procedure
        }
        txtProcedure.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveProcedure(sender: AnyObject)
    {
        if let parentController = parent as? IngredientController
        {
            parentController.recipeProcedure = txtProcedure.text
            self.navigationController?.popViewControllerAnimated(true)
        }
        else if let parentController = parent as? EditRecipeController
        {
            parentController.recipe.procedure = txtProcedure.text
            self.navigationController?.popViewControllerAnimated(true)
        }
    }   
    
}
