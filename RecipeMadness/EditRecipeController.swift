//
//  EditRecipeController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/14/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

//Added textfielddelegate by CG on Apr16
class EditRecipeController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUnits: UITextField!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var txtServes: UITextField!
    @IBOutlet weak var tableViewIngredientsToSave: UITableView!

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var txtRecipeProcedure: UITextView!
    
    var matchingUnits: [String] = []
    
    let picker = UIImagePickerController()
    
    var ingredientsInRecipe: [TempIngredient] = []
    var distinctIngredients: [Ingredient] = []
    var matchingIngredients: [Ingredient] = []
    var recipe: Recipe!
    
    var appy = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBOutlet weak var lblIngredientBar: UILabel!
    @IBOutlet weak var lblIngredientListBar: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableViewIngredientsToSave.rowHeight = CGFloat(25)
        recipeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTapped:"))
        txtRecipeProcedure.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "recipeTapped:"))

        distinctIngredients = DBmanager.getDistinctIngredients()
        picker.delegate = self
        
        self.view.backgroundColor = appy.viewBackground
        
        tableViewIngredientsToSave.layer.masksToBounds = true
        tableViewIngredientsToSave.layer.cornerRadius = 8
        tableViewIngredientsToSave.backgroundColor = appy.tableViewBackground
        
        txtRecipeProcedure.backgroundColor = appy.tableViewBackground
        
        txtRecipeProcedure.layer.masksToBounds = true
        txtRecipeProcedure.layer.cornerRadius = 8
        txtRecipeProcedure.backgroundColor = appy.labelViewBackground
        
        lblIngredientBar.layer.masksToBounds = true
        lblIngredientBar.layer.cornerRadius = 8
        lblIngredientBar.backgroundColor = appy.labelViewBackground
        
        lblIngredientListBar.layer.masksToBounds = true
        lblIngredientListBar.layer.cornerRadius = 8
        lblIngredientListBar.backgroundColor = appy.labelViewBackground
        
        recipeImage.layer.masksToBounds = true
        recipeImage.layer.cornerRadius = 8
        
        txtRecipeProcedure.setContentOffset(CGPointZero, animated: true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        appy.showProcessIndicator()
        self.title = recipe.name
        recipeImage.image = recipe.image as? UIImage
        txtRecipeProcedure.text = recipe.procedure
        txtRecipeProcedure.setContentOffset(CGPointZero, animated: true)
        txtServes.text = recipe.numServes.description
        txtServes.textAlignment = .Right
        tableViewIngredientsToSave.reloadData()
        appy.hideProcessIndicator()
    }
    
    func imageTapped(sender: UIImageView)
    {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func recipeTapped(sender: UITextField)
    {
        performSegueWithIdentifier("EditRecipe", sender: nil)
    }
    
    @IBAction func textChanged(sender: AnyObject)
    {
        //Modified by CG on Apr16
        if(sender as! UITextField == txtName)
        {
            searchAutocompleteEntriesWithSubstring(txtName.text!)
        }
        else if(sender as! UITextField == txtUnits)
        {
            getMatchingUnits(txtUnits.text!)
            print(txtName.text)
        }
        //End CG
    }
    
    @IBAction func checkServesValue(sender: AnyObject)
    {
        if(txtServes.text!.utf16Count > 3)
        {
            txtServes.deleteBackward()
        }
    }
    
    //For getting image from Lib
    func tapImage(gesture: UIGestureRecognizer)
    {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func AddIngredient(sender: AnyObject)
    {
        appy.showProcessIndicator()
        if(txtName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Ingredient name cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(txtQty.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Quantity cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(txtUnits.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Units cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else
        {
            //Register the ingredient to Db, if it is new one.
            let newIngredient = DBmanager.AddIfDistinctIngredient(txtName.text, units: txtUnits.text!)
            
            //Share the ingredient with parent
            recipe.addIngredient(newIngredient, quantity: (txtQty.text as NSString).doubleValue)
            
            ClearTextBoxes(self)
            tableViewIngredientsToSave.reloadData()
        }
        appy.hideProcessIndicator()
    }
    
    //For clearing text boxes
    @IBAction func ClearTextBoxes(sender: AnyObject)
    {
        txtName.text = ""
        txtQty.text = ""
        txtUnits.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func saveRecipe(sender: AnyObject)
    {
        appy.showProcessIndicator()
        if(txtServes.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Number of serves cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if recipe.save()
        {
            let alertView = UIAlertView(title: "success", message: "Updated recipe saved to the book!", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            let alertView = UIAlertView(title: "Fail", message: "Unable to update  recipe to the book!", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
        appy.hideProcessIndicator()
    }
    
    
    //After image has been bicked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        appy.showProcessIndicator()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipe.image = chosenImage
        
        dismissViewControllerAnimated(true, completion: nil)
        appy.hideProcessIndicator()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == tableViewIngredientsToSave)
        {
            return recipe.getIngredients().count
        }
        else if(autocompleteTableView != nil && tableView == autocompleteTableView)
        {
            return matchingIngredients.count
        }
        else
        {
            return matchingUnits.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        appy.showProcessIndicator()
        if(tableView == tableViewIngredientsToSave)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! IngedientViewCell
            
            let ingredient = recipe.getIngredients()[indexPath.row]
            cell.setup(indexPath.row+1, name: ingredient.name, units: ingredient.units, qty: ingredient.quantity)
            //Added by CG on Apr18
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 0.1
            cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            cell.backgroundColor = appy.cellViewBackground
            
            appy.hideProcessIndicator()
            return cell
        }
        else if(autocompleteTableView != nil && tableView == autocompleteTableView)
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "cell")
            let index = indexPath.row as Int
            
            let ingredient = matchingIngredients[indexPath.row]
            cell.textLabel?.text = ingredient.name
            cell.textLabel?.font = UIFont(name: "Arial", size: 12)
            cell.detailTextLabel?.text = ingredient.units
            cell.detailTextLabel?.font = UIFont(name: "Arial", size: 10)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            cell.backgroundColor = appy.autoCellViewBackground
            cell.hidden = false
            appy.hideProcessIndicator()
            return cell
        }
        else
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "cell")
            let index = indexPath.row as Int
            
            cell.textLabel?.text = matchingUnits[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Arial", size: 12)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            cell.backgroundColor = appy.autoCellViewBackground
            cell.hidden = false
            appy.hideProcessIndicator()
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "EditRecipe")
        {
            (segue.destinationViewController as! AddRecipeIngredientController).parent = self
        }
    }
    
    //For Autocompletion
    var autocompleteTableView: UITableView!
    
    var autocompleteUnits: UITableView!
    
    //For Autocompletion
    func setAutocompleteTableView(forTextField: UITextField)
    {
        if(forTextField == txtName)
        {
            autocompleteTableView = UITableView(frame: CGRectMake(forTextField.frame.origin.x,forTextField.frame.origin.y + forTextField.frame.height,forTextField.frame.width, 200), style: UITableViewStyle.Plain)
            
            autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
            view.addSubview(autocompleteTableView)
            
            
            autocompleteTableView.layer.masksToBounds = true
            autocompleteTableView.layer.cornerRadius = 8
            autocompleteTableView.backgroundColor = appy.autoTableBackground
            
            autocompleteTableView.delegate = self
            autocompleteTableView.dataSource = self
            autocompleteTableView.scrollEnabled = true
            autocompleteTableView.hidden = true
            autocompleteTableView.rowHeight = 25
        }
        else if(forTextField == txtUnits)
        {
            autocompleteUnits = UITableView(frame: CGRectMake(forTextField.frame.origin.x,forTextField.frame.origin.y + forTextField.frame.height,forTextField.frame.width, 100), style: UITableViewStyle.Plain)
            
            autocompleteUnits.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
            view.addSubview(autocompleteUnits)
            
            
            autocompleteUnits.layer.masksToBounds = true
            autocompleteUnits.layer.cornerRadius = 8
            autocompleteUnits.backgroundColor = appy.autoTableBackground
            
            autocompleteUnits.delegate = self
            autocompleteUnits.dataSource = self
            autocompleteUnits.scrollEnabled = true
            autocompleteUnits.hidden = true
            autocompleteUnits.rowHeight = 20
        }
    }
    
    //For Autocompletion
    func textFieldDidBeginEditing(textField: UITextField)
    {
        //Modified by CG on Apr16
        if(textField == txtName)
        {
            setAutocompleteTableView(forTextField: textField)
        }
        else if(textField == txtUnits)
        {
            setAutocompleteTableView(forTextField: textField)
        }
        //End CG
        //Added by CG on Apr21
        if(textField == txtQty || textField == txtServes || textField == txtUnits || textField == txtName)
        {
            if(textField != txtServes)
            {
                self.view.frame.origin.y -= 90
            }
            if(textField != txtUnits && textField != txtName)
            {
                textField.textAlignment = .Right
            }
        }
        //End CG
    }
    
    //For Autocompletion
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        //Modified by CG on Apr16
        if(textField == txtName)
        {
            autocompleteTableView.removeFromSuperview()
        }
        else if(textField == txtUnits)
        {
            autocompleteUnits.removeFromSuperview()
        }
        //End CG
        //Added by CG on Apr21
        if(textField == txtQty || textField == txtServes || textField == txtUnits || textField == txtName)
        {
            if(textField != txtServes)
            {
                self.view.frame.origin.y += 90
            }
            if(textField != txtUnits && textField != txtName)
            {
                textField.textAlignment = .Center
            }
        }        //End CG

        return true
    }
    
    //For Autocompletion
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        matchingIngredients = [Ingredient]()
        
        for ing in distinctIngredients
        {
            if ing.name.uppercaseString.hasPrefix(substring.uppercaseString)
            {
                matchingIngredients.append(ing)
            }
        }
        
        if(matchingIngredients.count > 0)
        {
            autocompleteTableView.hidden = false
            autocompleteTableView.reloadData()
        }
        else
        {
            autocompleteTableView.hidden = true
        }
    }
    
    func getMatchingUnits(substring: String)
    {
        matchingUnits = [String]()
        
        for unit in appy.units
        {
            if unit.uppercaseString.hasPrefix(substring.uppercaseString)
            {
                matchingUnits.append(unit)
            }
        }
        
        if(matchingUnits.count > 0)
        {
            autocompleteUnits.hidden = false
            autocompleteUnits.reloadData()
        }
        else
        {
            autocompleteUnits.hidden = true
        }
    }
    
    //For Autocompletion
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(autocompleteTableView != nil && tableView == autocompleteTableView)
        {
            let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            txtName.text = matchingIngredients[indexPath.row].name
            txtUnits.text = matchingIngredients[indexPath.row].units
            txtQty.becomeFirstResponder()
            autocompleteTableView.hidden = true
        }
        else if(autocompleteUnits != nil && tableView == autocompleteUnits)
        {
            txtUnits.text = matchingUnits[indexPath.row]
            autocompleteUnits.hidden = true
        }
    }

    //for deleting ingredient
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView == tableViewIngredientsToSave)
        {
            if (editingStyle == UITableViewCellEditingStyle.Delete)
            {
                DBmanager.deleteRecipeIngredient(recipe.getIngredients()[indexPath.row])
                tableViewIngredientsToSave.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if(autocompleteTableView != nil && tableView == autocompleteTableView)
        {
            return false
        }
        return true
    }
    
    //Added by CG on Apr16
     func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func ingredientNameChanged(sender: AnyObject)
    {
        Utility.acceptOnlyCharacter(sender as! UITextField)
    }
    
    @IBAction func unitsChanged(sender: AnyObject)
    {
        Utility.acceptOnlyCharacter(sender as! UITextField)
    }
    //End CG

}
