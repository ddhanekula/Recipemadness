//
//  RecipeBookController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

//Added textfielddelegate by CG on Apr16
class RecipeBookController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate
{
    var recipes: [Recipe] = []
    var appy = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBOutlet weak var tableView: UITableView!
    
    //Added by CG on Apr16
    @IBOutlet weak var searchRecipeText: UITextField!
    //End CG
    
    override func viewDidLoad()
    {
        appy.showProcessIndicator()
        insertInitialData()
        super.viewDidLoad()
        self.view.backgroundColor = appy.viewBackground
        tableView.backgroundColor = appy.tableViewBackground
        tableView.scrollEnabled = true
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = appy.labelViewBackground
        
        tableView.scrollEnabled = true
        tableView.scrollRectToVisible(tableView.frame, animated: true)
        appy.hideProcessIndicator()
    }

    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Added by CG on Apr16
        fillRecipes()
        //End CG
        return recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        appy.showProcessIndicator()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RecipeCellTableViewCell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.backgroundColor = appy.cellViewBackground
        
        let recipe = recipes[indexPath.row]
        print(recipe.image)
        cell.setup(recipe.name, image: recipe.image as! UIImage, procedure: recipe.procedure)
        appy.hideProcessIndicator()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        appy.showProcessIndicator()
        searchRecipeText.resignFirstResponder()
        if(segue.identifier == "EditRecipe")
        {
            let controller = segue.destinationViewController as! EditRecipeController
            let recipe = recipes[tableView.indexPathForSelectedRow!.row]
            
            controller.recipe = recipe
        }
        appy.hideProcessIndicator()
    }
    
    //Added by CG on Apr16
    
    //For deleting recipe
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView == self.tableView)
        {
            if (editingStyle == UITableViewCellEditingStyle.Delete)
            {
                DBmanager.deleteRecipe(recipes[indexPath.row])
                self.tableView.reloadData()
            }
        }
    }

    
    @IBAction func searchRecipeTextChange(sender: AnyObject)
    {
        //searchRecipeText.textAlignment = NSTextAlignment.Left
        self.tableView.reloadData()
    }
    
    func fillRecipes()
    {
        if(searchRecipeText.text!.isEmpty)
        {
            recipes = DBmanager.getAllRecipes()
        }
        else
        {
            recipes = DBmanager.getRecipeByNameSearch(searchRecipeText.text!)
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }

    //End CG
    
    func insertInitialData()
    {
        var ings:[TempIngredient]  = []
        var rice = DBmanager.AddIfDistinctIngredient("Rice", units: "lbs")
        var oil = DBmanager.AddIfDistinctIngredient("Oil", units: "ml")
        var sugar = DBmanager.AddIfDistinctIngredient("Sugar", units: "lbs")
        var wheatflour = DBmanager.AddIfDistinctIngredient("Wheat Flour", units: "lbs")
        var vermiselli = DBmanager.AddIfDistinctIngredient("Vermiselli", units: "lbs")
        var chillies = DBmanager.AddIfDistinctIngredient("Chillies", units: "e.a")
        var chicken = DBmanager.AddIfDistinctIngredient("Chicken", units: "lbs")
        var mtrpowder = DBmanager.AddIfDistinctIngredient("MTR powder", units: "lbs")
        var salt = DBmanager.AddIfDistinctIngredient("Salt", units: "tbs")
        var tomato = DBmanager.AddIfDistinctIngredient("Tomatos", units: "lbs")
        var cheese = DBmanager.AddIfDistinctIngredient("Cheese", units: "lbs")
        var potato = DBmanager.AddIfDistinctIngredient("Potatos", units: "lbs")
        var onion = DBmanager.AddIfDistinctIngredient("Onions", units: "lbs")
        var onion1 = DBmanager.AddIfDistinctIngredient("Onions", units: "e.a")
        var brocolli = DBmanager.AddIfDistinctIngredient("Broccoli", units: "lbs")
        var bread = DBmanager.AddIfDistinctIngredient("Bread", units: "e.a")
        var eggplant = DBmanager.AddIfDistinctIngredient("Egg plant", units: "lbs")
        var cauliflower = DBmanager.AddIfDistinctIngredient("Cauliflower", units: "lbs")
        var cabbage = DBmanager.AddIfDistinctIngredient("Cabbage", units: "lbs")
        var lattice = DBmanager.AddIfDistinctIngredient("Lattice", units: "lbs")
        var beef = DBmanager.AddIfDistinctIngredient("Beef", units: "lbs")
        var carrot = DBmanager.AddIfDistinctIngredient("Carrot", units: "lbs")
        var carrot1 = DBmanager.AddIfDistinctIngredient("Carrot", units: "e.a")
    }
}
