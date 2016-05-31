//
//  TempIngredient.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/13/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit

class TempIngredient
{
    var ingredient: Ingredient
    var qty: Double
    
    var name: String
        {
        get{ return ingredient.name }
    }
    
    var units: String
        {
        get{ return ingredient.units }
    }
    
    init(ingredient: Ingredient, qty: Double)
    {
        self.ingredient = ingredient
        self.qty = qty
    }
}