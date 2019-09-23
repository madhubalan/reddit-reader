//
//  DetailsViewController.swift
//  Reddit-reader
//
//  Created by Madhu on 23/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url : URL?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        if let url = self.url{
            self.webView.load(URLRequest(url: url))
        }
        self.activityIndicator.startAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }



}
