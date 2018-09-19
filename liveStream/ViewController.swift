import UIKit
import CoreFoundation
import Alamofire
import SwiftyJSON
import AVFoundation
import MultiPeer
import NVActivityIndicatorView

enum DataType: UInt32 {
    case string = 1
    case image = 2
}

class ViewController: UIViewController, BambuserViewDelegate, NVActivityIndicatorViewable{
    
    var bambuserView : BambuserView
    var activityIndicator : NVActivityIndicatorView!

    @IBOutlet weak var whiteSquare: UIImageView!
    @IBOutlet weak var bluredView: UIVisualEffectView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var dismissImageSaved: UIButton!
    @IBOutlet weak var imageSavedPrompt: UIImageView!
    @IBOutlet weak var photoTakenTopBar: UIButton!
    @IBOutlet weak var saveScreenshotButton: UIButton!
    @IBOutlet weak var dismissScreenshotButton: UIButton!
    @IBOutlet weak var greyedView: UIImageView!
    @IBOutlet weak var takenImageView: UIImageView!
    @IBOutlet weak var photoTaken: UIImageView!
    @IBOutlet weak var greyBG: UIImageView!
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
    
    override func viewWillDisappear(_ animated: Bool) {
        broadcastStopped()
        super.viewWillDisappear(animated)
    }
    
//    @IBAction func shareScreenshotButton(_ sender: Any) {
//        let activityVC = UIActivityViewController(activityItems: [takenImageView], applicationActivities: [])
//        present(activityVC, animated: true)
//        
//        activityVC.excludedActivityTypes = [
//            UIActivityType.assignToContact,
//            UIActivityType.print,
//            UIActivityType.addToReadingList,
//            UIActivityType.saveToCameraRoll,
//            UIActivityType.openInIBooks,
//            UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
//            UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
//        ]
//    }
    
    @IBAction func qrCodeShow(_ sender: Any) {
        showQRCode()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        MultiPeer.instance.delegate = self
        MultiPeer.instance.initialize(serviceType: "livestream")
        MultiPeer.instance.autoConnect()
        MultiPeer.instance.debugMode = true
        imageSavedPrompt.isHidden = true
        takenImageView.isHidden = true
        qrCodeShowButton.isHidden = true
        whiteSquare.isHidden = true
        greyedView.isHidden = true
        bluredView.isHidden = true
        dismissScreenshotButton.isHidden = true
        saveScreenshotButton.isHidden = true
        photoTakenTopBar.isHidden = true
        dismissImageSaved.isHidden = true
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
        qrImage.isHidden = true
        view.bringSubview(toFront: headerImage)
        view.bringSubview(toFront: titleBar)
        exitButton.isHidden = true

    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MultiPeer.instance.disconnect()
    }
    
    //enables the livestream to start broadcasting
    @objc func broadcast() {
        loadingAnimator()
        NSLog("Starting broadcast")
        broadcastButton.setTitle("Connecting", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
        self.view.addSubview(qrImage)
        self.view.addSubview(qrButton)
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
        greyedView.isHidden = true
        bluredView.isHidden = true
        whiteSquare.isHidden = true
    }

    //changes whilst livestream is active to enable the stop button
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        self.qrImage.isHidden = false
        qrCodeShowButton.isHidden = false
        broadcastButton.setBackgroundImage(#imageLiteral(resourceName: "RedBottomBar.png"), for: UIControlState.normal)
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
        hidingAnimator()
        greyedView.isHidden = false
        bluredView.isHidden = false
        whiteSquare.isHidden = false
        qrImage.isHidden = false
        qrButton.isHidden = false

        view.bringSubview(toFront: greyedView)
        view.bringSubview(toFront: bluredView)
        view.bringSubview(toFront: whiteSquare)
        view.bringSubview(toFront: qrButton)
        view.bringSubview(toFront: qrImage)
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
                        MultiPeer.instance.send(object: resourceURI, type: DataType.string.rawValue)
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
//        self.qrImage.image = #imageLiteral(resourceName: "PleaseWaitScreen.png")
        qrImage.image = nil
        broadcastButton.setBackgroundImage(#imageLiteral(resourceName: "BottomBarNoTextTest.png"), for: UIControlState.normal)
    }
   
    @IBAction func takePhoto(_ sender: Any) {
        takeSnapshot()
    }
    
    func takeSnapshot() {
        bambuserView.takeSnapshot()
    }
    
    func snapshotTaken(_ imageView: UIImage!) {
        print("snapshot taken")
        greyedView.isHidden = false
        bluredView.isHidden = false
        view.bringSubview(toFront: greyedView)
        view.bringSubview(toFront: bluredView)
        takenImageView.image = imageView
        takenImageView.isHidden = false
        view.bringSubview(toFront: takenImageView)
        dismissScreenshotButton.addTarget(self, action: #selector(ViewController.dismissImage), for: UIControlEvents.touchUpInside)
        dismissScreenshotButton.isHidden = false
        view.bringSubview(toFront: dismissScreenshotButton)
        saveScreenshotButton.addTarget(self, action: #selector(ViewController.saveImage), for: UIControlEvents.touchUpInside)
        saveScreenshotButton.isHidden = false
        view.bringSubview(toFront: saveScreenshotButton)
        photoTakenTopBar.isHidden = false
        view.bringSubview(toFront: photoTakenTopBar)
        exitButton.isHidden = false
        view.bringSubview(toFront: exitButton)
        MultiPeer.instance.send(object: imageView, type: DataType.image.rawValue)
        exitButton.addTarget(self, action: #selector(ViewController.exitImage), for: UIControlEvents.touchUpInside)
        MultiPeer.instance.send(object: "snapshot_taken", type: DataType.string.rawValue)

    }
    
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(takenImageView.image!, nil, nil, nil);
        takenImageView.isHidden = true
        dismissScreenshotButton.isHidden = true
        saveScreenshotButton.isHidden = true
        photoTakenTopBar.isHidden = true
        exitButton.isHidden = true
        view.bringSubview(toFront: imageSavedPrompt)
        imageSavedPrompt.isHidden = false
        view.bringSubview(toFront: dismissImageSaved)
        dismissImageSaved.isHidden = false
    }
    
    //share
    @IBAction func dismissButton(_ sender: Any) {
        imageSavedPrompt.isHidden = true
        greyedView.isHidden = true
        bluredView.isHidden = true
        dismissImageSaved.isHidden = true
        photoTakenTopBar.isHidden = true
    }
    
    @IBAction func exitImage() {
        imageSavedPrompt.isHidden = true
        greyedView.isHidden = true
        bluredView.isHidden = true
        dismissImageSaved.isHidden = true
        photoTakenTopBar.isHidden = true
        exitButton.isHidden = true
        saveScreenshotButton.isHidden = true
        takenImageView.isHidden = true
        dismissScreenshotButton.isHidden = true
    }
    
    @objc func dismissImage() {
        let vc = UIActivityViewController(activityItems: [takenImageView], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func displayLoadView() {
        let scannerViewController = ScannerViewController()
        present(scannerViewController, animated: true, completion: nil)
    }
    
    func loadingAnimator() {
        greyedView.isHidden = false
        bluredView.isHidden = false
        view.bringSubview(toFront: greyedView)
        view.bringSubview(toFront: bluredView)
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        let frame = CGRect(x: (xAxis - 27.5 ), y: (yAxis - 27.5), width: 55, height: 55)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = . circleStrokeSpin
        activityIndicator.color = UIColor.white
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hidingAnimator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

extension ViewController: MultiPeerDelegate {
    
    func multiPeer(didReceiveData data: Data, ofType type: UInt32) {
        switch type {
        case DataType.string.rawValue:
            let string = data.convert() as! String
            if string == "take_screenshot" {
                print("screenshot taken")
                takeSnapshot()
            }
            break;
            
        case DataType.image.rawValue:
            _ = UIImage(data: data)
            // do something with the received UIImage
            break;
            
        default:
            break;
        }
    }
    
    func multiPeer(connectedDevicesChanged devices: [String]) {
    }
}
