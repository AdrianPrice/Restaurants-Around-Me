//
//  File.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 18/1/21.
//

import Foundation
import UIKit

class RestaurantListView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .green
        print("HI")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
