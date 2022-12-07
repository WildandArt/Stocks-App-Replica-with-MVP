//
//  ViewController.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import UIKit
protocol searchResultDelegate : AnyObject {
    //var searchResults : [SearchResult] {get set}
    func maybe(results : [SearchResult])->[SearchResult]
}
class MainVC: UIViewController, UISearchControllerDelegate {
    var symbolResults = [SearchResult]()
    var networkmanager : NetworkManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearch()
        networkmanager = NetworkManager()
    }
    func setupSearch(){
        let resultVC = SearchResultVC()
        let stocksSearchController = UISearchController(searchResultsController: resultVC)
        resultVC.searchDelegate = self
        stocksSearchController.searchResultsUpdater = self
        navigationItem.searchController = stocksSearchController
    }
}
extension MainVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard var text = searchController.searchBar.text,
              (
                  !text.isEmpty
              )
        else {
            print("no results")
            return}
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(text)


        guard let resultVC = searchController.searchResultsController as? SearchResultVC else {return}

        let url = SymbolLookupSource(symbol: text).createUrl()
        print(url)
        guard let url = url else {
            print("updateSearchResults error")
            return}


            self.networkmanager?.request(with: url, completion: {
                [weak self] (result : Result<SymbolResponse , NetworkError>) in
                guard let self = self else {return}

                switch result{

                case .success(let response):
                    print("success")
                        self.symbolResults = response.result
                        resultVC.updateWithResults(results: self.symbolResults)



                case .failure(let error):
                    resultVC.updateWithResults(results: [])
                    print(error)
                }
            })

        //call for symbol request with the network manager
    }


}
extension MainVC : searchResultDelegate{
    func maybe(results : [SearchResult])->[SearchResult]{
        return results
    }
}

