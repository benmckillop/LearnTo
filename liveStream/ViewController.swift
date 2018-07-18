import UIKit
import CoreFoundation

class ViewController: UIViewController, BambuserViewDelegate {
    var bambuserView : BambuserView
//    var broadcastButton : UIButton
    
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var headerImage: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        bambuserView.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        super.init(coder: aDecoder)
        bambuserView.delegate = self;
    }
    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view, typically from a nib.
//        bambuserView.orientation = UIApplication.shared.statusBarOrientation
//        self.view.addSubview(bambuserView.view)
//        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
//        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
//        self.view.addSubview(broadcastButton)
//
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
        
        
//        let image = generateQRCode(from: "test string!")
//        imageView.image = image
     
    }

    
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)

    }
    
    func broadcastIdReceived(_ broadcastId: String!) {
        print(broadcastId)
//        let BroadcastID = broadcastId
//
//        let alert = UIAlertController(title: "Here is your ID!", message: broadcastId, preferredStyle: .alert)
    
    }
    
    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
    }
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    func generateQRCode(from string: String) -> UIImage?{
//        let data = string.data(using: String.Encoding.isoLatin1)
//
//        if let filter = CIFilter(name: "CIQRCodeGenerator") {
//            filter.setValue(data, forKey: "message")
//            let transform = CGAffineTransform(scaleX: 1, y: 1)
//
//            if let output = filter.outputImage?.transformed(by:transform) {
//                return UIImage(ciImage: output)
//            }
//        }
//
//        return nil
//    }
//
//
//    @IBAction func qrButton(_ sender: Any) {
//        let image = generateQRCode(from: "test string!")
//        imageView.image = image
//
//    }
    
    
    
}
