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
    private var disposeBag = DisposeBag()

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
        viewModel.results.bind(to: appTableView.rx.items) { [weak self] (tableView: UITableView, index: Int, element: Listable) -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }
                switch self.viewModel.searchMode {
                case .recent:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentKeywordCell") as? RecentKeywordCell,
                          let keyword = element as? Keyword else { return UITableViewCell() }
                    cell.recentKeywordLabel.text = keyword.contents
                    return cell
                case .entering:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordCell") as? KeywordCell,
                          let keyword = element as? Keyword else { return UITableViewCell() }
                    cell.keywordLabel.text = keyword.contents
                    return cell
                case .searched:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell") as? AppCell,
                          let result = element as? Result else { return UITableViewCell() }
                    cell.configureCell(result)
                    return cell
                }
            }
            .disposed(by: disposeBag)
            
        appTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch self.viewModel.searchMode {
                case .recent, .entering:
                    if let keywords = try? self.viewModel.results.value() as? [Keyword],
                       keywords.count > indexPath.row {
                        let keyword = keywords[indexPath.row].contents
                        
                        self.viewModel.searchMode = .searched
                        self.viewModel.searchApp(keyword)
                        self.viewModel.saveRecentKeyword(keyword)
                        self.navigationItem.searchController?.searchBar.text = keyword
                    }
                case .searched: break
                }
            })
            .disposed(by: disposeBag)
        
        appTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AppDetailViewController,
              let cell = sender as? UITableViewCell,
              let indexPath = appTableView.indexPath(for: cell),
              let results = try? viewModel.results.value() as? [Result],
              results.count > indexPath.row else { return }
        
        let result = results[indexPath.row]
        destination.result = result
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        viewModel.searchMode = .searched
        viewModel.searchApp(keyword)
        viewModel.saveRecentKeyword(keyword)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.searchMode = .recent
        } else {
            viewModel.searchMode = .entering
            viewModel.searchApp(searchText)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if case .recent = self.viewModel.searchMode {
            let view = UIView()
            let label = UILabel()
            view.addSubview(label)
            view.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            label.text = "최근 검색어"
            label.font = UIFont.preferredFont(forTextStyle: .title2)
            
            return view
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if case .recent = self.viewModel.searchMode {
            height = 20
        }
        return height
    }
}

