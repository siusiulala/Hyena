//
//  WebViewController.swift
//  Hyena
//
//  Created by kbala on 2017/7/19.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Html", style: .plain, target: self, action: #selector(htmlTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Url", style: .plain, target: self, action: #selector(urlTapped))
        
        if let url = URL(string: "http://tour.ntpc.gov.tw/zh-tw/"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    func urlTapped(){
        if let url = URL(string: "http://tour.ntpc.gov.tw/zh-tw/"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func htmlTapped(){
        webView.loadHTMLString("<html><body><h1 style=\"color:blue;\">This is a Blue Heading</h1></body></html>", baseURL: nil)
    }


}
