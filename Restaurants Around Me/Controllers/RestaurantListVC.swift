//
//  RestaurantListVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 17/1/21.
//

import Foundation
import UIKit
import CoreLocation

class RestaurantListVC: UITableViewController {
    var nav = false
    var userLocationData = LocationModel(latitude: "-37.4718", longitude: "145.1426", cityName: "Ringwood") //This will eventually be fetched
    
    let locationManager = CLLocationManager()
    
    /*
     SAMPLE DATA
    -37.4718    145.1426    Ringwood
     -37.907803 145.133957  Clayton
     */
    let dataManager = RestaurantDataManager()
    
    let restaurantList: RestaurantListView = {
        let view = RestaurantListView()
        return view
    }()
    
    var restaurantDetails: [RestaurantModel] = [RestaurantModel]()
    
    override func loadView() {
        super.loadView()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        
        dataManager.delegate = self
        
        
        tableView.register (RestaurantCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(restaurantList)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! RestaurantCell
        cell.label.text = restaurantDetails[indexPath.row].name
        if let url = URL(string: restaurantDetails[indexPath.row].images.thumbnail) {
            cell.pictureView.load(url: url)
        }
        cell.updateRatingStarts(rating: restaurantDetails[indexPath.row].ratings.ratingDouble)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptionVC = RestaurantDetailScreenVC()
        descriptionVC.updateScreenValues(restaurantModel: restaurantDetails[indexPath.row])
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if nav {
            navigationController?.setNavigationBarHidden(true, animated: false)
            nav.toggle()
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
            nav.toggle()
        }
    }
}

extension RestaurantListVC: RestaurantDataDelegate {
    func gotDetailData(restaurantDetail: RestaurantModel) {
        
        restaurantDetails.append(restaurantDetail)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func gotListData(restaurantListData: RestaurantListModel) {
//        print(restaurantListData.nearbyRestaurants)
        
        for id in restaurantListData.nearbyRestaurants {
            dataManager.fetchRestaurantDetails(restaurantID: id)
        }
        
    }
    
    func gotLocationData(locationData: LocationModel) {
//        print(locationData.cityID)
//        print(locationData.groupType)
        
        dataManager.fetchListOfRestaurantIDs(userLocation: locationData)
    }
}

extension RestaurantListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let geoCoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, _) -> Void in

            placemarks?.forEach { (placemark) in

                if let city = placemark.locality {
                    self.userLocationData = LocationModel(latitude: String(locValue.latitude), longitude: String(locValue.longitude), cityName: city)
                    self.dataManager.fetchLocationData(userLocation: self.userLocationData)
                } else {
                    print("No address found")
                    self.dataManager.fetchLocationData(userLocation: self.userLocationData)
                }
                
            }
        })
        
        
        
        
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
