import UIKit


class loadViewController: UIViewController, BambuserPlayerDelegate {
    var bambuserPlayer: BambuserPlayer
    var scannedCode:String?
    
    @IBOutlet weak var broadcastover: UIImageView!
    @IBOutlet weak var topBox: UIButton!
    @IBOutlet weak var topBar: UINavigationBar!
    
    @IBOutlet weak var screenshotButton: UIButton!
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        super.init(coder: aDecoder)
    }
    
    
//    @IBAction func screenshotButton(_ sender: Any) {
//        captureScreenshot()
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        let broadcastID = UserDefaults.standard.string(forKey: "ID") ?? ""
        let video = broadcastID
        bambuserPlayer.playVideo(video)
        self.view.addSubview(bambuserPlayer)
        
        view.bringSubview(toFront: topBox)
        view.bringSubview(toFront: topBar)
        view.bringSubview(toFront: screenshotButton)
        broadcastover.isHidden = true
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
        NSLog("Failed to load video for %@", bambuserPlayer.resourceUri);
    }
    

    
    func playbackCompleted() {
        view.bringSubview(toFront: broadcastover)
        broadcastover.isHidden = false
        
    }


}
