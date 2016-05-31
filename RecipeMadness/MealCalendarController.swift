//
//  MealCalendarController.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import QuartzCore

class MealCalendarController: UITableViewController
{
    var appy = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var mealCalendarItems: [MealCalendar]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = appy.viewBackground
        tableView.backgroundColor = appy.labelViewBackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        mealCalendarItems = DBmanager.getMealCalendarItems()
        
        return mealCalendarItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MealCalendarViewCell
        let calendar = mealCalendarItems[indexPath.row]
        cell.setup(Utility.getStringFromDate(calendar.date), timing: calendar.timing, recipeName: calendar.getRecipeNames(), image:UIImage())
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.backgroundColor = appy.cellTableViewBackground
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */
    
    //For deleting recipe
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView == self.tableView)
        {
            if (editingStyle == UITableViewCellEditingStyle.Delete)
            {
                DBmanager.deleteMealPlan(mealCalendarItems[indexPath.row])
                self.tableView.reloadData()
            }
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if(segue.identifier == "EditMealPlan")
//        {
//            (segue.destinationViewController as! EditMealPlanController).mealPlan = mealCalendarItems[tableView.indexPathForSelectedRow()!.row]
//        }
//    }
//

}
