//
//  SearchResult.swift
//  AppStoreSearchApp
//
//  Created by 임성민 on 2022/12/15.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let resultCount: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable, Listable {
    let screenshotUrls, ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60, artworkUrl512, artworkUrl100: String?
    let artistViewUrl: String?
    let isGameCenterEnabled: Bool?
    let features: [String]?
    let supportedDevices, advisories: [String]?
    let kind: String?
    let currency: String?
    let minimumOsVersion, trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    let sellerUrl: String?
    let formattedPrice: String?
    let contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let averageUserRating: Double?
    let trackViewUrl: String?
    let trackContentRating: String?
    let appDescription, bundleId: String?
    let genreIds: [String]?
    let releaseDate: String?
    let sellerName, primaryGenreName: String?
    let primaryGenreId, trackId: Int?
    let trackName: String?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let currentVersionReleaseDate: String?
    let releaseNotes: String?
    let artistId: Int?
    let artistName: String?
    let genres: [String]?
    let price: Int?
    let version: String?
    let wrapperType: String?
    let userRatingCount: Int?

    enum CodingKeys: String, CodingKey {
        case screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100
        case artistViewUrl
        case isGameCenterEnabled, features, supportedDevices, advisories, kind, currency
        case minimumOsVersion
        case trackCensoredName, languageCodesISO2A, fileSizeBytes
        case sellerUrl
        case formattedPrice, contentAdvisoryRating, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, averageUserRating
        case trackViewUrl
        case trackContentRating
        case appDescription = "description"
        case bundleId
        case genreIds
        case releaseDate, sellerName, primaryGenreName
        case primaryGenreId
        case trackId
        case trackName, isVppDeviceBasedLicensingEnabled, currentVersionReleaseDate, releaseNotes
        case artistId
        case artistName, genres, price, version, wrapperType, userRatingCount
    }
}
