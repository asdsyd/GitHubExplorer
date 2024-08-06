//
//  GitHubExplorerTests.swift
//  GitHubExplorerTests
//
//  Created by Asad Sayeed on 04/08/24.
//


import XCTest
@testable import GitHubExplorer
import CoreData

final class GitHubExplorerTests: XCTestCase {
    
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        //Initialize an in-memory NSPersistentContainer
        let persistenContainer = NSPersistentContainer(name: "NotesDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistenContainer.persistentStoreDescriptions = [description]
        
        persistenContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        context = persistenContainer.viewContext
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        context = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    //User Tests
    func testFormattedDateCreatedAt() {
        let user = User(login: "testUser",
                        avatarUrl: "https://example.com/avatar.png",
                        name: nil,
                        location: nil,
                        bio: nil,
                        company: nil,
                        publicRepos: 0,
                        publicGists: 0,
                        htmlUrl: "https://github.com/testuser",
                        following: 0,
                        followers: 0,
                        createdAt: "2023-08-01T00:00:00Z",
                        email: nil
        )
        
        XCTAssertEqual(user.formattedDateCreatedAt, "1 Aug 2023", "Expected formatted date to be '1 Aug 2023'")
    }
    
    //Note Tests
    //Testing the creation note
    func testCreateNote() {
        let note = Note(context: context)
        note.note = "This is a test note."
        note.username = "testuser"
        
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
        
        let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "username == %@", "testuser")
        do {
            let notes = try context.fetch(fetchRequest)
            XCTAssertEqual(notes.count, 1)
            XCTAssertEqual(notes.first?.note, "This is a test note.")
            XCTAssertEqual(notes.first?.username, "testuser")
        } catch {
            XCTFail("Failed to fetch notes: \(error)")
        }
        
    }
    
    
    //Testing updating the note
    func testUpdateNote() {
        let note = Note(context: context)
        note.note = "This is a test note."
        note.username = "testuser"
        
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
        
        note.note = "Updated note."
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
        
        let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "username == %@", "testuser")
        do {
            let notes = try context.fetch(fetchRequest)
            XCTAssertEqual(notes.count, 1)
            XCTAssertEqual(notes.first?.note, "Updated note.")
            XCTAssertEqual(notes.first?.username, "testuser")
        } catch {
            XCTFail("Failed to fetch notes: \(error)")
        }
    }

}
