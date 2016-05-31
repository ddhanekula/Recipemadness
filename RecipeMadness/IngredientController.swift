//
//  IngredientController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

//Added textfielddelegate by CG on Apr 16
class IngredientController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var txtRecipe: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUnits: UITextField!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var txtServes: UITextField!
    
    @IBOutlet weak var recipeImage: UIImageView!
    let picker = UIImagePickerController()
    
    var ingredientsInRecipe: [TempIngredient] = []
    var distinctIngredients: [Ingredient] = []
    var matchingIngredients: [Ingredient] = []
    var matchingUnits: [String] = []
    var recipeProcedure: String = ""
    
    var appy = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBOutlet weak var lblIngredientsBar: UILabel!
    @IBOutlet weak var lblIngredientListBar: UILabel!
    @IBOutlet weak var btnAddPic: UIButton!
    @IBOutlet weak var btnEditProcedure: UIButton!
    @IBOutlet weak var btnAddIngredient: UIButton!
    
    @IBOutlet weak var tableViewIngredientsToSave: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableViewIngredientsToSave.rowHeight = CGFloat(25)
        picker.delegate = self
        //Added by CG on Apr20
        self.navigationItem.hidesBackButton = true
        let newBackBTN = UIBarButtonItem(title: "< Recipes", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackBTN
        //End CG
        
        recipeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTapped:"))
        
        self.view.backgroundColor = appy.viewBackground
        
        tableViewIngredientsToSave.layer.masksToBounds = true
        tableViewIngredientsToSave.layer.cornerRadius = 8
        tableViewIngredientsToSave.backgroundColor = appy.tableViewBackground
        
        lblIngredientsBar.layer.masksToBounds = true
        lblIngredientsBar.layer.cornerRadius = 8
        lblIngredientsBar.backgroundColor = appy.labelViewBackground
        
        lblIngredientListBar.layer.masksToBounds = true
        lblIngredientListBar.layer.cornerRadius = 8
        lblIngredientListBar.backgroundColor = appy.labelViewBackground
        
        recipeImage.layer.masksToBounds = true
        recipeImage.layer.cornerRadius = 15
        recipeImage.image = UIImage(named: "no-img-1.jpg")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableViewIngredientsToSave.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
            let newIngredient = DBmanager.AddIfDistinctIngredient(txtName.text!, units:txtUnits.text!)
            
            //Share the ingredient with parent
            ingredientsInRecipe.append(TempIngredient(ingredient: newIngredient, qty: (txtQty.text! as NSString).doubleValue))
            
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
    
    @IBAction func checkServesValue(sender: AnyObject)
    {
        if(txtServes.text!.utf16.count > 3)
        {
            txtServes.deleteBackward()
        }
    }
    
    func imageTapped(sender: UIImageView)
    {
        changePic(self)
    }
    
    //For getting image from Lib
    @IBAction func changePic(sender: AnyObject)
    {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //Modified by CG on Apr20
    //Save Recipe to DB
    @IBAction func saveRecipe(sender: AnyObject)
    {
        appy.showProcessIndicator()
        
        
        
        if(txtRecipe.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Recipe name cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(txtServes.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Number of serves cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(ingredientsInRecipe.count == 0)
        {
            let alertView = UIAlertView(title: "Error", message: "Ingredients cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(DBmanager.isRecipeExists(txtRecipe.text!))
        {
            let alertView = UIAlertView(title: "Error", message: "Recipe name is already used!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else
        {
            if DBmanager.addRecipe(txtRecipe.text!, image: recipeImage.image!, procedure: recipeProcedure, numServes: Int(txtServes.text!)!, ingredients: ingredientsInRecipe)
            {
                let alertView = UIAlertView(title: "Success", message: "Recipe added to the book!", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        appy.hideProcessIndicator()
    }
    //End CG
    
    //Added by CG on Apr20
    func back(sender:UIBarButtonItem)
    {
        if(!txtRecipe.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty ||
            ingredientsInRecipe.count > 0)
        {
            if #available(iOS 8.0, *) {
                var saveAlert:UIAlertController = UIAlertController(title: "Warning", message: "Recipe is not at saved. Do you want to continue?", preferredStyle: UIAlertControllerStyle.Alert)
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 8.0, *) {
           // saveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                    self.navigationController?.popViewControllerAnimated(true)
                    print("OK")
                //})
            //)
            } else {
                // Fallback on earlier versions
            }
//            saveAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (if(iOS 8.0, *) {
//                action: UIAlertAction
//                } else {
//                // Fallback on earlier versions
//                }) in
//                print("CANCEL")
//            }))
           // presentViewController(saveAlert, animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    //End CG
    
    //After image has been bicked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipeImage.contentMode = .ScaleAspectFit
        recipeImage.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == tableViewIngredientsToSave)
        {
            return ingredientsInRecipe.count
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
            let ingredient = ingredientsInRecipe[indexPath.row]
            cell.setup(indexPath.row+1, name: ingredient.name, units: ingredient.units, qty: ingredient.qty)
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
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        if(tableView == autocompleteUnits)
//        {
//            return
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "EditPreparation")
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
        //Modified by CG on Apr20
        if(textField == txtName)
        {
            distinctIngredients = DBmanager.getDistinctIngredients()
            setAutocompleteTableView(textField)
        }
        else if(textField == txtUnits)
        {
            setAutocompleteTableView(textField)
        }
        //End CG
        //Added by CG on Apr20
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
        //Modified by CG on Apr20
        if(textField == txtName)
        {
            autocompleteTableView.removeFromSuperview()
        }
        else if(textField == txtUnits)
        {
            autocompleteUnits.removeFromSuperview()
        }
        
        //End CG
        //Added by CG on Apr20
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
    
//    @IBAction func textChanged(sender: AnyObject)
//    {
//        //Modified by CG on Apr16
//        if(sender as UITextField == txtName)
//        {
//            searchAutocompleteEntriesWithSubstring(txtName.text)
//        }
//        else
//        {
//            getMatchingUnits(txtName.text)
//            println(txtName.text)
//        }
//        //End CG
//    }
    
    //For Autocompletion
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
    {
        //Modified by CG on Apr16
        if(textField == txtName)
        {
            searchAutocompleteEntriesWithSubstring(txtName.text!+string)
        }
        else if(textField == txtUnits)
        {
            getMatchingUnits(txtUnits.text!+string)
            print(txtUnits.text!+string)
        }
        //End CG
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if(autocompleteTableView != nil && tableView == autocompleteTableView)
        {
            return false
        }
        return true
    }
    
    //For deleting the ingredient
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView == tableViewIngredientsToSave)
        {
            if (editingStyle == UITableViewCellEditingStyle.Delete)
            {
                ingredientsInRecipe.removeAtIndex(indexPath.row)
                tableViewIngredientsToSave.reloadData()
            }
        }
    }
    
    //Added by CG on Apr16
  override func touchesBegan(touches:Set<UITouch> , withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func recipeNameChanged(sender: AnyObject)
    {
        Utility.acceptOnlyCharacterFollowedByNumbers(sender as! UITextField)
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
