//
//  AppStoreSearchAppTests.swift
//  AppStoreSearchAppTests
//
//  Created by 임성민 on 2022/12/18.
//

import XCTest
@testable import AppStoreSearchApp

final class AppStoreSearchAppTests: XCTestCase {
    var searchViewModel = SearchViewModel()
    var fileStorage: UserDefaults! = UserDefaults(suiteName: UUID().uuidString)

    override func setUpWithError() throws {
        let mockSearchService = MockSearchService()
        fileStorage.set([], forKey: searchViewModel.fileStorageKey)
        searchViewModel.searchService = mockSearchService
        searchViewModel.fileStorage = fileStorage
    }
    
    /// 사용자가 키워드 입력 완료 상태에서, 키워드 검색이 정상적으로 이루어지는지 테스트
    func testSearchAppOnSearchedMode() throws {
        // Given
        let expectation = XCTestExpectation(description: "SearchAppTest")
        searchViewModel.searchMode = .searched
        
        // When
        searchViewModel.searchApp("SearchAppTest") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        
        // Then
        let results = try? searchViewModel.results.value()
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 1)
    }
    
    /// 사용자가 키워드 입력 중 상태에서, 현재 검색어와 일치하는 검색이 정상적으로 이루어지는지 테스트
    func testSearchAppOnEnteringMode() throws {
        // Given
        let expectation = XCTestExpectation(description: "SearchAppTest")
        searchViewModel.searchMode = .entering
        
        // When
        searchViewModel.searchApp("SearchAppTest") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        
        // Then
        let results = try? searchViewModel.results.value()
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 1)
    }
    
    /// 사용자가 키워드 입력 하기 전 상태에서, 키워드 검색이 정상적으로 이루어지는지 테스트
    func testSearchAppOnRecentMode() throws {
        // Given
        let expectation = XCTestExpectation(description: "SearchAppTest")
        searchViewModel.searchMode = .recent
        let fileStorageResults = fileStorage.array(forKey: searchViewModel.fileStorageKey) as? [String]
        
        // When
        searchViewModel.searchApp("SearchAppTest") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        
        // Then
        let results = try? searchViewModel.results.value()
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, fileStorageResults?.count)
    }
    
    /// 같은 키워드가 두번 중복적으로 입력 되었을 때, 로컬 스토리지에 한번만 저장되는지 확인
    func testSaveRecentKeywordRedundantly() throws {
        // Given
        let keyword = "Kakao"
        let fileStorageResults = fileStorage.array(forKey: searchViewModel.fileStorageKey) as? [String]
        
        // When
        searchViewModel.saveRecentKeyword(keyword)
        searchViewModel.saveRecentKeyword(keyword)
        
        // Then
        let results = fileStorage.array(forKey: searchViewModel.fileStorageKey) as? [String]
        XCTAssertNotNil(results)
        XCTAssertEqual((results?.count ?? 0), (fileStorageResults?.count ?? 0) + 1)
    }
    
    /// 다른 키워드가 두번 입렫되었을 때, 로컬 스토리지에 두번 다 저장되는지 확인
    func testSaveRecentKeywordNotRedundantly() throws {
        // Given
        let firstKeyword = UUID().uuidString
        let secondKeyword = UUID().uuidString
        let fileStorageResults = fileStorage.array(forKey: searchViewModel.fileStorageKey) as? [String]
        
        // When
        searchViewModel.saveRecentKeyword(firstKeyword)
        searchViewModel.saveRecentKeyword(secondKeyword)
        
        // Then
        let results = fileStorage.array(forKey: searchViewModel.fileStorageKey) as? [String]
        XCTAssertNotNil(results)
        XCTAssertEqual((results?.count ?? 0), (fileStorageResults?.count ?? 0) + 2)
    }
    
    /// 로컬 스토리지에 있는 키워드가 정상적으로 불러지는지 확인
    func testLoadRecentKeyword() throws {
        // Given
        let fileStorageResults = fileStorage.array(forKey: searchViewModel.fileStorageKey) as? [String]
        
        // When
        searchViewModel.loadRecentKeyword()
        
        // Then
        guard let searchViewModelResults = try? searchViewModel.results.value() as? [Keyword] else {
            XCTFail("searchViewModelResults is nil.")
            return
        }
        let keywords = searchViewModelResults.map { $0.contents }
        XCTAssertNotNil(fileStorageResults)
        XCTAssertEqual(fileStorageResults, keywords)
    }
}
