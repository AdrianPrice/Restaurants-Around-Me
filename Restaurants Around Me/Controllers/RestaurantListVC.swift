//
//  RestaurantListVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 17/1/21.
//

import Foundation
import UIKit
import CoreLocation

class RestaurantListVC: UIViewController {
    var coordinator: MainCoordinator?
    var tableController: TableVC?
    
    var restaurantList: RestaurantListView = {
        let view = RestaurantListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(RestaurantCell.self, forCellReuseIdentifier: "cellID")
        return view
    }()
    
    var nav = false
    var userLocationData = LocationModel(latitude: "-37.4718", longitude: "145.1426", cityName: "Ringwood") //This will eventually be fetched
    
    let locationManager = CLLocationManager()
    
    let locationPresenter = LocationPresenter()
    let listPresenter = RestaurantListPresenter()
    let detailsPresenter = RestaurantDetailsPresenter()
    
    /*
     SAMPLE DATA
    -37.4718    145.1426    Ringwood
     -37.907803 145.133957  Clayton
     */
    
    var restaurantDetails: [RestaurantModel] = [RestaurantModel]()
    
    override func loadView() {
        super.loadView()
        
        locationPresenter.delegate = self
        listPresenter.delegate = self
        detailsPresenter.delegate = self
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(restaurantList)
        restaurantList.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        tableController = TableVC(tableView: restaurantList, data: restaurantDetails)
        tableController?.coordinator = self.coordinator
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

extension RestaurantListVC: LocationPresenterDelegate {
    func gotLocationData(locationData: LocationModel) {
        listPresenter.fetch(userLocation: locationData)
    }
}

extension RestaurantListVC: RestaurantListPresenterDelegate {
    func gotListData(listData: RestaurantListModel) {
        for id in listData.nearbyRestaurants {
            detailsPresenter.fetch(restaurantID: id)
        }
    }
}

extension RestaurantListVC: RestaurantDetailsPresenterDelegate {
    func gotDetailsData(restaurantDetails: RestaurantModel) {
        self.restaurantDetails.append(restaurantDetails)
        tableController?.updateTableView(restaurantDetails: self.restaurantDetails)
    }
}

extension RestaurantListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let geoCoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, _) -> Void in

            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    self.userLocationData = LocationModel(latitude: String(locValue.latitude), longitude: String(locValue.longitude), cityName: city)
                    self.restaurantDetails = []
                    self.locationPresenter.fetch(userLocation: self.userLocationData)
                } else {
                    print("No address found")
                    self.restaurantDetails = []
                    self.locationPresenter.fetch(userLocation: self.userLocationData)
                }
                
            }
        })
        
        locationManager.stopUpdatingLocation()
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
