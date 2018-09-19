import UIKit
import AVKit
import AVFoundation
import MultiPeer
import AlertOnboarding

class homeViewController: UIViewController, AlertOnboardingDelegate {
    
    @IBOutlet weak var webViewBG: UIWebView!
    var alertView: AlertOnboarding!
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        if launchedBefore  {
//            print("Not first launch.")
//        } else {
//            print("First launch, setting UserDefault.")
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//
//            self.alertView.colorForAlertViewBackground = UIColor.white
//            self.alertView.colorButtonText = UIColor.white
//            self.alertView.colorButtonBottomBackground = UIColor(red: 70/255, green: 181/255, blue: 92/255, alpha: 1.0) /* #46b55c */
//
//            self.alertView.colorTitleLabel = UIColor.black
//            self.alertView.colorDescriptionLabel = UIColor.black
//
//            self.alertView.colorCurrentPageIndicator = UIColor(red: 70/255, green: 181/255, blue: 92/255, alpha: 1.0) /* #46b55c */
//            self.alertView.colorPageIndicator = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0) /* #bebebe */
//
//            self.alertView.percentageRatioHeight = 0.9
//            self.alertView.percentageRatioWidth = 0.9
//
//            self.alertView.titleSkipButton = "SKIP"
//            self.alertView.titleGotItButton = "FINISHED"
//
//            self.alertView.show()
//
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let arrayOfImage = ["OnboardingIcon.png", "Sending.png", "Recieving.png", "Screenshot.png"]
        let arrayOfTitle = ["WELCOME", "STEP 1", "STEP 2", "STEP 3"]
        let arrayOfDescription = ["Thanks for downloading the app! Its a simple app to help with taking group photos. The two phones will connect together to stream live video, and give you an option to take the photo and save it to your camera roll", "Start a new video from your host phone,  this will start to transmit footage.", "Scan the QR code on the host phone, with the peer phone. This will start a live feed between the two devices.", "Once this connection is established, the peer phone can now take a photo of the view seen out of the host phone! This image will be sent back for viewing to the host phone and will be able to be saved or shared from there."]
        
   
            alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
            alertView.delegate = self
            
            if MultiPeer.instance.connectedPeers.count > 1 {
                MultiPeer.instance.disconnect()
            }
        
            let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
            let htmlURL = URL(fileURLWithPath: htmlPath!)
            let html = try? Data(contentsOf: htmlURL)
            self.webViewBG.load(html!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())
            webViewBG.scrollView.isScrollEnabled = false

        }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Onboarding skipped the \(currentStep) step and the max step he saw was the number \(maxStep)")
    }
    
    func alertOnboardingCompleted() {
        print("Onboarding completed!")
    }
    
    func alertOnboardingNext(_ nextStep: Int) {
        print("Next step triggered! \(nextStep)")
    }
    
    


}
