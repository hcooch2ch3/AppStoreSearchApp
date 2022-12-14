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
