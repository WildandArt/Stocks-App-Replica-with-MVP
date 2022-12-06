//
//  ViewController.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import UIKit



class ViewController: UIViewController {
    var candles : [Candle]?
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = CandleSticksSource(symbol: "AAPL").createUrl()!
        print("\(url)")
        let network = NetworkManager()
        network.candleRequest(with: url) { (result : Result<CandlesDataResponse, NetworkError>) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let candleStick):
                print("\(candleStick.candles)")

            }
        }



//        let url = createUrl(for: "AAPL")
////        let url = URL(string: "https://finnhub.io/api/v1/stock/candle?symbol=AAPL&resolution=D&from=1572651390&to=1575243390&token=cdu8amqad3i5v3urh37gcdu8amqad3i5v3urh380")!
//        CandleRequest(with: url) {[weak self] (result: Result<CandlesDataResponse, Error>) in
//            switch result{
//            case .success(let response):
//                self?.candles  = response.candles
//                print(self?.candles)
//            case .failure(let error):
//                print(error)
//            }
//        }
        // Do any additional setup after loading the view.
    }
}

