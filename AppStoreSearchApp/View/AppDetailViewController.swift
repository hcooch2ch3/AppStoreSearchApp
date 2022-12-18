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
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var screenshotCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var downloadButton: UIButton!
    
    private enum Const {
        static var itemSize = CGSize(width: 300 * (392.0/696.0), height: 300)
        static let itemSpacing = 10.0
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadButton.backgroundColor = .systemGray6
        downloadButton.layer.masksToBounds = true
        downloadButton.layer.cornerRadius = 10.0
        
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 20
        
        if let firstUrl = result?.screenshotUrls?.first, firstUrl.contains("406x228") {
            let ratio = 0.8
            let width = 406 * ratio
            let height = 228 * ratio
            Const.itemSize = CGSize(width: width, height: height)
            screenshotCollectionViewHeight.constant = height + 5
        } else {
            Const.itemSize = CGSize(width: 300 * (392.0/696.0), height: 300)
        }
        
        titleLabel.text = result?.trackName
        if let artworkUrl512 = result?.artworkUrl512, let url = URL(string: artworkUrl512) {
            iconImageView.kf.setImage(with: url)
        }
        appDescriptionLabel.text = result?.appDescription
        subtitleLabel.text = result?.artistName
        
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
        
        cell.screenShotImageView.clipsToBounds = true
        cell.screenShotImageView.layer.cornerRadius = 20
        
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


