//
//  LaunchScreenVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 17/1/21.
//

import Foundation
import UIKit

class LaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let launchView = LaunchScreenView()
        launchView.startButton.addTarget(self, action: #selector(changeScreen), for: .touchUpInside)
        view.addSubview(launchView)
        launchView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    @objc func changeScreen () {
        let listVC = RestaurantListVC()
        
        navigationController?.pushViewController(listVC, animated: true)
    }
}
