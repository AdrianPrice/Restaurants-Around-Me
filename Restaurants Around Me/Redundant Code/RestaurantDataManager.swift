//
//  RestaurantDataManager.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 18/1/21.
//

import Foundation

// 5833c98252ee6ae51f14ba17f79b5b02
// d1753bb21685b078e65456592c49e3a8

class RestaurantDataManager {
    var restaurantData: [RestaurantModel] = [RestaurantModel]()
    var delegate: RestaurantDataDelegate?
    
    typealias DataHandler = (_ data: Data, _ model: LocationModel) -> LocationModel?
    typealias DelegateMethod = (_ model: LocationModel) -> Void
    
    init() { //For an initial search based on location
        //fetchDataByLocation(userLocation: userLocation)
    }
    // This is an attempt to generalize the fetching and decoding of the data, but it didn't end up working :(
//    func fetchData (url: String, dataHandler: @escaping DataHandler, delegateMethod: @escaping DelegateMethod, model: LocationModel) {
//        if let dataLink = URL(string: url) {
//            var request = URLRequest(url: dataLink)
//            request.httpMethod = "POST"
//            request.addValue("5833c98252ee6ae51f14ba17f79b5b02", forHTTPHeaderField: "user-key")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                guard error == nil else { print(error!.localizedDescription); return }
//                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
//
//                if let returnedModel = dataHandler(data, model) {
//                    delegateMethod(returnedModel)
//                } else {
//                    self.delegate?.didFailWithError(error: "Error decoding JSON")
//                }
//            }.resume()
//        } else {
//            self.delegate?.didFailWithError(error: "Invalid URL")
//        }
//    }
    
    //MARK:- Fetching Location Data
    /**
     Get Location Code and Group -> Get Restaurant Codes -> Get Restaurant Details
     */
    func fetchLocationData (userLocation: LocationModel) {
        getLocationCodeAndGroup(userLocation: userLocation)
//        fetchData(url: "https://developers.zomato.com/api/v2.1/locations?query=\(userLocation.cityName)&lat=\(userLocation.latitude)&lon=\(userLocation.longitude)", dataHandler: parseLocationJSON, delegateMethod: self.delegate!.gotLocationData, model: userLocation)
    }
    
    /*
     Example curl api request
     curl -X GET --header "Accept: application/json" --header "user-key: 5833c98252ee6ae51f14ba17f79b5b02 " "https://developers.zomato.com/api/v2.1/locations?query=Ringwood&lat=-37.4718&lon=145.1426"
     */
    func getLocationCodeAndGroup (userLocation: LocationModel) -> Void {
        if let fetchLink = URL(string: "https://developers.zomato.com/api/v2.1/locations?query=\(userLocation.cityName.replacingOccurrences(of: " ", with: "%20"))&lat=\(userLocation.latitude)&lon=\(userLocation.longitude)") {
            var request = URLRequest(url: fetchLink)
            request.httpMethod = "POST"
            request.addValue("d1753bb21685b078e65456592c49e3a8", forHTTPHeaderField: "user-key")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
                if let returnedModel = self.parseLocationJSON(locationData: data, locationModel: userLocation) {
                    self.delegate?.gotLocationData(locationData: returnedModel)
                } else {
                    self.delegate?.didFailWithError(error: "Error decoding JSON")
                }
            }.resume()
        } else {
            self.delegate?.didFailWithError(error: "Invalid URL: https://developers.zomato.com/api/v2.1/locations?query=\(userLocation.cityName)&lat=\(userLocation.latitude)&lon=\(userLocation.longitude)")
        }
    }
    
    func parseLocationJSON (locationData: Data, locationModel: LocationModel) -> LocationModel? {
        let decoder = JSONDecoder()
        var modelToUpdate = locationModel
        
        do {
            let decodedData = try decoder.decode(LocationData.self, from: locationData)
            
            let cityID = decodedData.location_suggestions[0].entity_id
            let type = decodedData.location_suggestions[0].entity_type
            
            modelToUpdate.cityID = String(cityID)
            modelToUpdate.groupType = type
            
            return modelToUpdate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK:- Fetching List of Nearby Restaurant ID's
    func fetchListOfRestaurantIDs(userLocation: LocationModel) {
        getListOfRestaurantIDs(userLocation: userLocation)
    }
    
    func getListOfRestaurantIDs(userLocation: LocationModel) {
        if let fetchLink = URL(string: "https://developers.zomato.com/api/v2.1/location_details?entity_id=\(userLocation.cityID!)&entity_type=\(userLocation.groupType!)") {
            var request = URLRequest(url: fetchLink)
            request.httpMethod = "POST"
            request.addValue("d1753bb21685b078e65456592c49e3a8", forHTTPHeaderField: "user-key")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
                
                if let returnedModel = self.parseRestaurantListJSON(listData: data) {
                    self.delegate?.gotListData(restaurantListData: returnedModel)
                } else {
                    self.delegate?.didFailWithError(error: "Error decoding JSON")
                }
            }.resume()
        } else {
            self.delegate?.didFailWithError(error: "Invalid URL: https://developers.zomato.com/api/v2.1/location_details?entity_id=\(userLocation.cityID!)&entity_type=\(userLocation.groupType!)")
        }
    }
    
    func parseRestaurantListJSON(listData: Data) -> RestaurantListModel? {
        let decoder = JSONDecoder()
        var model = RestaurantListModel(nearbyRestaurants: [String]())
        
        do {
            let decodedData = try decoder.decode(RestaurantListData.self, from: listData)
            
            let restaurantList = decodedData.nearby_res
            
            model.nearbyRestaurants = restaurantList
            
            return model
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK:- Get Restaurant Details
    func fetchRestaurantDetails (restaurantID: String) {
        getRestaurantDetails (restaurantID: restaurantID)
    }
    
    func getRestaurantDetails (restaurantID: String) {
        if let fetchLink = URL(string: "https://developers.zomato.com/api/v2.1/restaurant?res_id=\(restaurantID)") {
            var request = URLRequest(url: fetchLink)
            request.httpMethod = "POST"
            request.addValue("d1753bb21685b078e65456592c49e3a8", forHTTPHeaderField: "user-key")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
                
                if let returnedModel = self.parseRestaurantDetailJSON(listData: data) {
                    self.delegate?.gotDetailData(restaurantDetail: returnedModel)
                } else {
                    self.delegate?.didFailWithError(error: "Error decoding JSON")
                }
            }.resume()
        } else {
            self.delegate?.didFailWithError(error: "Invalid URL: https://developers.zomato.com/api/v2.1/restaurant?res_id=\(restaurantID)")
        }
    }
    
    func parseRestaurantDetailJSON(listData: Data) -> RestaurantModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RestaurantData.self, from: listData)
            
            let locationModel = RestaurantLocation(address: decodedData.location.address, latitude: decodedData.location.latitude, longitude: decodedData.location.longitude)
            
            let imageModel = RestaurantImages(thumbnailURL: decodedData.thumb, featureImageURL: decodedData.featured_image)
            
            let ratingModel = RestaurantRating(rating: decodedData.user_rating.aggregate_rating, votes: decodedData.user_rating.votes)
            
            let model = RestaurantModel(name: decodedData.name, website: decodedData.url, location: locationModel, priceRanking: decodedData.price_range, images: imageModel, menuURL: decodedData.menu_url, ratings: ratingModel)
            
            return model
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
