//
//  ShoppingListController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

class ShoppingListItem
{
    private var actualItems: [ShoppingList] = []
    
    var isPurchased: Bool = false
    
    var ingredientName: String
    {
        get{ return (actualItems.count > 0) ? actualItems[0].ingredient.name : "" }
    }
    
    var units: String
    {
        get{ return (actualItems.count > 0) ? actualItems[0].ingredient.units : "" }
    }
    
    var toBePurchasedQty: Double
    {
        get
        {
            var total = 0.0
            
            for item in actualItems
            {
                if(!Bool(item.isPurchased))
                {
                    total += Double(item.qty)
                }
            }
            return total
        }
    }
    
    var purchasedQty: Double
    {
        get
        {
            var total = 0.0
            
            for item in actualItems
            {
                if(Bool(item.isPurchased))
                {
                    total += Double(item.qty)
                }
            }
            return total
        }
    }
    
    func addItem(item: ShoppingList)
    {
        actualItems.append(item)
    }
    
    private func saveToDB() -> Bool
    {
        for item in actualItems
        {
            if(!Bool(item.isPurchased))
            {
                item.setPurchased(isPurchased: self.isPurchased)
            }
        }
        return DBmanager.save()
    }
}

//Added table delegate by CG on Apr14
class ShoppingListController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var items: [ShoppingListItem] = []
    var recipes: [Recipe] = []
    
    func fillItems(actualItems: [ShoppingList])
    {
        items = [ShoppingListItem]()
        
        var prevItemName: String = ""
        var prevUnits: String = ""
        
        for item in actualItems
        {
            if(item.ingredient.name != prevItemName && item.ingredient.units != prevUnits)
            {
                items.append(ShoppingListItem())
                prevItemName = item.ingredient.name
                prevUnits = item.ingredient.units
            }
            items[items.count-1].addItem(item)
        }
        recipes = DBmanager.getRecipesForShopping(dateFrom: Utility.getDateFromString(fromDate.text), dateTo: Utility.getDateFromString(toDate.text!))
    }
    
    var PurchasedItems: [ShoppingListItem]
    {
        get
        {
            var internalItems: [ShoppingListItem] = []
            
            for item in items
            {
                if(item.purchasedQty > 0)
                {
                    internalItems.append(item)
                }
            }
            return internalItems
        }
    }
    
    var ToBePurchasedItems: [ShoppingListItem]
    {
        get
        {
            var internalItems: [ShoppingListItem] = []
            
            for item in items
            {
                if(item.toBePurchasedQty > 0)
                {
                    internalItems.append(item)
                }
            }
            return internalItems
        }
    }
    
    func saveImageTapped(sender: AnyObject)
    {
        saveShoppingList(self)
    }
    
    @IBAction func saveShoppingList(sender: AnyObject)
    {
        if(fromDate.text.isEmpty || toDate.text!.isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "From or to date cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else
        {
            for item in ToBePurchasedItems
            {
                item.saveToDB()
            }
            FillTheShoppingListView(self)
        }
    }
    
    @IBAction func purchaseListChanged(sender: AnyObject)
    {
        if(purchListSegmtCtrl.selectedSegmentIndex == 0)
        {
            purchasedListView.hidden = true
            shopListView.hidden = false
            recipeListView.hidden = true
        }
        else if(purchListSegmtCtrl.selectedSegmentIndex == 1)
        {
            shopListView.hidden = true
            purchasedListView.hidden = false
            recipeListView.hidden = true
        }
        else
        {
            shopListView.hidden = true
            purchasedListView.hidden = true
            recipeListView.hidden = false
        }
    }
    @IBAction func FillTheShoppingListView(sender: AnyObject)
    {
        appy.showProcessIndicator()
        if(fromDate.text!.isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "From date cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(toDate.text!.isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "To date cannot be empty!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else
        {
            fillItems(DBmanager.getShoppingListItems(Utility.getDateFromString(fromDate.text), dateTo: Utility.getDateFromString(toDate.text)))
            purchasedListView.reloadData()
            shopListView.reloadData()
            recipeListView.reloadData()
        }
        appy.hideProcessIndicator()
    }
    
   
    
    @IBOutlet weak var purchasedListView: UITableView!
    @IBOutlet weak var purchListSegmtCtrl: UISegmentedControl!
    
    @IBOutlet weak var recipeListView: UITableView!
    //Added by CG on Apr14
    @IBOutlet weak var fromDate: UITextField!
  
    @IBOutlet weak var toDate: UITextField!
    
    @IBOutlet weak var shopListView: UITableView!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var saveListImage: UIImageView!
    
    var datePicker:UIDatePicker!
    
    var datePickerView:UIView!
    //End CG
    var appy = UIApplication.sharedApplication().delegate as! AppDelegate
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Added by CG on Apr14
        shopListView.rowHeight = CGFloat(25)
        datePickerView = createDatePickerView()
        //End CG
        shopListView.hidden = false
        
        //Set textboxes to today date by default
        //fromDate.text =  Utility.getStringFromDate(NSDate())
        //toDate.text =  Utility.getStringFromDate(NSDate())
        
        self.view.backgroundColor = appy.viewBackground
        
        lblHeading.layer.masksToBounds = true
        lblHeading.layer.cornerRadius = 8
        lblHeading.backgroundColor = appy.labelViewBackground
        
        purchasedListView.layer.masksToBounds = true
        purchasedListView.layer.cornerRadius = 8
        purchasedListView.backgroundColor = appy.labelViewBackground
        
        shopListView.layer.masksToBounds = true
        shopListView.layer.cornerRadius = 8
        shopListView.backgroundColor = appy.labelViewBackground
        
        recipeListView.layer.masksToBounds = true
        recipeListView.layer.cornerRadius = 8
        recipeListView.backgroundColor = appy.labelViewBackground
        
        saveListImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "saveImageTapped:"))
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Added by CG on Apr14
    @IBAction func fromDateBegin(sender: AnyObject)
    {
        fromDate.inputView = datePickerView
        fromDate.inputAccessoryView = setDoneButton(tagNum: 0)
    }
    
    
    @IBAction func toDateBegin(sender: AnyObject)
    {
        toDate.inputView = datePickerView
        toDate.inputAccessoryView = setDoneButton(tagNum: 1)
    }
    //END CG
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == shopListView)
        {
            return ToBePurchasedItems.count
        }
        else if(tableView == purchasedListView)
        {
            return PurchasedItems.count
        }
        else
        {
            return recipes.count
        }
     }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(tableView == recipeListView)
        {
            let sCell = tableView.dequeueReusableCellWithIdentifier("cell") as! ShoppingRecipeCell
            sCell.setup(indexPath.row+1, name: recipes[indexPath.row].name)
            sCell.backgroundColor = appy.autoTableBackground
            sCell.textLabel?.adjustsFontSizeToFitWidth = true
            sCell.textLabel?.minimumScaleFactor = 0.1
            sCell.textLabel?.font = UIFont.systemFontOfSize(12.0)
            sCell.accessoryType = .None
            sCell.layer.masksToBounds = true
            sCell.layer.cornerRadius = 8
            
            return sCell

        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ShoppingCell
            var ingredient:ShoppingListItem!
            if(tableView == shopListView)
            {
                ingredient = ToBePurchasedItems[indexPath.row]
                cell.setup(indexPath.row+1, name: ingredient.ingredientName, units: ingredient.units, qty: ingredient.toBePurchasedQty)
                cell.backgroundColor = appy.cellViewBackground
                cell.accessoryView = UIImageView(image:UIImage(named:"Box.png"))
            }
            else if(tableView == purchasedListView)
            {
                ingredient = PurchasedItems[indexPath.row]
                cell.setup(indexPath.row+1, name: ingredient.ingredientName, units: ingredient.units, qty: ingredient.purchasedQty)
                cell.backgroundColor = appy.autoTableBackground
            }
            //Added by CG on Apr14
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 0.1
            cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
            cell.accessoryType = .None
            //End CG
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            
            return cell
        }
    }
    
    var count:Int = 1
    
    //Added by CG on Apr14
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView == shopListView)
        {
            let selectedCell = shopListView.cellForRowAtIndexPath(indexPath)
            
            if(selectedCell != nil)
            {
                if(ToBePurchasedItems[indexPath.row].isPurchased)
                {
                    selectedCell?.accessoryView = UIImageView(image:UIImage(named:"Box.png"))
                    ToBePurchasedItems[indexPath.row].isPurchased = false
                }
                else
                {
                    selectedCell?.accessoryView = UIImageView(image:UIImage(named:"Checkmark.png"))
                    ToBePurchasedItems[indexPath.row].isPurchased = true
                }
            }
            else
            {
                selectedCell?.accessoryView = .None
            }
        }
    }
    
    func createDatePickerView() -> UIView
    {
        let customView:UIView = UIView (frame: CGRectMake(0, 100, 320, 160))
        customView.backgroundColor = appy.dateViewBackground
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, 320, 160))
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.minimumDate = NSDate()
        customView.addSubview(datePicker)
        return customView
    }
    
    func setDoneButton(tagNum:Int) -> UIButton
    {
        var doneButton:UIButton = UIButton(frame: CGRectMake(100, 100, 100, 44))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.tag = tagNum
        doneButton.addTarget(self, action: "datePickerSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor.whiteColor()
        return doneButton
    }
    
    
    func datePickerSelected(sender:AnyObject)
    {
        if(sender.tag == 0)
        {
            fromDate.text =  Utility.getStringFromDate(datePicker.date)
            toDate.text =  Utility.getStringFromDate(datePicker.date)
            fromDate.resignFirstResponder()
        }
        else if(sender.tag == 1)
        {
            toDate.text =  Utility.getStringFromDate(datePicker.date)
            toDate.resignFirstResponder()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }

    //End CG

}
