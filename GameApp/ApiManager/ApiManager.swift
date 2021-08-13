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
    
    var params = ["key": Constant.apiKey]
    
    func fetchListGames(completionHandler: @escaping (GameResult) -> Void) {
        AF.request(Constant.listGamesUrl, method: .get, parameters: params)
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
        AF.request(Constant.listGamesUrl + "/\(gameId)", method: .get, parameters: params)
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
    
    func searchGames(query: String, completionHandler: @escaping (GameResult) -> Void) {
        params["search"] = query
        AF.request(Constant.listGamesUrl, method: .get, parameters: params)
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
    
    func fetchScreenshots(gameId: Int, completionHandler: @escaping (ScreenshotResult) -> Void) {
        AF.request(Constant.listGamesUrl + "/\(gameId)/screenshots", method: .get, parameters: params)
            .responseDecodable(of: ScreenshotResult.self) { response in
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
