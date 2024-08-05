//
//  User.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 02/08/24.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var company: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
    var email: String?

    
    var formattedDateCreatedAt: String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        } else {
            return "N/A"
        }
    }
}
