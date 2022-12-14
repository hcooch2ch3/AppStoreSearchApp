//
//  SearchViewModel.swift
//  AppStoreSearchApp
//
//  Created by 임성민 on 2022/12/15.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    private let searchService = SearchService()
    private let disposeBag = DisposeBag()
    let results = BehaviorSubject<[Result]>(value: [])
    private var keyword: String?
    
    func searchApp(_ keyword: String) {
        self.keyword = keyword
        
        searchService.searchApp(keyword)
            .subscribe(onNext: { [weak self] searchResult in
                guard let self = self else { return }
                if let results = searchResult.results {
                    self.results.onNext(results)
                }
            }, onError: { error in
                print("error", error)
            })
            .disposed(by: disposeBag)
    }
}
