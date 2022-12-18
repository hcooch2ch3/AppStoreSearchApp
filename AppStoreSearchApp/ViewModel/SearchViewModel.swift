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
    var searchService: SearchService = SearchService()
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
    var fileStorage = UserDefaults.standard
    let fileStorageKey = "RecentKeywords"
    
    enum SearchMode {
        case recent
        case searched
        case entering
    }
    
    init() {
        loadRecentKeyword()
    }
    
    func searchApp(_ keyword: String, _ completion: @escaping () -> Void) {
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
                completion()
            }, onError: { error in
                print("error", error)
            })
            .disposed(by: disposeBag)
    }
    
    func saveRecentKeyword(_ keyword: String) {
        if var recentKeywords = fileStorage.array(forKey: fileStorageKey) as? [String] {
            guard recentKeywords.contains(keyword) == false else { return }
            recentKeywords.append(keyword)
            fileStorage.set(recentKeywords, forKey: fileStorageKey)
        } else {
            fileStorage.set([keyword], forKey: fileStorageKey)
        }
    }
    
    func loadRecentKeyword() {
        guard let recentKeywords = fileStorage.array(forKey: fileStorageKey) as? [String] else {
            results.onNext([])
            return
        }
        let loadedRecentKeyword = recentKeywords.map {
            Keyword(contents: $0)
        }
        results.onNext(loadedRecentKeyword)
    }
}
