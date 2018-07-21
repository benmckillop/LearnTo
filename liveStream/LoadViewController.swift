import UIKit


class loadViewController: UIViewController, BambuserPlayerDelegate {
    var bambuserPlayer: BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton
    var scannedCode:String?
    
    @IBOutlet weak var screenshotButton: UIButton!
    @IBOutlet weak var topBox: UIButton!
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
        let broadcastID = UserDefaults.standard.string(forKey: "ID") ?? ""
        let video = broadcastID
        bambuserPlayer.playVideo(video)
        self.view.addSubview(bambuserPlayer)
        view.bringSubview(toFront: topBox)
        view.bringSubview(toFront: topBar)
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
    
//    @objc func screenShotMethod() {
//        //Create the UIImage
//        UIGraphicsBeginImageContext(bambuserPlayer.frame.size)
//        bambuserPlayer.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        //Save it to the camera roll
//        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//    }

}
