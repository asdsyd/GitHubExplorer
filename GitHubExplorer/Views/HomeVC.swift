//
//  HomeVC.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 31/07/24.
//

import UIKit

class HomeVC: UIViewController {
    
    let logoImageView = UIImageView()
    let callToActionButton = GEButton(backgroundColor: .systemGreen, title: "Tap to fetch list")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func pushFollowerListVC() {
//        guard isUsernameEntered else {
//            presentGEAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for.", buttonTitle: "Ok")
//            //default alert should be presented 
////            present(UIAlertController(title: "Hello", message: "msg here", preferredStyle: .actionSheet), animated: true)
//            return
//        }
        
        let followerListVC = FollowerListVC()
//        followerListVC.username = usernameTextField.text
//        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
//    func configureTextField() {
//        view.addSubview(usernameTextField)
//        usernameTextField.delegate = self
//        
//        NSLayoutConstraint.activate([
//            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
//            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
    
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
