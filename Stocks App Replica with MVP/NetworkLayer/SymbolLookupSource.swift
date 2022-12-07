//
//  SymbolLookup.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import Foundation
class SymbolLookupSource : Source{
    let symbol : String
    var path = "https://finnhub.io/api/v1/"
    var endPoint = EndPoint.symbolLookup

    init(symbol: String) {
        self.symbol = symbol
    }

    func createUrl() -> URL? {
        var components = URLComponents(string: baseUrl.absoluteString)
        components?.queryItems = [
            .init(name: "q", value: symbol),
            NetworkManager.tokenQueryItem
        ]
        return components?.url
    }
}
