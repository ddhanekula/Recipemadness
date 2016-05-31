//
//  Recipe.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/12/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Recipe: NSManagedObject
{
    @NSManaged var name: String
    @NSManaged var image: AnyObject
    @NSManaged var procedure: String
    @NSManaged var numServes: NSNumber
    
    func getIngredients() -> [RecipeIngredient]
    {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        let request = NSFetchRequest(entityName: "RecipeIngredient")
        request.predicate = NSPredicate(format: "recipe.name == %@", self.name)
        request.sortDescriptors = [NSSortDescriptor(key: "ingredient.name", ascending: true)]
        
        if let tempIngredientList = try!(context.executeFetchRequest(request) )as? [RecipeIngredient]
        {
            return tempIngredientList
        }
        return [RecipeIngredient]()
    }
    
    func addIngredient(newIngredient: Ingredient, quantity: Double) -> Bool
    {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Inserting new row for ingredient
        let recipeIngredient = NSEntityDescription.insertNewObjectForEntityForName("RecipeIngredient", inManagedObjectContext: context) as! RecipeIngredient
        
        //Configuring the ingredient
        recipeIngredient.recipe = self
        recipeIngredient.ingredient = newIngredient
        recipeIngredient.quantity = quantity
        
        return true
    }
    
    func save() -> Bool
    {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        return DBmanager.save(context)
    }
}
