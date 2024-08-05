//
//  NotesProvider.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 04/08/24.
//

import Foundation
import CoreData

final class NotesProvider {
    static let shared = NotesProvider()
    
    private let persistentContainer: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "NotesDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresovled error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func saveBackgroundContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createNoteIfNeeded(for follower: Follower) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() as! NSFetchRequest<Note>
        fetchRequest.predicate = NSPredicate(format: "username == %@", follower.login)
        
        do {
            let notes = try viewContext.fetch(fetchRequest)
            if notes.isEmpty {
                let newNote = Note(context: backgroundContext)
                newNote.username = follower.login
                newNote.note = ""
                saveBackgroundContext()
            }
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
        }
    }
    
    
    func getNoteForUser(_ follower: Follower) -> Note? {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() as! NSFetchRequest<Note>
        fetchRequest.predicate = NSPredicate(format: "username == %@", follower.login)
        
        do {
            return try viewContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch note: \(error.localizedDescription)")
            return nil
        }
    }
}
