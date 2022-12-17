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
    let results = BehaviorSubject<[Listable]>(value: [])
    var searchMode: SearchMode = .recent {
        didSet {
            switch searchMode {
            case .recent: loadRecentKeyword()
            case .searched: break
            case .entering: results.onNext([])
            }
        }
    }
    
    enum SearchMode {
        case recent
        case searched
        case entering
    }
    
    init() {
        loadRecentKeyword()
    }
    
    func searchApp(_ keyword: String) {
        searchService.searchApp(keyword)
            .subscribe(onNext: { [weak self] searchResult in
                guard let self = self,
                      let results = searchResult.results else { return }
                
                switch self.searchMode {
                case .recent: break
                case .searched: self.results.onNext(results)
                case .entering:
                    let keywords: [Keyword] = results.compactMap {
                        guard let trackName = $0.trackName else { return nil }
                        return Keyword(contents: trackName)
                    }
                    self.results.onNext(keywords)
                }
            }, onError: { error in
                print("error", error)
            })
            .disposed(by: disposeBag)
    }
    
    func saveRecentKeyword(_ keyword: String) {
        if var recentKeywords = UserDefaults.standard.array(forKey: "RecentKeywords") as? [String] {
            guard recentKeywords.contains(keyword) == false else { return }
            recentKeywords.append(keyword)
            UserDefaults.standard.set(recentKeywords, forKey: "RecentKeywords")
        } else {
            UserDefaults.standard.set([keyword], forKey: "RecentKeywords")
        }
    }
    
    func loadRecentKeyword() {
        guard let recentKeywords = UserDefaults.standard.array(forKey: "RecentKeywords") as? [String] else {
            results.onNext([])
            return
        }
        let loadedRecentKeyword = recentKeywords.map {
            Keyword(contents: $0)
        }
        results.onNext(loadedRecentKeyword)
    }
}
