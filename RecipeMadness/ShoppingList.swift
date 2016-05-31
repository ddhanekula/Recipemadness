//
//  ShoppingList.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/16/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import Foundation
import CoreData

class ShoppingList: NSManagedObject
{
    @NSManaged var isPurchased: NSNumber
    @NSManaged var datePurchased: NSDate
    @NSManaged var qty: NSNumber
    @NSManaged var calendar: NSManagedObject
    @NSManaged var ingredient: RecipeMadness.Ingredient

    func setPurchased(isPurchased: Bool)
    {
        if(isPurchased)
        {
            self.isPurchased = true
            self.datePurchased = DBmanager.truncDate(NSDate())
        }
        else
        {
            self.isPurchased = false
        }
    }
}
