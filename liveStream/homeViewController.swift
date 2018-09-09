import UIKit
import AVKit
import AVFoundation
import MultiPeer

class homeViewController: UIViewController {
    
    @IBOutlet weak var webViewBG: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MultiPeer.instance.disconnect()
        
        let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
        let htmlURL = URL(fileURLWithPath: htmlPath!)
        let html = try? Data(contentsOf: htmlURL)
        self.webViewBG.load(html!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())
        webViewBG.scrollView.isScrollEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
