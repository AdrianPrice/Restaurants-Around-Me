//
//  LocationFetcher.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol LocationFetcherDelegate: CanHandleErrors {
    func parseLocationData(data: Data, userLocation: LocationModel)
}

class LocationFetcher {
    var delegate: LocationFetcherDelegate?
    
    init () {
        
    }
    
    func fetch (userLocation: LocationModel) {
        if let fetchLink = URL(string: "https://developers.zomato.com/api/v2.1/locations?query=\(userLocation.cityName.replacingOccurrences(of: " ", with: "%20"))&lat=\(userLocation.latitude)&lon=\(userLocation.longitude)") {
            var request = URLRequest(url: fetchLink)
            request.httpMethod = "POST"
            request.addValue("d1753bb21685b078e65456592c49e3a8", forHTTPHeaderField: "user-key")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
                self.delegate?.parseLocationData(data: data, userLocation: userLocation)
            }.resume()
        } else {
            self.delegate?.didFailWithError(error: "Invalid URL: https://developers.zomato.com/api/v2.1/locations?query=\(userLocation.cityName)&lat=\(userLocation.latitude)&lon=\(userLocation.longitude)")
        }
    }
}
