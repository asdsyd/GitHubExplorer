//
//  FollowerListVC.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 01/08/24.
//

import UIKit
import SwiftUI

class FollowerListVC: UIViewController {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController() //Set up the view controller appearance.
        configureSearchController() //Set up the search controller.
        configureCollectionView() //Set up the collection view layout and appearance
        getFollowers(page: 1) //Fetch initial followers
        configureDataSource() //Set up the data source for the collection view
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        collectionView.reloadData() //Reload the collection view data to update the notes icon
    }
    
    //Configure the main view controller properties
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
    }
    
    //Configure the collection view
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createSingleColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    // Congfiure the search controller for searching followers
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    // fetch list of users from the github api in this case it is being named as "Followers"
    func getFollowers(page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
                
            case.success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                self.updateData(on: self.followers)
                
            case .failure(let error):
                self.presentGEAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // configure teh data source for the collection view
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            cell.removeNoteIcon()
            
            // Invert avatar for every fourth item
            if indexPath.item % 4 == 3 {
                cell.avatarImageView.image = cell.avatarImageView.image?.inverted()
            }
            
            //Check if there is note and add noteIcon
            if let note = NotesProvider.shared.getNoteForUser(follower), !note.note.isEmpty {
                cell.addNoteIcon()
            }
            
            return cell
        })
    }
    
    // update the data in the collection view
    func updateData(on followers : [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    // handle the scolling to load more github users
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(page: page)
        }
    }
    
    // handle the selection of a github user ( follower )
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let userProfileView = UserProfile(username: follower.login)
        let hostingController = UIHostingController(rootView: userProfileView)
        navigationController?.pushViewController(hostingController, animated: true)
        
    }
    
    // update search results based on the search text
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            updateData(on: followers)
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter{ follower in
            let matchesUsername = follower.login.lowercased().contains(filter.lowercased())
            let note = NotesProvider.shared.getNoteForUser(follower)?.note ?? ""
            let matchesNote = note.lowercased().contains(filter.lowercased())
            return matchesUsername || matchesNote
        }
        updateData(on: filteredFollowers)
    }
    
    // reload the data in the collection view : used for providing the notes icon
    func reloadData() {
        updateData(on: isSearching ? filteredFollowers : followers)
    }
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    // handle cancel button in the serach bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

