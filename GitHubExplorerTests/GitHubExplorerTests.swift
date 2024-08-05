//
//  GitHubExplorerTests.swift
//  GitHubExplorerTests
//
//  Created by Asad Sayeed on 04/08/24.
//

import XCTest
import CoreData
@testable import GitHubExplorer

class GitHubExplorerTests: XCTestCase {

    var coreDataStack: CoreDataStack!
    var managedContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStack = CoreDataStack(modelName: "GitHubExplorer")
        managedContext = coreDataStack.managedContext
    }

    override func tearDownWithError() throws {
        managedContext = nil
        coreDataStack = nil
        try super.tearDownWithError()
    }

    // MARK: - CoreData Model Tests

    func testNoteCreation() {
        let note = Note(context: managedContext)
        note.note = "Test note"
        note.username = "testuser"

        XCTAssertNoThrow(try managedContext.save())
        XCTAssertEqual(note.note, "Test note")
        XCTAssertEqual(note.username, "testuser")
    }

    func testNoteUpdate() {
        let note = Note(context: managedContext)
        note.note = "Initial note"
        note.username = "testuser"

        try? managedContext.save()

        note.note = "Updated note"
        XCTAssertNoThrow(try managedContext.save())
        XCTAssertEqual(note.note, "Updated note")
    }

    // MARK: - NetworkManager Tests

    func testGetFollowers() {
        let expectation = XCTestExpectation(description: "Fetch followers")
        
        NetworkManager.shared.getFollowers(page: 1) { result in
            switch result {
            case .success(let followers):
                XCTAssertFalse(followers.isEmpty)
            case .failure(let error):
                XCTFail("Failed to fetch followers: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetUserInfo() {
        let expectation = XCTestExpectation(description: "Fetch user info")
        
        NetworkManager.shared.getUserInfo(for: "octocat") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.login, "octocat")
            case .failure(let error):
                XCTFail("Failed to fetch user info: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}


//import XCTest
//@testable import GitHubExplorer
//import CoreData
//
//final class GitHubExplorerTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
////    func testUserCreation() {
////            let user = User(login: "testUser", avatarUrl: "https://example.com/avatar.jpg", name: "Test User", bio: "Test Bio", publicRepos: 10, followers: 100, following: 50, location: "Test Location", company: "Test Company", email: "test@example.com", createdAt: Date())
////            
////            XCTAssertEqual(user.login, "testUser")
////            XCTAssertEqual(user.avatarUrl, "https://example.com/avatar.jpg")
////            XCTAssertEqual(user.name, "Test User")
////            XCTAssertEqual(user.bio, "Test Bio")
////            XCTAssertEqual(user.publicRepos, 10)
////            XCTAssertEqual(user.followers, 100)
////            XCTAssertEqual(user.following, 50)
////            XCTAssertEqual(user.location, "Test Location")
////            XCTAssertEqual(user.company, "Test Company")
////            XCTAssertEqual(user.email, "test@example.com")
////        }
//
//}
