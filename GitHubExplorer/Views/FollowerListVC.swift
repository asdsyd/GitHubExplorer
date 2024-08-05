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
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(page: 1)
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        collectionView.reloadData()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createSingleColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    
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
    
    
    func updateData(on followers : [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let userProfileView = UserProfile(username: follower.login)
        let hostingController = UIHostingController(rootView: userProfileView)
        navigationController?.pushViewController(hostingController, animated: true)
        
    }
    
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
    
    func reloadData() {
        updateData(on: isSearching ? filteredFollowers : followers)
    }
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
//        isSearching = true
//        filteredFollowers = followers.filter { follower in
////            $0.login.lowercased().contains(filter.lowercased())
//            let matchesUsername = follower.login.lowercased().contains(filter.lowercased())
//            let matchesNote = NotesProvider.shared.getNoteForUser(
//                Follower(login: follower.login, avatarUrl: follower.avatarUrl))?.note.lowercased().contains(filter.lowercased()) ?? false
//            return matchesUsername || matchesNote
//        }
//        updateData(on: filteredFollowers)
//    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

