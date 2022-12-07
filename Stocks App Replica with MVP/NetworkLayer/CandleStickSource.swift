//
//  CandleStickSource.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import Foundation


class CandleSticksSource : Source{
    var path = "https://finnhub.io/api/v1/stock/"
    var endPoint = EndPoint.candleStick
    let symbol : String
    init(symbol: String) {
        self.symbol = symbol
    }

    func createUrl() -> URL?{
        var today = Date().timeIntervalSince1970
        var sevenDaysAgo = today - TimeInterval(timesConstants.week)
        var components = URLComponents(string: baseUrl.absoluteString)

        components?.queryItems = [
                                  .init(name: "symbol", value: symbol),
                                  .init(name: "resolution", value: "1"),
                                  .init(name: "from", value: "\(Int(sevenDaysAgo))"),
                                  .init(name: "to", value: "\(Int(today))"),
                                   NetworkManager.tokenQueryItem]
        return components?.url
    }
}
