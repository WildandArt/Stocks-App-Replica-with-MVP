//
//  ViewController.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import UIKit
protocol searchResultDelegate : AnyObject {
    func maybe(results : [SearchResult])->[SearchResult]
}
class MainVC: UIViewController, UISearchControllerDelegate {

    var searchTimer : Timer?
    var symbolResults = [SearchResult]()
    var networkmanager : NetworkManager?
    var watchList = ["AAPL", "MSFT"]
    var candleSticks = [String : CandlesDataResponse]()

    var tableView : UITableView = {
        let tableview = UITableView()
        tableview.register(MainViewCell.self,
                           forCellReuseIdentifier: MainViewCell.identifier)
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSearch()
        networkmanager = NetworkManager()
        setupTableView()
        setupWatchlist()
    }
    func setupSearch(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Stocks"
        navigationItem.hidesSearchBarWhenScrolling = false
        let resultVC = SearchResultVC()
        let stocksSearchController = UISearchController(searchResultsController: resultVC)
        resultVC.searchDelegate = self
        stocksSearchController.searchResultsUpdater = self
        navigationItem.searchController = stocksSearchController
    }
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setupWatchlist(){
        for symbol in watchList{
            let url = CandleSticksSource(symbol: symbol).createUrl()!
            networkmanager?.request(with: url, completion: {
                [weak self] (result : Result<CandlesDataResponse, NetworkError>) in

                guard let self = self else {return}

                switch result{
                    case .success(let response):
                    self.candleSticks[symbol] = response
                    case .failure(let error):
                    print(error)
                }
            })
        }
        //make an api call for each stock in a watchlist and then present the recent price
        //for that: create a candlestick source,
        //request for that symbol and fetch the last price, append to a list in tableview
    }
}
extension MainVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard var text = searchController.searchBar.text,
              !(
                  text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
              )
        else {
            print("no results")
            return}

        print(text)


        guard let resultVC = searchController.searchResultsController as? SearchResultVC else {return}


            searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.20,
                                           repeats: false,
                                           block: { timer in
            let url = SymbolLookupSource(symbol: text).createUrl()

            guard let url = url else {
                print("updateSearchResults error")
                return}
            print(url)
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

        })
        //call for symbol request with the network manager
    }
}
extension MainVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewCell.identifier,
            for: indexPath) as? MainViewCell else {fatalError()}
        cell.priceLabel.text = "148.9"
        cell.symbolLabel.text = "AAPL"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60.0)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension MainVC : searchResultDelegate{
    func maybe(results : [SearchResult])->[SearchResult]{
        return results
    }
}

