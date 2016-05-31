//
//  AppDelegate.swift
//  RecipeMadness
//
//  Created by Ramisetty,Tejesh Kumar on 4/1/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    var viewBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(0.5)
    var tableViewBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(0.5)
    var cellViewBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(0.1)
    var autoTableBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(0.8)
    var autoCellViewBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(0.8)
    var labelViewBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(1)
    var cellTableViewBackground = UIColor(patternImage: UIImage(named: "0.jpg")!).colorWithAlphaComponent(0.6)
    var buttonViewBackground = UIColor.greenColor().colorWithAlphaComponent(0.9)
    var dateViewBackground = UIColor(patternImage: UIImage(named: "1.jpg")!).colorWithAlphaComponent(0.9)
    
    var recipes = [Recipe]()
//    [Recipe(name: "Veg biriyani", image: "img1.jpg", Date: "04/24/2015", Timing: "Lunch"), Recipe(name: "Chicken biriyani", image: "img2.jpg", Date: "04/23/2015", Timing: "Dinner"), Recipe(name: "Egg biriyani", image: "img1.jpg", Date: "04/25/2015", Timing: "Snacks"), Recipe(name: "Kheer", image: "img5.jpg", Date: "04/26/2015", Timing: "Breakfast"),Recipe(name: "Pan cake", image: "img3.jpg", Date: "04/28/2015", Timing: "Lunch"), Recipe(name: "Dal makani", image: "img4.jpg", Date: "04/27/2015", Timing: "Dinner")]

    var ingredients = [Ingredient]()
    //[Ingredient(Name: "Rice", Units: "lbs", Qty: 2.0), Ingredient(Name: "Onions", Units: "ea", Qty: 2.0), Ingredient(Name: "Oil", Units: "ml", Qty: 250.0)]
    var units = ["tsp", "tbs", "oz", "cup", "pint", "qrt", "gal", "ml", "ltr", "lbs", "gm", "kg", "e.a"]
    var timings = ["Breakfast", "Lunch", "Snacks", "Dinner"]
    
    private var processIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    func showProcessIndicator()
    {
        processIndicator.center = window!.center
        processIndicator.hidesWhenStopped = true
        processIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processIndicator.bringSubviewToFront(processIndicator)
        window?.addSubview(processIndicator)
        processIndicator.startAnimating()
    }
    
    func hideProcessIndicator()
    {
        processIndicator.stopAnimating()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "coredata.coredata" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("RecipeMadness", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("RecipeMadness.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String:AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

