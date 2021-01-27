//
//  RestaurantDetailsFetcher.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol RestaurantDetailsFetcherDelegate: CanHandleErrors {
    func parseDetailData(data: Data)
}

class RestaurantDetailsFetcher {
    var delegate: RestaurantDetailsFetcherDelegate?
    
    func fetch (restaurantID: String) {
        if let fetchLink = URL(string: "https://developers.zomato.com/api/v2.1/restaurant?res_id=\(restaurantID)") {
            var request = URLRequest(url: fetchLink)
            request.httpMethod = "POST"
            request.addValue("d1753bb21685b078e65456592c49e3a8", forHTTPHeaderField: "user-key")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
                
                self.delegate?.parseDetailData(data: data)
            }.resume()
        } else {
            self.delegate?.didFailWithError(error: "Invalid URL: https://developers.zomato.com/api/v2.1/restaurant?res_id=\(restaurantID)")
        }
    }
}
