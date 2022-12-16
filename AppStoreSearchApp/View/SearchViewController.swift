//
//  SearchViewController.swift
//  AppStoreSearchApp
//
//  Created by 임성민 on 2022/12/14.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    private var viewModel = SearchViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var appTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpTableView()
    }
    
    func setUpNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter Keyword"
        navigationItem.searchController = searchController
        navigationItem.title = "Search AppStore"
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setUpTableView() {
        viewModel.results
            .bind(to: appTableView.rx.items(cellIdentifier: "AppCell", cellType: AppCell.self)) { (index: Int, element: Result, cell: AppCell) in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AppDetailViewController,
              let cell = sender as? UITableViewCell,
              let indexPath = appTableView.indexPath(for: cell),
              let results = try? viewModel.results.value() else { return }
        
        let result = results[indexPath.row]
        destination.result = result
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        viewModel.searchApp(keyword)
    }
}

