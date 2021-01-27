//
//  LocationPresenter.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol LocationPresenterDelegate: CanHandleErrors {
    func gotLocationData(locationData: LocationModel)
}

class LocationPresenter: LocationFetcherDelegate {
    
    var delegate: LocationPresenterDelegate?
    
    let fetcher = LocationFetcher()
    
    init() {
        self.fetcher.delegate = self
    }
    
    func parseLocationData (data: Data, userLocation: LocationModel) {
            let decoder = JSONDecoder()
            var modelToUpdate = userLocation
            
            do {
                let decodedData = try decoder.decode(LocationData.self, from: data)
                
                let cityID = decodedData.location_suggestions[0].entity_id
                let type = decodedData.location_suggestions[0].entity_type
                
                modelToUpdate.cityID = String(cityID)
                modelToUpdate.groupType = type
                
                self.delegate?.gotLocationData(locationData: modelToUpdate)
                
            } catch {
                delegate?.didFailWithError(error: error)
            }
    }
    
    func fetch (userLocation: LocationModel) {
        fetcher.fetch(userLocation: userLocation)
    }
    
}
