//
//  SourceProtocol.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import Foundation

protocol Source {
    var path : String {get set}
    var endPoint : EndPoint {get set}
    func createUrl() -> URL?
}
extension Source{
     var baseUrl : URL{
        let url = path + endPoint.rawValue
        return URL(string: url)!
    }

}
