//
//  MainCoordinator.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 22/1/21.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    var subCoordinator: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: CoordinatorProtocol {
    var subCoordinator: [CoordinatorProtocol]
    
    var navigationController: UINavigationController
    
    func start() {
        let launchVC = LaunchScreenVC()
        launchVC.coordinator = self
        navigationController.pushViewController(launchVC, animated: true)
    }
    
    init (navController: UINavigationController) {
        self.subCoordinator = [CoordinatorProtocol]()
        self.navigationController = navController
        
        start()
    }
    
    func goToListView() {
        let listVC = RestaurantListVC()
        listVC.coordinator = self
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func goToDetailScreen(restaurantModel: RestaurantModel) {
        let descriptionVC = RestaurantDetailScreenVC()
        descriptionVC.coordinator = self
        descriptionVC.updateScreenValues(restaurantModel: restaurantModel)
        navigationController.pushViewController(descriptionVC, animated: true)
    }
    
    func goToWebView(url: String) {
        let webVC = WebViewVC()
        webVC.coordinator = self
        webVC.updateURL(url: url)
        navigationController.pushViewController(webVC, animated: true)
    }
    
    
}
