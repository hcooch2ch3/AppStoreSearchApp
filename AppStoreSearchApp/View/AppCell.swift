//
//  AppCell.swift
//  AppStoreSearchApp
//
//  Created by 임성민 on 2022/12/15.
//

import UIKit
import Kingfisher

class AppCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starTotalCountLabel: UILabel!
    @IBOutlet weak var screenShotsStackView: UIStackView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    func configureCell(_ result: Result) {
        downloadButton.backgroundColor = .systemGray6
        downloadButton.layer.masksToBounds = true
        downloadButton.layer.cornerRadius = 10.0
        
        titleLabel.text = result.trackName
        subtitleLabel.text = result.primaryGenreName
        if let userRatingCount = result.userRatingCount {
            ratingCountLabel.text = "\(userRatingCount)"
        }
        if let artworkUrl512 = result.artworkUrl512, let url = URL(string: artworkUrl512) {
            iconImageView.kf.setImage(with: url)
            iconImageView.clipsToBounds = true
            iconImageView.layer.cornerRadius = 20
        }
        if let screenshotUrls = result.screenshotUrls {
            configureScreenshots(screenshotUrls)
        }
        if let averageUserRating = result.averageUserRating {
            fillStars(averageUserRating)
        }
    }
    
    private func configureScreenshots(_ screenshotUrls: [String]) {
        var isVertical = true
        if let firstUrl = screenshotUrls.first, firstUrl.contains("406x228") {
            isVertical = false
        }
        
        if isVertical {
            for (index, screenshotUrl) in screenshotUrls.enumerated() {
                if index >= 3 { return }
                guard let url = URL(string: screenshotUrl) else { continue }
                let imageView = UIImageView()
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 20
                
                imageView.kf.setImage(with: url)
                screenShotsStackView.addArrangedSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalTo: screenShotsStackView.widthAnchor, multiplier: 0.32).isActive = true
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 696.0/392.0).isActive = true
            }
        } else {
            guard let firstUrl = screenshotUrls.first, let url = URL(string: firstUrl) else { return }
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.kf.setImage(with: url)
            screenShotsStackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalTo: screenShotsStackView.widthAnchor, multiplier: 1).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 228.0/406.0).isActive = true
        }
    }
    
    private func fillStars(_ averageUserRating: Double) {
        let filledStarsCountResult = getFilledStarsCount(averageUserRating)
        let starCount = filledStarsCountResult.0
        let isHalf = filledStarsCountResult.1
        
        for i in 0..<starCount {
            guard let starImageView = starStackView.arrangedSubviews[i] as? UIImageView else {
                continue
            }
            starImageView.image = UIImage(systemName: "star.fill")
        }
        
        if isHalf, let starImageView = starStackView.arrangedSubviews[starCount] as? UIImageView {
            starImageView.image = UIImage(systemName: "star.leadinghalf.filled")
        }
    }
    
    private func getFilledStarsCount(_ averageUserRating: Double) -> (Int, Bool) {
        var starCount = 0
        var isHalf = false
        let squareOfAverageUserRating = Int(round(averageUserRating * 2))
        if squareOfAverageUserRating % 2 == 1 {
            isHalf = true
        }
        starCount = squareOfAverageUserRating/2
        
        return (starCount, isHalf)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.kf.cancelDownloadTask()
        screenShotsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for view in starStackView.arrangedSubviews {
            guard let starImageView = view as? UIImageView else { continue }
            starImageView.image = UIImage(systemName: "star")
        }
    }
}
