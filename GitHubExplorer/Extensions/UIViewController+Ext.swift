//
//  UIViewController+Ext.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 02/08/24.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentGEAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GEAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    //loading spinner
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.75 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
         
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
//    func showEmptyStateView(with message: String, in view: UIView) {
//        let emptyStateView = GEEmptyStateView(message: message)
//        emptyStateView.frame = view.bounds
//        view.addSubview(emptyStateView)
//    }
}

extension UIImage {
    func inverted() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return nil }
        
        return UIImage(ciImage: outputImage)
    }
}
