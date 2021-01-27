//
//  WebViewVC.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 21/1/21.
//

import Foundation
import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    var webURL: String?
    var coordinator: MainCoordinator?
    
    let webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.webURL = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateURL(url: String) {
        goToURL(url: url)
    }
    
    override func viewDidLoad() {
        initialiseView()
    }
    
    func initialiseView () {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func goToURL(url: String) {
        let address = URL(string: url)!
        webView.load(URLRequest(url: address))
        webView.allowsBackForwardNavigationGestures = true
    }
}
