

import AVFoundation
import UIKit
import Vision
import PDFKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate  {

    
    /*** VARIABLES ***/
    var previewLayer = AVCaptureVideoPreviewLayer.init()
    var captureSession: AVCaptureSession!
    var previewFrame = CGRect.init()
    var rectangleLayer = CAShapeLayer.init()
    var screenWidth: CGFloat = CGFloat.init()
    var screenHeight: CGFloat = CGFloat.init()
    var statusBarHeight: CGFloat = CGFloat.init()
    
    // SAFE AREA DIMENSION
    var safeAreaFrame: CGRect = CGRect.init()
    var safeHeight: CGFloat = CGFloat.init()
    var safeY: CGFloat = CGFloat.init()
    
    
    
    
     /*** OUTLETS ***/
    @IBOutlet weak var captureBtnOutlet: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...")
        
        let screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        print("screenSize \(screenSize)")
        
        startAVCaptureSession()
    }
 

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("CAMERA DISAPPEAR!!!")
        // STOP AVCapture session
        self.captureSession.stopRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("CAMERA WILL APPEAR")
        
    }
    
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        print("viewSafeAreaInsetsDidChange ...")
        print("self.previewFrame: \(self.previewFrame)")
        
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews ...")
        
        print("view.safeAreaLayoutGuide.layoutFrame: \(view.safeAreaLayoutGuide.layoutFrame)")
        
        // SSAFE AREA FRAME
        if #available(iOS 11.0, *) { // ipohone X
            
            let sAreaFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
            self.safeAreaFrame = sAreaFrame
            print("self.safeAreaFrame: \(self.safeAreaFrame)")
            
            self.safeHeight = sAreaFrame.height
            self.safeY = sAreaFrame.minY
            
            let statusBarFrame = UIApplication.shared.statusBarFrame
            self.statusBarHeight = statusBarFrame.height
            
        }
        
        //self.previewLayer.frame = view.bounds
        self.previewLayer.frame = self.safeAreaFrame
        self.previewFrame = previewLayer.frame
    }
    
    
    
    /*** ACTION ***/
    @IBAction func captureBtn(_ sender: Any) {
    }
    
    
    
    func startAVCaptureSession() {
        print("START CAPTURE SESSION!!")
        
        // Setting Up a Capture Session
        self.captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        // Configure input
        let videoDevice = AVCaptureDevice.default(for: .video)
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput.init(device: videoDevice!) as AVCaptureInput,
            self.captureSession.canAddInput(videoDeviceInput)else {return}
        
        self.captureSession.addInput(videoDeviceInput)
        
        // Capture video output
        let videoOutput = AVCaptureVideoDataOutput.init()
        guard self.captureSession.canAddOutput(videoOutput) else {return}
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.init(label: "videoQueue"))
        self.captureSession.addOutput(videoOutput)
        
        
        // start
        self.captureSession.commitConfiguration()
        self.captureSession.startRunning()
        
        
        // Display camera preview
        self.previewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        
        // Use 'insertSublayer' to enable button to be viewable
        view.layer.insertSublayer(self.previewLayer, at: 0)
        //self.previewLayer.frame = view.bounds
        //self.previewLayer.frame = self.safeAreaFrame
        //self.previewFrame = previewLayer.frame
        
        print("self.previewFrame: \(self.previewFrame)");
        
    }
    
    

    
    
    
    
    
    
    
}

