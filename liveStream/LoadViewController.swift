import UIKit
import MultiPeer

class loadViewController: UIViewController, BambuserPlayerDelegate {
    
    var bambuserPlayer: BambuserPlayer
    var scannedCode:String?
    
    @IBOutlet weak var bluredView: UIVisualEffectView!
    @IBOutlet weak var broadcastOverPrompt: UIImageView!
    @IBOutlet weak var greyedView: UIImageView!
    @IBOutlet weak var topBox: UIButton!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var screenshotButton: UIButton!
    @IBOutlet weak var takeMeHomeButton: UIButton!
    @IBOutlet weak var imageSavedImagePrompt: UIImageView!
    @IBOutlet weak var dismissImageSavedPrompt: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func screenshotButton(_ sender: Any) {

        MultiPeer.instance.send(object: "take_screenshot", type: DataType.string.rawValue)
        
        view.bringSubview(toFront: greyedView)
        view.bringSubview(toFront: bluredView)
        greyedView.isHidden = false
        bluredView.isHidden = false
        view.bringSubview(toFront: dismissImageSavedPrompt)
        view.bringSubview(toFront: imageSavedImagePrompt)
        imageSavedImagePrompt.isHidden = false
        dismissImageSavedPrompt.isHidden = false

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MultiPeer.instance.disconnect()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MultiPeer.instance.initialize(serviceType: "livestream")
        MultiPeer.instance.autoConnect()
        MultiPeer.instance.debugMode = true

        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        let broadcastID = UserDefaults.standard.string(forKey: "ID") ?? ""
        let video = broadcastID
        bambuserPlayer.playVideo(video)
        
        bluredView.isHidden = true
        greyedView.isHidden = true
        broadcastOverPrompt.isHidden = true
        takeMeHomeButton.isHidden = true
        imageSavedImagePrompt.isHidden = true
        dismissImageSavedPrompt.isHidden = true
        
        self.view.addSubview(bambuserPlayer)
        
        view.bringSubview(toFront: topBox)
        view.bringSubview(toFront: topBar)
        view.bringSubview(toFront: screenshotButton)
        
        screenshotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        screenshotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenshotButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        screenshotButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        let statusBarOffset = self.topLayoutGuide.length
        bambuserPlayer.frame = CGRect(x: 0, y: 0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playbackStopped() {
        playbackFinished()
    }
    
    func playbackCompleted(){
        playbackFinished()
    }
    
    func playbackFinished() {
        view.bringSubview(toFront: greyedView)
        view.bringSubview(toFront: bluredView)
        view.bringSubview(toFront: broadcastOverPrompt)
        view.bringSubview(toFront: takeMeHomeButton)
        
        greyedView.isHidden = false
        bluredView.isHidden = false
        broadcastOverPrompt.isHidden = false
        takeMeHomeButton.isHidden = false
    }
    
    @IBAction func dismissImageSavedPrompt(_ sender: Any) {
        imageSavedImagePrompt.isHidden = true
        dismissImageSavedPrompt.isHidden = true
        greyedView.isHidden = true
        bluredView.isHidden = true
    }
    
    @IBAction func takeMeHomeButton(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "home")
        self.present(vc, animated: true, completion: nil)
    }
}


extension loadViewController: MultiPeerDelegate {
    
    func multiPeer(didReceiveData data: Data, ofType type: UInt32) {
        switch type {
        case DataType.string.rawValue:
            _ = data.convert() as! String
            // do something with the received String

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
