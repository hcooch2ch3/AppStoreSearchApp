//
//  AppDetailViewController.swift
//  AppStoreSearchApp
//
//  Created by 임성민 on 2022/12/16.
//

import UIKit

class AppDetailViewController: UIViewController {
    var result: Result?
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    private enum Const {
        static let itemSize = CGSize(width: 200, height: 300)
        static let itemSpacing = 3.0
        
        static var insetX: CGFloat {
            5
        }
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = result?.trackName
        if let artworkUrl512 = result?.artworkUrl512, let url = URL(string: artworkUrl512) {
            iconImageView.kf.setImage(with: url)
        }
        appDescriptionLabel.text = result?.appDescription
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Const.itemSize
        layout.minimumLineSpacing = Const.itemSpacing
        layout.minimumInteritemSpacing = 0
        screenshotCollectionView.collectionViewLayout = layout
        screenshotCollectionView.isPagingEnabled = false
        screenshotCollectionView.contentInsetAdjustmentBehavior = .never
        screenshotCollectionView.contentInset = Const.collectionViewContentInset
        screenshotCollectionView.decelerationRate = .fast
        screenshotCollectionView.delegate = self
        screenshotCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func touchUpShowMoreButton(_ sender: Any) {
        appDescriptionLabel.numberOfLines = 0
        showMoreButton.isHidden = true
    }
}

extension AppDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let screenshotUrls = result?.screenshotUrls {
            return screenshotUrls.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCell", for: indexPath) as? ScreenshotCell else { return UICollectionViewCell() }
        
        if let urlString = result?.screenshotUrls?[indexPath.row],
           let url = URL(string: urlString) {
            cell.screenShotImageView.kf.setImage(with: url)
        }
        
        return cell
    }
}

extension AppDetailViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}


