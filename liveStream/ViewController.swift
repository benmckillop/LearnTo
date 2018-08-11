import UIKit
import CoreFoundation
import Alamofire
import SwiftyJSON
import AVFoundation

class ViewController: UIViewController, BambuserViewDelegate {
    
    var bambuserView : BambuserView
    
    @IBOutlet weak var photoTaken: UIImageView!
    @IBOutlet weak var greyBG: UIImageView!
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var qrCodeShowButton: UIButton!
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var headerImage: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var snapshotView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        bambuserView.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        super.init(coder: aDecoder)
        bambuserView.delegate = self
    }
    
    @IBAction func qrCodeShow(_ sender: Any) {
        showQRCode()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(takePhoto)
        self.view.addSubview(greyBG)
        qrCodeShowButton.isHidden = true
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
        takePhoto.isHidden = true
        self.qrImage.isHidden = false
        view.bringSubview(toFront: headerImage)
        view.bringSubview(toFront: titleBar)
        view.bringSubview(toFront: takePhoto)
        self.qrImage.image = #imageLiteral(resourceName: "loadingt.png")
        greyBG.isHidden = true
        photoTaken.isHidden = true
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
        self.view.addSubview(qrImage)
        self.view.addSubview(qrButton)
        greyBG.isHidden = true
    }
    
    //when the broadcast id is recieved, it is used to get the signed url, then to show the qr code
    func broadcastIdReceived(_ broadcastId: String!) {
        print(broadcastId)
        UserDefaults.standard.set(broadcastId, forKey: "broadcastID")
        httpGet()
        sleep(2)
        showQRCode()
    }
    
    @IBAction func qrButton(_ sender: Any) {
        qrImage.isHidden = true
        qrButton.isHidden = true
        takePhoto.isHidden = false
        greyBG.isHidden = true
    }

    //changes whilst livestream is active to enable the stop button
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        self.qrImage.isHidden = false
        qrCodeShowButton.isHidden = false
//        takePhoto.isHidden = false
        broadcastButton.setBackgroundImage(#imageLiteral(resourceName: "Red Bottom Bar.png"), for: UIControlState.normal)
//        self.view.addSubview(takePhoto)
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
    
    //displays the qr code and button at the same time once the qr code loads
    func showQRCode() {
        view.bringSubview(toFront: greyBG)
        view.bringSubview(toFront: qrImage)
        view.bringSubview(toFront: qrButton)
        greyBG.isHidden = false
        qrImage.isHidden = false
        qrButton.isHidden = false
        takePhoto.isHidden = true
        
    }

    //uses a get request to get all the broadcasts, json is parced to only show time and id, then is sorted to the latest time
    func httpGet() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer 6z79bmjff25a9n4wb66v3tjso",
            "Accept": "aapplication/vnd.bambuser.v1+json",
            "Content-Type": "application/json"
        ]
        let broadcastIDSaved = UserDefaults.standard.string(forKey: "broadcastID") ?? ""
        let broadcastURL = "https://api.irisplatform.io/broadcasts/" + broadcastIDSaved
                Alamofire.request(broadcastURL, headers: headers).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let json = JSON(responseData.result.value!)
                        if let URI = json["resourceUri"].string {
                            print(URI)
                            UserDefaults.standard.set(URI, forKey: "resourceURI")
                        }
                        let resourceURI = UserDefaults.standard.string(forKey: "resourceURI") ?? ""
                        let Image = self.generateQRCode(from: resourceURI)
                        self.qrImage.image = Image
                        self.qrImage.isHidden = false
            }
        }
    }
 
    //stops broadcast and sets the button back to normal
    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        qrImage.isHidden = true
        qrButton.isHidden = true
        qrCodeShowButton.isHidden = true
        takePhoto.isHidden = true
        self.qrImage.image = #imageLiteral(resourceName: "loadingt.png")
        broadcastButton.setBackgroundImage(#imageLiteral(resourceName: "Bottom bar no text.png"), for: UIControlState.normal)
    }

   
    @IBAction func takePhoto(_ sender: Any) {
        takeSnapshot()
//        view.bringSubview(toFront: greyBG)
//        self.view.addSubview(photoTaken)
//        view.bringSubview(toFront: photoTaken)
//        greyBG.isHidden = false
//        photoTaken.isHidden = false
//        sleep(1)
//        greyBG.isHidden = true
//        photoTaken.isHidden = true
    }
    func takeSnapshot() {
        bambuserView.takeSnapshot()
    }
    
    func snapshotTaken(_ imageView: UIImage!) {
        print("snapshot taken")
        UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);

    }
    
    func displayLoadView() {
        let scannerViewController = ScannerViewController()
        present(scannerViewController, animated: true, completion: nil)
    }
}
