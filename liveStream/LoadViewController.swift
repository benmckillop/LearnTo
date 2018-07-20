import UIKit


class loadViewController: UIViewController, BambuserPlayerDelegate {
    var bambuserPlayer: BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton
    var scannedCode:String?
    
    @IBOutlet weak var topBar: UINavigationBar!
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        playButton = UIButton(type: UIButtonType.system)
        pauseButton = UIButton(type: UIButtonType.system)
        rewindButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: topBar)
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
//        var broadcastID: String
//        print(scannedCode!)
        
        
        
        let broadcastID = UserDefaults.standard.string(forKey: "ID") ?? ""
        
  
        
        
        let video = broadcastID
        bambuserPlayer.playVideo(video)
        self.view.addSubview(bambuserPlayer)
    }
    
    @objc func rewind() {
        bambuserPlayer.seek(to: 0.0);
    }
    
    override func viewWillLayoutSubviews() {
        let statusBarOffset = self.topLayoutGuide.length
        bambuserPlayer.frame = CGRect(x: 0, y: 0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playbackStarted() {
        playButton.isEnabled = false
        pauseButton.isEnabled = true
    }
    
    func playbackPaused() {
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func playbackStopped() {
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func videoLoadFail() {
        NSLog("Failed to load video for %@", bambuserPlayer.resourceUri);
    }
}
