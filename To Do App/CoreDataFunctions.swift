//
//  CoreDataFunctions.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 05/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import Foundation
import CoreData

let globalCoreDataFunctions = CoreDataFunctions()

final class CoreDataFunctions {
    
    
    
    func saveTextNote(note: String) {
        // create Core Data entity
        let newNote = NSEntityDescription.insertNewObjectForEntityForName("Notes", inManagedObjectContext: contextOfOurApp)
        newNote.setValue(note, forKey: "note")
        do {
            try contextOfOurApp.save()
            
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    
    func removeFromTextNotes(noteText: String) {
        
        // create request for data in Core Data entity - with this we get all of our data
        let request = NSFetchRequest(entityName: "Notes")
        request.predicate = NSPredicate(format: "note == %@", noteText)
        
        // we need to use this if we want to see actual data in our app
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try contextOfOurApp.executeFetchRequest(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    contextOfOurApp.deleteObject(result)
                    
                    // we save our data
                    do {
                        try contextOfOurApp.save()
                    } catch let error as NSError{
                        print ("There was an error \(error), \(error.userInfo)")
                    }
                }
            }
            
        } catch let error as NSError {
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    
    func getDataFromEntity(entity: String, ) {
        
        let request = NSFetchRequest(entityName: entity)
        
        do {
            // try to get data from Corde Data entity
            let results = try contextOfOurApp.executeFetchRequest(request)
            
            // check if there is any data
            if results.count > 0 {
                toDoNotes = results as! [NSManagedObject]
            }
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }

}
