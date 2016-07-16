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
    
    private init() {
        // do nothing - required to stop instances being
        // created by code in other files
    }
    
    func saveTextNote(note: String) {
        let newNote = NSEntityDescription.insertNewObjectForEntityForName("Notes", inManagedObjectContext: contextOfOurApp)
        newNote.setValue(note, forKey: "note")
        
        do {
            try contextOfOurApp.save()
            
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    
    func removeFromTextNotes(noteText: String) {
        let request = NSFetchRequest(entityName: "Notes")
        request.predicate = NSPredicate(format: "note == %@", noteText)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try contextOfOurApp.executeFetchRequest(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    contextOfOurApp.deleteObject(result)
                    
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
    
    func getDataFromEntity(entity: String, inout managedObjects: [NSManagedObject]) {
        let request = NSFetchRequest(entityName: entity)
        
        do {
            let results = try contextOfOurApp.executeFetchRequest(request)
            if results.count > 0 {
                managedObjects = results as! [NSManagedObject]
            }
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
}
