//
//  CandleDataResponse.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import Foundation

struct CandlesDataResponse{
    let high : [Double]
    let close : [Double]
    let low : [Double]
    let open : [Double]
    let timestamps : [TimeInterval]

    var candles : [Candle] {
        var candles = [Candle]()
        for i in 0..<high.count{
            candles.append(.init(
                high: high[i],
                low: low[i],
                open: open[i],
                close: close[i],
                date: Date(timeIntervalSince1970: timestamps[i])
                ))
        }
        return candles
    }
}
extension CandlesDataResponse : Codable{
    enum CodingKeys : String, CodingKey{
        case high = "h"
        case close = "c"
        case low = "l"
        case open = "o"
        case timestamps = "t"
        //case status = "s"
    }
}

struct Candle : Codable{
    let high : Double
    let low : Double
    let open : Double
    let close : Double
    let date : Date
}
