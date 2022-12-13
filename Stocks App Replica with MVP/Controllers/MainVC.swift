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
    var watchList = ["AAPL", "MSFT", "META", "SNAP"]
    var candleSticks = [String : [Candle]]()

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
    func setUpRefreshControl(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(setupWatchlist), for: .valueChanged)
    }
    func setupTableView(){
        view.addSubview(tableView)
        setUpRefreshControl()
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
    @objc func setupWatchlist(){
//        //Dispatch Group
        let group = DispatchGroup()
        var dict = [String : [Candle]]()

        for symbol in watchList{

            let url = CandleSticksSource(symbol: symbol).createUrl()!


            group.enter()
            networkmanager?.request(with: url, completion: {
                [weak self] (result : Result<CandlesDataResponse, NetworkError>) in

                guard let self = self else {return}

                switch result{
                    case .success(let response):
                    dict[symbol] = response.candles
                    print(dict.keys)
                    print("is nil?\(dict[symbol]?.isEmpty)")
                    case .failure(let error):
                        print(error)
                }
                self.tableView.refreshControl?.endRefreshing()
                group.leave()
            })
        }

        group.notify(queue: .main) {
//            guard let self = self else {return}
            print("notify")
            print("dict :\(dict.keys)")
            self.candleSticks = dict
            print(self.candleSticks.keys)
            self.tableView.reloadData()
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
extension MainVC{
    func sortedByDateCandleArray(for symbol: String)-> [Candle]?{

        guard var candleArray = candleSticks[symbol] else {
            print("for this symbol: \(symbol) candle array is nil")
            return nil}
        return candleArray.sorted{$0.date < $1.date}
    }
    func getLastPrice(for symbol : String) -> Double?{
        var sortedArray = sortedByDateCandleArray(for: symbol)
        guard let last = sortedArray?.last else {return nil}
        print("Last CLOSE : \(last.close) date: \(last.date)")
        return last.close
    }
    func getChangeInPrice(for symbol: String)-> Double?{

        let sortedArray = sortedByDateCandleArray(for: symbol)
//        print(sortedArray?.forEach({ c in
//            print(c.close)
//        }))
        let twentyFourHoursInSeconds = 60 * 60 * 24
        var lastDate = sortedArray?.last?.date
        guard var lastDateBackTwentyFour = lastDate?.addingTimeInterval(-TimeInterval(twentyFourHoursInSeconds))
                                                          else {return nil}
        print("lastDate: \(lastDate)")
        guard let prevCandle = sortedArray?.last(where: { candle in
            candle.date < lastDateBackTwentyFour
        }) else {return nil}
        print("prevDate\(prevCandle.date)")
        let prevPrice = (prevCandle.close)
        guard let lastPrice = getLastPrice(for: symbol) else {return nil}
        let changeRatio = lastPrice/prevPrice
        let percentages = changeRatio - 1
        print("percentages: \(percentages)")
        return percentages

        //let previous = sortedArray.
        //let last = getLastPrice(for: symbol)
    }
}
extension MainVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewCell.identifier,
            for: indexPath) as? MainViewCell else {fatalError()}
        let symbol = watchList[indexPath.row]
        cell.priceLabel.text = String(describing: getLastPrice(for: symbol) ?? 0)
        let change = getChangeInPrice(for: symbol) ?? 0
        if change > 0 {
            cell.priceChangeLabel.backgroundColor = .systemGreen
        }
        else{
            cell.priceChangeLabel.backgroundColor = .systemRed
        }
        print("change \(NumberFormatter.customNumberFormatter.string(from: change as NSNumber))")
        cell.priceChangeLabel.text = NumberFormatter.customNumberFormatter.string(from: change as NSNumber)
        cell.symbolLabel.text = watchList[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList.count
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

