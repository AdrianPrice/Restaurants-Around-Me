//
//  RestaurantDetailScreenVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation
import UIKit

class RestaurantDetailScreenVC: UIViewController {
    let detailScreen = RestaurantDetailScreenView()
    
    override func viewDidLoad() {
        view.addSubview(detailScreen)
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .black
        
        detailScreen.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func updateScreenValues (restaurantModel: RestaurantModel) {
        detailScreen.updateValues(restaurantModel: restaurantModel)
    }
}
