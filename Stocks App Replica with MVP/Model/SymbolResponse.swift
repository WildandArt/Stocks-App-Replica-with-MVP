//
//  SymbolResponse.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import Foundation

struct SymbolResponse : Codable{
    let count: Int
    let result: [SearchResult]
}
struct SearchResult : Codable{
    let description : String
    let displaySymbol : String
    let symbol : String
    let type : String
}
