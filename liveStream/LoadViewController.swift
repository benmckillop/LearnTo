import UIKit

class loadViewController: UIViewController, BambuserPlayerDelegate {
    var bambuserPlayer: BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        playButton = UIButton(type: UIButtonType.system)
        pauseButton = UIButton(type: UIButtonType.system)
        rewindButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "EE5UFnBB5YbqBXvHFFM4MA"
        var broadcastID: String
        
        
        broadcastID = "dfks"
        
        
        let video = "https://cdn.bambuser.net/broadcasts/" + broadcastID
        bambuserPlayer.playVideo(video)
        self.view.addSubview(bambuserPlayer)
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.addTarget(bambuserPlayer, action: #selector(BambuserPlayer.playVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
        self.view.addSubview(playButton)
        pauseButton.setTitle("Pause", for: UIControlState.normal)
        pauseButton.addTarget(bambuserPlayer, action: #selector(BambuserPlayer.pauseVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
        self.view.addSubview(pauseButton)
        rewindButton.setTitle("Rewind", for: UIControlState.normal)
        rewindButton.addTarget(self, action: #selector(loadViewController.rewind), for: UIControlEvents.touchUpInside)
        self.view.addSubview(rewindButton)
    }
    
    @objc func rewind() {
        bambuserPlayer.seek(to: 0.0);
    }
    
    override func viewWillLayoutSubviews() {
        let statusBarOffset = self.topLayoutGuide.length
        bambuserPlayer.frame = CGRect(x: 0, y: 0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        playButton.frame = CGRect(x: 20, y: 20 + statusBarOffset, width: 100, height: 40)
        pauseButton.frame = CGRect(x: 20, y: 80 + statusBarOffset, width: 100, height: 40)
        rewindButton.frame = CGRect(x: 20, y: 140 + statusBarOffset, width: 100, height: 40)
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
