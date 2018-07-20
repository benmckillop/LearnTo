import UIKit
import CoreFoundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, BambuserViewDelegate {
    
    var bambuserView : BambuserView
    
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var headerImage: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var titleBar: UINavigationBar!
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        bambuserView.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        super.init(coder: aDecoder)
        bambuserView.delegate = self;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.view.addSubview(bambuserView.view)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        broadcastButton.setTitle("Start", for: UIControlState.normal)
        qrButton.setTitle("Dismiss", for: UIControlState.normal)
        self.view.addSubview(broadcastButton)
        
        broadcastButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        broadcastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        broadcastButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        broadcastButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        qrButton.isHidden = true
        view.bringSubview(toFront: headerImage)
        view.bringSubview(toFront: titleBar)
        
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //enables the livestream to start broadcasting
    @objc func broadcast() {
        NSLog("Starting broadcast")
        broadcastButton.setTitle("Connecting", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
        httpGet()
        self.view.addSubview(qrButton)
        self.view.addSubview(qrImage)
        qrImage.isHidden = false
        qrButton.isHidden = false
    }
    
    @IBAction func qrButton(_ sender: Any) {
        qrImage.isHidden = true
        qrButton.isHidden = true
    }

    //changes whilst livestream is active to enable the stop button
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
    }
    
    //uses a get request to get all the broadcasts, json is parced to only show time and id, then is sorted to the latest time
    func httpGet() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer 6z79bmjff25a9n4wb66v3tjso",
            "Accept": "aapplication/vnd.bambuser.v1+json",
            "Content-Type": "application/json"
        ]
     
        Alamofire.request("https://api.irisplatform.io/broadcasts", headers: headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                var test = [Int:String] ()

                for items in (swiftyJsonVar["results"]) {
                    
                    let (_, data) = items
                    test[data["created"].int!] = data["resourceUri"].string!
                }
                
                let (_,resourceUri) = test.sorted(by: <).last!
                print(resourceUri)
                
                let Image = self.generateQRCode(from: resourceUri)
                
                self.qrImage.image = Image
            }
        }
    }
 
    //generates qr code so that the signed url can be scanned by other phone
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    //stops broadcast and sets the button back to normal
    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        qrImage.isHidden = true
        qrButton.isHidden = true
    }
    
    func displayLoadView() {
        let scannerViewController = ScannerViewController()
        present(scannerViewController, animated: true, completion: nil)
    }
}

