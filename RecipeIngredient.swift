//
//  RecipeIngredient.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/12/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import Foundation
import CoreData

class RecipeIngredient: NSManagedObject
{
    @NSManaged private var qty: NSNumber
    @NSManaged var recipe: Recipe
    @NSManaged var ingredient: Ingredient

    var name: String!
    {
        get
        {
            return ingredient.name
        }
    }
    
    var units: String!
    {
        get
        {
            return ingredient.units
        }
    }
    
    var quantity: Double
    {
        get
        {
            return Double(qty)
        }
        set
        {
            qty = NSNumber(double: newValue)
        }
    }
}
