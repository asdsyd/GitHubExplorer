//
//  Note.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 04/08/24.
//

import Foundation
import CoreData

final class Note: NSManagedObject {
    
    @NSManaged var note: String
    @NSManaged var username: String
    
    
}
