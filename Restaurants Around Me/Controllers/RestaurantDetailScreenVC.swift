//
//  RestaurantDetailScreenVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation
import UIKit
import WebKit

class RestaurantDetailScreenVC: UIViewController, WKUIDelegate {
    let detailScreen = RestaurantDetailScreenView()
    let webVC = WebViewVC()
    
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
        
        detailScreen.viewMenuButton.addTarget(self, action: #selector(showMenuWebpage), for: .touchUpInside)
    }
    
    func updateScreenValues (restaurantModel: RestaurantModel) {
        detailScreen.updateValues(restaurantModel: restaurantModel)
        print(restaurantModel.menuURL)
        webVC.goToURL(url: restaurantModel.menuURL)
    }
    
    @objc func showMenuWebpage () {
        navigationController?.pushViewController(webVC, animated: true)
    }
}
