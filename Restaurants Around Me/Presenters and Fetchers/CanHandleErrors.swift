//
//  CanHandleErrors.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol CanHandleErrors {
    func didFailWithError(error: String)
    func didFailWithError(error: Error)
}

extension CanHandleErrors {
    func didFailWithError (error: String){
        print(error)
    }
    func didFailWithError (error: Error) {
        print(error)
    }
}
