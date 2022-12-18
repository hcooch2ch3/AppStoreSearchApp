//
//  SearchService.swift
//  AppStoreSearchApp
//
//  Created by 임성민 on 2022/12/15.
//

import Foundation
import Alamofire
import RxSwift

class SearchService {
    func searchApp(_ keyword: String) -> Observable<SearchResult> {
        return Observable<SearchResult>.create { observer in
            let url = "https://itunes.apple.com/search"
            let parameters = ["media": "software", "country": "kr", "term": keyword]
            let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["text/javascript"])
                .responseDecodable(of: SearchResult.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

class MockSearchService: SearchService {
    override func searchApp(_ keyword: String) -> Observable<SearchResult> {
        return Observable<SearchResult>.create { observer in
            let result = Result(screenshotUrls: nil, ipadScreenshotUrls: nil, appletvScreenshotUrls: nil, artworkUrl60: nil, artworkUrl512: nil, artworkUrl100: nil, artistViewUrl: nil, isGameCenterEnabled: nil, features: nil, supportedDevices: nil, advisories: nil, kind: nil, currency: nil, minimumOsVersion: nil, trackCensoredName: nil, languageCodesISO2A: nil, fileSizeBytes: nil, sellerUrl: nil, formattedPrice: nil, contentAdvisoryRating: nil, averageUserRatingForCurrentVersion: nil, userRatingCountForCurrentVersion: nil, averageUserRating: nil, trackViewUrl: nil, trackContentRating: nil, appDescription: nil, bundleId: nil, genreIds: nil, releaseDate: nil, sellerName: nil, primaryGenreName: nil, primaryGenreId: nil, trackId: nil, trackName: "MockSearchService", isVppDeviceBasedLicensingEnabled: nil, currentVersionReleaseDate: nil, releaseNotes: nil, artistId: nil, artistName: nil, genres: nil, price: nil, version: nil, wrapperType: nil, userRatingCount: nil)
            let searchResult = SearchResult(resultCount: 1, results: [result])
            
            observer.onNext(searchResult)
            observer.onCompleted()
            
            return Disposables.create {}
        }
    }
}
