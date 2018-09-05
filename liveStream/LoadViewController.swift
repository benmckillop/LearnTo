import UIKit
import MultiPeer

class loadViewController: UIViewController, BambuserPlayerDelegate {
    
    var bambuserPlayer: BambuserPlayer
    var scannedCode:String?
    
    @IBOutlet weak var broadcastOverPrompt: UIImageView!
    @IBOutlet weak var greyedView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var topBox: UIButton!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var screenshotButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func screenshotButton(_ sender: Any) {
        MultiPeer.instance.send(object: "take_screenshot", type: DataType.string.rawValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        MultiPeer.instance.initialize(serviceType: "livestream")
        MultiPeer.instance.autoConnect()
        
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        let broadcastID = UserDefaults.standard.string(forKey: "ID") ?? ""
        let video = broadcastID
        bambuserPlayer.playVideo(video)
    
        greyedView.isHidden = true
        broadcastOverPrompt.isHidden = true
        dismissButton.isHidden = true

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

    func videoLoadFail() {
        playbackFinished()
    }
    
    func playbackStopped() {
        playbackFinished()
    }
    
    func playbackPaused() {
        playbackFinished()
    }
    
    func playbackCompleted(){
        playbackFinished()
    }
    
    func playbackFinished() {
        view.bringSubview(toFront: greyedView)
        view.bringSubview(toFront: broadcastOverPrompt)
        view.bringSubview(toFront: dismissButton)
        
        greyedView.isHidden = true
        broadcastOverPrompt.isHidden = true
        dismissButton.isHidden = true
    }
    

   
    @IBAction func modalDismissButton(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "home")
        self.present(vc, animated: true, completion: nil)
    }



}
