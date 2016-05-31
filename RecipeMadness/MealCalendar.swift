//
//  MealCalendar.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/16/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class MealCalendar: NSManagedObject
{
    @NSManaged var date: NSDate
    @NSManaged var timing: String
    @NSManaged var numServes: NSNumber
    @NSManaged var recipes: NSSet

    func getRecipies() -> [Recipe]
    {
        return recipes.allObjects as! [Recipe]
    }
    
    func getRecipeNames() -> String
    {
        var names = ""
        var recipes = getRecipies()
        if(recipes.count > 0)
        {
            for index in 0...recipes.count-1
            {
                if(index==recipes.count-1)
                {
                    names += recipes[index].name
                }
                else
                {
                    names += "\(recipes[index].name), "
                }
            }
        }
        return names
    }
    
    func updateRecipes(recipeList: [Recipe]) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "ShoppingList")
        
        //Adding the predicate
        request.predicate = NSPredicate(format: "calendar == %@", self)
        
        //Process the request on CoreData
        if let calendarItems = try!(context.executeFetchRequest(request)) as? [ShoppingList]
        {
            for item in calendarItems
            {
                if(item.isPurchased == false)
                {
                    context.deleteObject(item)
                }
            }
        }
        
        for recipe in recipeList
        {
            //Adding the shopping list
            for recipeIngredient in recipe.getIngredients()
            {
                //Creating a new row into shoppingList
                let shoppingListItem = NSEntityDescription.insertNewObjectForEntityForName("ShoppingList", inManagedObjectContext: context) as! ShoppingList
                
                //Updating the new record with values
                shoppingListItem.calendar = self
                shoppingListItem.ingredient = recipeIngredient.ingredient
                shoppingListItem.qty = Double(numServes) * recipeIngredient.quantity / Double(recipe.numServes)
                shoppingListItem.isPurchased = false
            }
        }
        
        return DBmanager.save()
    }
}
