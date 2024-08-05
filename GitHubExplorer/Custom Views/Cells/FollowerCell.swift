//
//  FollowerCell.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 03/08/24.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseID = "FollowerCell"
    
    let avatarImageView = GEAvatarImageView(frame: .zero)
    let usernameLabel = GETitleLabel(textAlignment: .left, fontSize: 16)
    let detailsLabel = GEBodyLabel(textAlignment: .left)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        detailsLabel.text = "details"
        avatarImageView.downloadImage(from: follower.avatarUrl)

    }
    
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(detailsLabel)
  
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            detailsLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            detailsLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    
}

extension FollowerCell {
    func removeNoteIcon() {
        contentView.subviews.forEach { subview in
            if subview is UIImageView && subview != avatarImageView {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func addNoteIcon() {
        let noteImageView = UIImageView(image: UIImage(systemName: "note.text"))
        noteImageView.tintColor = .systemYellow
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noteImageView)
        
        NSLayoutConstraint.activate([
            noteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            noteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            noteImageView.widthAnchor.constraint(equalToConstant: 20),
            noteImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
