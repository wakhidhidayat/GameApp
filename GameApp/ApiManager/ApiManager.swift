//
//  ApiManager.swift
//  GameApp
//
//  Created by Wahid Hidayat on 04/08/21.
//

import Foundation
import Alamofire

class ApiManager {
    static let sharedInstance = ApiManager()
    
    let params = ["key": apiKey]
    
    func fetchListGames(completionHandler: @escaping (GameResult) -> Void) {
        AF.request(listGamesUrl, method: .get, parameters: params)
            .responseDecodable(of: GameResult.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
        }
    }
    
    func fetchDetailGame(gameId: Int, completionHandler: @escaping (DetailGame) -> Void) {
        AF.request(listGamesUrl + "/\(gameId)", method: .get, parameters: params)
            .responseDecodable(of: DetailGame.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
    }
}
