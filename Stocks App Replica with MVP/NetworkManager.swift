//
//  NetworkManager.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import Foundation

enum NetworkError : String, Error{
    case invalidData
    case decodingError
}
enum EndPoint: String{
    case candleStick = "candle?"
}

struct timesConstants{
    static var hour : Int {60 * 60}
    static var day : Int { 24 * hour }
    static var week : Int {7 * day}
}
class NetworkManager {

    static let token = ["token" : "cdu8amqad3i5v3urh37gcdu8amqad3i5v3urh380"]

    func candleRequest<T : Codable>(with url : URL, completion: @escaping (Result<T, NetworkError>)->()){

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error as? NetworkError {completion(.failure(error))}
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            let decoder =  JSONDecoder()
            do {
                let decoded = try decoder.decode(T.self
                                                 , from: data)
                completion(.success(decoded))
            } catch  {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}







