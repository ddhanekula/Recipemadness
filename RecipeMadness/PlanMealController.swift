//
//  PlanMealController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import CoreData

//Added table source , table delegate by CG on Apr14
class PlanMealController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    var appy = UIApplication.sharedApplication().delegate as! AppDelegate

    var recipes:[Recipe] = []
    
    //Added by CG on Apr14
    @IBOutlet weak var mealDate: UITextField!
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    @IBOutlet weak var numOfServesTXT: UITextField!
    
    var oldSelect:Int = -1
    
    var datePicker: UIDatePicker!
    
    var datePickerView:UIView!
    //End CG
    
    @IBOutlet weak var TimingPicker: UIPickerView!
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var lblHeader3: UILabel!
    @IBOutlet weak var lblHeader4: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        recipes = DBmanager.getAllRecipes()
        
        //Added by CG on Apr14
        TimingPicker.transform = CGAffineTransformMakeScale(0.5, 0.7)
        recipeTableView.rowHeight = CGFloat(25)
        datePickerView = createDatePickerView()
        //End CG
        
        mealDate.text = Utility.getStringFromDate(NSDate())
        
        self.view.backgroundColor = appy.viewBackground
        setLabelStyle(lblHeader1)
        setLabelStyle(lblHeader2)
        setLabelStyle(lblHeader3)
        setLabelStyle(lblHeader4)
    }
    
    func setLabelStyle(label: UILabel)
    {
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = appy.labelViewBackground
    }
    
    @IBAction func SaveMealCalendar(sender: AnyObject)
    {
        print(TimingPicker.selectedRowInComponent(0))
        if(mealDate.text!.isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Date is not selected!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(recipeTableView.indexPathForSelectedRow == nil)
        {
            let alertView = UIAlertView(title: "Error", message: "Recipe is not selected!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(numOfServesTXT.text!.isEmpty)
        {
            let alertView = UIAlertView(title: "Error", message: "Number of serves is not entered!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else if(TimingPicker.selectedRowInComponent(0) < 0)
        {
            let alertView = UIAlertView(title: "Error", message: "Timing is not selected!", delegate: self, cancelButtonTitle: "Dismiss")
            alertView.show()
        }
        else
        {
            var selectedRecipes: [Recipe] = []
            for index in 0...recipes.count-1
            {
                if(recipeTableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))?.accessoryType == UITableViewCellAccessoryType.Checkmark)
                {
                    selectedRecipes.append(recipes[index])
                }
            }
            
            if DBmanager.addMealPlan(
                Utility.getDateFromString(mealDate.text!),
                timing: appy.timings[TimingPicker.selectedRowInComponent(0)],
                numServes: (numOfServesTXT.text! as NSString).integerValue,
                recipes: selectedRecipes)
            {
                let alert = UIAlertView(title: "", message: "You meal plan is scheduled!", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                let alertView = UIAlertView(title: "Error", message: "Unable to save your meal plan!", delegate: self, cancelButtonTitle: "Dismiss")
                alertView.show()
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Added by CG On Apr14
    @IBAction func mealDateChange(sender: AnyObject)
    {
        mealDate.inputView = datePickerView
        mealDate.inputAccessoryView = setDoneButton(0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var recipeCell = recipeTableView.dequeueReusableCellWithIdentifier("recipeCell")! as UITableViewCell
        
        recipeCell.textLabel?.adjustsFontSizeToFitWidth = true
        recipeCell.textLabel?.minimumScaleFactor = 0.1
        recipeCell.textLabel?.font = UIFont.systemFontOfSize(12.0)
        recipeCell.accessoryType = .None
        
        recipeCell.textLabel?.text = recipes[indexPath.row].name
        
        return recipeCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let  selectedCell = recipeTableView.cellForRowAtIndexPath(indexPath)
        
        selectedCell?.accessoryType = (selectedCell?.accessoryType == UITableViewCellAccessoryType.None) ? UITableViewCellAccessoryType.Checkmark: UITableViewCellAccessoryType.None
        
//        if(indexPath.row == oldSelect)
//        {
//            selectedCell?.accessoryType = .None
//            oldSelect = -1
//        }
//        else if(selectedCell != nil)
//        {
//            selectedCell?.accessoryType = .Checkmark
//            oldSelect = indexPath.row
//        }
//        else
//        {
//            selectedCell?.accessoryType = .None
//        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let  deSelectedCell = recipeTableView.cellForRowAtIndexPath(indexPath)
        
        if(oldSelect >= 0)
        {
            deSelectedCell?.accessoryType = .None
            oldSelect = -1
        }
    }
    //End CG
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //modified by CG on Apr14
        return appy.timings.count
        //End CG
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
//    {
//        return appy.timings[row]
//    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView!
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.whiteColor()
        pickerLabel.text = appy.timings[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "System", size: 17) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        //setLabelStyle(pickerLabel)
        return pickerLabel
    }
    
    //Added by CG on Apr14
    @IBAction func numOfServesChange(sender: AnyObject)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
        
    @IBAction func checkServesValue(sender: AnyObject)
    {
        if(numOfServesTXT.text!.utf16.count > 3)
        {
            numOfServesTXT.deleteBackward()
        }
    }
    
    @IBAction func numOfServesTouch(sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    
    
    func keyboardWillShow(sender: NSNotification)
    {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification)
    {
        self.view.frame.origin.y += 150
    }
    
   override  func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        if(sender.tag == 0)
        {
            mealDate.text =  dateFormatter.stringFromDate(datePicker.date)
            mealDate.resignFirstResponder()
        }
    }
    //End CG
}
