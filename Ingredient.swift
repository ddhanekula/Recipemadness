//
//  Ingredient.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/12/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import Foundation
import CoreData

class Ingredient: NSManagedObject
{
    @NSManaged var name: String
    @NSManaged var units: String
}
