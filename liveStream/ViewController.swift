import UIKit
import CoreFoundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, BambuserViewDelegate {
    var bambuserView : BambuserView
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var headerImage: UIButton!
    
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
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        self.view.addSubview(broadcastButton)
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func broadcast() {
        NSLog("Starting broadcast")
        broadcastButton.setTitle("Connecting", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
        httpGet()
     
    }

    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
    }
    
    func broadcastIdReceived(_ broadcastId: String!) {
        print(broadcastId)
        let BroadcastID = broadcastId
        
        let alert = UIAlertController(title: "Here is your ID!", message: broadcastId, preferredStyle: .alert)
        
//        func generateQRCode() {
//            let qrCode = QRCode(BroadcastID)
//            qrCode?.image
//        }
//
    }
    
    
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
                    //print(data["created"], data["resourceUri"])
//                    let typeA = type(of: data["created"])
//                    print(typeA)
                    
                    test[data["created"].int!] = data["resourceUri"].string!
                
                }
                let (_,v) = test.sorted(by: <).last!
                print(v)
                
            }
        }
    }
            

    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
    }
    
  
    
}

