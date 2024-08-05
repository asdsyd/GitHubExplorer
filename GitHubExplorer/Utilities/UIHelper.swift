//
//  UIHelper.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 03/08/24.
//

import UIKit

struct UIHelper {
    static func createSingleColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let itemHeight: CGFloat = 80
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: width - (padding * 2), height: itemHeight)
        
        return flowLayout
    }
}
