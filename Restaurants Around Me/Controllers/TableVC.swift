//
//  TableVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 22/1/21.
//

import Foundation
import UIKit

class TableVC: NSObject, UITableViewDataSource, UITableViewDelegate {
    var restaurantDetails: [RestaurantModel]
    var coordinator: MainCoordinator?
    
    var view: RestaurantListView
    
    init(tableView: RestaurantListView, data: [RestaurantModel]) {
        
        self.restaurantDetails = data
        self.view = tableView
        super.init()
        self.view.dataSource = self
        self.view.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! RestaurantCell
        cell.label.text = restaurantDetails[indexPath.row].name
        if let url = URL(string: restaurantDetails[indexPath.row].images.thumbnail) {
            cell.pictureView.load(url: url)
        }
        cell.updateRatingStarts(rating: restaurantDetails[indexPath.row].ratings.ratingDouble)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.goToDetailScreen(restaurantModel: restaurantDetails[indexPath.row])
    }
    
    func updateTableView(restaurantDetails: [RestaurantModel]) {
        self.restaurantDetails = restaurantDetails
        
        DispatchQueue.main.async {
            self.view.reloadData()
        }
    }
}
