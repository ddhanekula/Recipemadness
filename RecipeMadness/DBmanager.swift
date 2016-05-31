//
//  DBmanager.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/12/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import CoreData

class DBmanager: NSObject
{
    class func addRecipe(name : String, image: UIImage, procedure: String, numServes:Int, ingredients: [TempIngredient]) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating a new recipe record
        let recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: context) as! Recipe
        
        //Updating recipe name, image and procedure
        recipe.name = name
        recipe.image = image
        recipe.procedure = procedure
        recipe.numServes = numServes
        
        //Creating each recipe ingredient record
        for ingredient in ingredients
        {
            recipe.addIngredient(ingredient.ingredient, quantity: ingredient.qty)
        }
        
        //Saving the recipe
        return save(context)
    }
    
    class func addMealPlan(date: NSDate, timing:String, numServes: Int, recipes: [Recipe]) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating a new meal calendar record
        let mealPlan = NSEntityDescription.insertNewObjectForEntityForName("MealCalendar", inManagedObjectContext: context) as! MealCalendar
        
        //Updating the new meal plan
        mealPlan.date = date
        mealPlan.timing = timing
        mealPlan.numServes = numServes
        mealPlan.recipes = NSSet(array: recipes)
        
        return mealPlan.updateRecipes(recipes)
    }
    
    class func updateRecipe(name : String, newRecipe: Recipe) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "Recipe")
        
        //Configure the fecthc request with predicates
        request.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        //Processing the request on core data
        if let recipe = context.executeFetchRequest(request, error: nil) as? [Recipe]
        {
            //Return the ingredent, if exits
            if(recipe.count > 0)
            {
                recipe[0].procedure = newRecipe.procedure
                recipe[0].image = newRecipe.image
                
                save(context)
                return true
            }
        }
        
        return false
    }
    
    class func AddIfDistinctIngredient(name : String, units : String) -> Ingredient!
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "Ingredient")
        
        let predicate1 = NSPredicate(format: "name ==[c] %@", name.capitalizedString)
        let predicate2 = NSPredicate(format: "units ==[c] %@", units.capitalizedString)
        
        //Configure the fecthc request with predicates
        request.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [predicate1!, predicate2!])
        
        //Processing the request on core data
        if let ingredients = context.executeFetchRequest(request, error: nil) as? [Ingredient]
        {
            //Return the ingredent, if exits
            if(ingredients.count > 0)
            {
                return ingredients[0]
            }
            else //Insert new record, if ingredient does not exist
            {
                let ingredient = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext: context) as! Ingredient
                
                ingredient.name = name
                ingredient.units = units
                
                save(context)
                return ingredient
            }
        }
        else
        {
            return nil
        }
    }
    
    class func getAllRecipes() -> [Recipe]
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "Recipe")
        
        //Configuring with sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //Process the request on CoreData
        if let ingredients = context.executeFetchRequest(request, error: nil)
        {
            //Return recipes, if exist
            return ingredients as [Recipe]
        }
        else
        {
            return [Recipe]()
        }
    }
    
    class func getRecipeByNameSearch(earchBy : String) -> [Recipe]
    {
        
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "Recipe")
        
        //Add a where request
        request.predicate = NSPredicate(format: "name contains[c] %@", searchBy)
        
        //Configuring with sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //Process the request on CoreData
        if let ingredients = context.executeFetchRequest(request, error: nil)
        {
            //Return recipes, if exist
            return ingredients as [Recipe]
        }
        else
        {
            return [Recipe]()
        }
    }
    
    class func isRecipeExists(name : String) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "Recipe")
        
        //Add a where request
        request.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        //Configuring with sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //Process the request on CoreData
        if let ingredients = context.executeFetchRequest(request, error: nil) as? [Recipe]
        {
            //Return recipes, if exist
            return ingredients.count > 0
        }
        else
        {
            return false
        }
    }
    
    class func getDistinctIngredients() -> [Ingredient]
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "Ingredient")
        
        //Configuring with sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //Process the request on CoreData
        if let ingredients = context.executeFetchRequest(request, error: nil)
        {
            //Return ingredients, if exist
            return ingredients as [Ingredient]
        }
        else
        {
            return [Ingredient]()
        }
    }
    
    class func getMealCalendarItems() -> [MealCalendar]
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "MealCalendar")
        
        //Adding the predicate
        request.predicate = NSPredicate(format: "date >= %@", truncDate(NSDate()))
            
        //Configuring with sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        //Process the request on CoreData
        if let calendarItems = context.executeFetchRequest(request, error: nil)
        {
            //Return ingredients, if exist
            return calendarItems as [MealCalendar]
        }
        else
        {
            return [MealCalendar]()
        }
    }
    
    class func getShoppingListItems(dateFrom: NSDate, dateTo: NSDate) -> [ShoppingList]
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "ShoppingList")
        
        //Adding the predicate
        request.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [NSPredicate(format: "calendar.date >= %@", truncDate(dateFrom))!,
                            NSPredicate(format: "calendar.date <= %@", truncDate(dateTo))!])
        
        //Configuring with sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "ingredient.name", ascending: true),
                                    NSSortDescriptor(key: "ingredient.units", ascending: true)]
        
        //Process the request on CoreData
        if let calendarItems = context.executeFetchRequest(request, error: nil)
        {
            //Return ingredients, if exist
            return calendarItems as [ShoppingList]
        }
        else
        {
            return [ShoppingList]()
        }
    }
    
    class func getRecipesForShopping( dateFrom : NSDate, dateTo: NSDate) -> [Recipe]
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "MealCalendar")
        
        //Adding the predicate
        request.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [NSPredicate(format: "date >= %@", truncDate(dateFrom))!,
            NSPredicate(format: "date <= %@", truncDate(dateTo))!])
        
        //Process the request on CoreData
        if let calendarItems = context.executeFetchRequest(request, error: nil) as? [MealCalendar]
        {
            var recipeList:[Recipe] = []
            
            for item in calendarItems
            {
                for recipe in item.getRecipies()
                {
                    var isDuplicateRecipe = false
                    
                    for r in recipeList
                    {
                        if r.name == recipe.name
                        {
                            isDuplicateRecipe = true
                        }
                    }
                    
                    if !isDuplicateRecipe
                    {
                        recipeList.append(recipe)
                    }
                }
            }
            print(recipeList.count)
            recipeList.sort({$0.name < $1.name})
            return recipeList
        }
        else
        {
            return [Recipe]()
        }
    }
    
    class func deleteRecipe(recipe: Recipe) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

        //Delete all recipe ingredients
        for ingredient in recipe.getIngredients()
        {
            context.deleteObject(ingredient)
        }
        
        //Delete the recipe
        context.deleteObject(recipe)
        
        return save(context)
    }
    
    class func deleteRecipeIngredient(ingredient: RecipeIngredient) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Delete the ingredient
        context.deleteObject(ingredient)
        
        return save(context)
    }
    
    class func deleteMealPlan(plan: MealCalendar) -> Bool
    {
        //Fetching managed object context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Creating the fetch request
        let request = NSFetchRequest(entityName: "ShoppingList")
        
        //Adding the predicate
        request.predicate = NSPredicate(format: "calendar == %@", plan)
        
        if let shoppingListItems = context.executeFetchRequest(request, error: nil) as? [ShoppingList]
        {
            for item in shoppingListItems
            {
                //Delete only if item is not yet purchased
                if(!Bool(item.isPurchased))
                {
                    context.deleteObject(item)
                }
            }
        }
        
        //Delete the ingredient
        context.deleteObject(plan)
        
        return save(context)
    }
    
    class func save() -> Bool
    {
        return save((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!)
    }
    
    class func save(context: NSManagedObjectContext) -> Bool
    {        
        var error: NSError?
        
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        return error == nil
    }
    
    class func truncDate(date: NSDate) -> NSDate
    {
        let cal: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        let newDate: NSDate = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())!
        
        return newDate
    }
}
