//
//  homeViewController.swift
//  liveStream
//
//  Created by Ben McKillop on 03/08/2018.
//  Copyright © 2018 Ben McKillop. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation

class homeViewController: UIViewController {
    
    
    @IBOutlet weak var webViewBG: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
        let htmlURL = URL(fileURLWithPath: htmlPath!)
        let html = try? Data(contentsOf: htmlURL)
        
        self.webViewBG.load(html!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())
        
        webViewBG.scrollView.isScrollEnabled = false

        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
