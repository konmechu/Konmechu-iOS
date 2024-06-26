//
//  SmartlensViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import AVFoundation
import Switches

class SmartlensViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession!
    
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var videoOutput: AVCaptureVideoDataOutput!
    
    var isTakePicture = false
    var isBackCameraOn = true
    
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageBtn: UIButton!
    
    @IBOutlet weak var selectImgFromAlbum: UIButton!
    let imagePickerController = UIImagePickerController()
    
    
    @IBOutlet weak var captureTypeLabel: UILabel!
        
    @IBOutlet weak var textButton: UIButton!
    
    @IBOutlet weak var switchCaptureTypeBaseView: UIView!
    
    @IBOutlet weak var switchCaptureTypeBtn: UIView!
    
    @IBOutlet weak var switchBtn: CustomSegmentedControl!
    
    
    @IBOutlet weak var mealNameTextField: UITextField!
    
    @IBOutlet weak var textMainView: UIView!
    
    @IBOutlet weak var dismissTextMainViewBtn: UIButton!
    
    @IBOutlet weak var calculateNutritionByTextBtn: UIButton!
    
    //let capturedImageView = CapturedImageView()
    var imgToSend :UIImage?
    var captureType :CaptureType? = .FOODIMG
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.hideKeyboardWhenTappedAround()
        
        setupView()
    
        imagePickerController.delegate = self
        
        switchBtn.addTarget(self, action: #selector(captureTypeViewChanged), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartCaptureSession), name: NSNotification.Name("DidDismissCaptureImgViewController"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        setupAndStartCaptureSession()
    }
    
    //MARK: - UI setup
    func setupView() {
        
        switchCaptureTypeBaseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        switchCaptureTypeBaseView.layer.shadowOpacity = 0.8
        switchCaptureTypeBaseView.layer.cornerRadius = switchCaptureTypeBaseView.frame.height/2
        
            
        textButton.setTitle("음식이름 직접 입력하기", for: .normal)
        
        captureTypeLabel.font = .boldSystemFont(ofSize: 18)
        captureImageBtn.layer.cornerRadius = captureImageBtn.frame.width / 2
        captureImageBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        captureImageBtn.layer.shadowOpacity = 0.8
        previewView.layer.cornerRadius = 35
        previewView.clipsToBounds = true
        
        selectImgFromAlbum.layer.cornerRadius = 10
        selectImgFromAlbum.layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        textButton.addTarget(self, action: #selector(activateTextField), for: .touchUpInside)
    }

    
    //MARK: - Camera Setup
    func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            //세션 초기화
            captureSession = AVCaptureSession()
            //구성 시작
            captureSession.beginConfiguration()
            
            //session specific configuration
            //세션 프리셋 설정 전, 지원여부를 확인
            if captureSession.canSetSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }
            
            //세션이 자동으로 광역 색상을 사용 할지 여부를 지정
            captureSession.automaticallyConfiguresCaptureDeviceForWideColor =  true
            
            //setup inputs
            setupInputs()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            setupOutput()
            
            self.captureSession.commitConfiguration()
            
            captureSession.startRunning()
        }
    }
    
    func setupInputs() {
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            self.backCamera = backCamera
            self.frontCamera = frontCamera
        } else {
            fatalError("No cameras. ")
        }
        
        guard let backInput = try? AVCaptureDeviceInput(device: self.backCamera) else {
            fatalError("Could not create input device from back camera")
        }
        
        self.backInput = backInput
        if !captureSession.canAddInput(self.backInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        guard let frontInput = try? AVCaptureDeviceInput(device: self.frontCamera) else {
            fatalError("could not create input device from front camera")
        }
        
        self.frontInput = frontInput
        if !captureSession.canAddInput(self.frontInput) {
            fatalError("could not add front camera input to capture session")
        }
        
        captureSession.addInput(backInput)
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewView.layer.addSublayer(previewLayer)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.previewView.bounds
    }
    
    func setupOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        //방향을 세로로 설정
        videoOutput.connections.first?.videoOrientation = .portrait
        
    }
    
    func switchCameraInput() {
        // 스위치되는 동안 사용자가 버튼을 스팸처럼 연타하지 못하도록 합니다.
        //switchCameraButton.isUserInteractionEnabled = false

        //input 재설정
        captureSession.beginConfiguration()
        
        if isBackCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            isBackCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            isBackCameraOn = true
        }
        
        //다시 방향을 세로로 설정
        videoOutput.connections.first?.videoOrientation = .portrait
        
        //전면 카메라 비디오 스트림 미러링
        videoOutput.connections.first?.isVideoMirrored = !isBackCameraOn
        
        //commit config
        captureSession.commitConfiguration()
        
        //다시 카메라 버튼을 활성화
        //switchCameraButton.isUserInteractionEnabled = true

    }
    
    func startCaptureSession() {
        guard let captureSession = self.captureSession, !captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }

    func stopCaptureSession() {
        guard let captureSession = self.captureSession, captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.stopRunning()
        }
    }
    
    @objc func restartCaptureSession() {
        startCaptureSession()
    }
    
    //MARK: - Button Actions
    
    @IBAction func captureImageBtnDidTap(_ sender: Any) {
        isTakePicture = true
    }
    
    
    @IBAction func selectImgFromAlbumBtnDidTap(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
        stopCaptureSession()
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func infoBtnDidTap(_ sender: Any) {
    }
    
    
    @IBAction func textBtnDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.textMainView.alpha = 0.8
        })

        textMainView.isHidden = false
        stopCaptureSession()
    }
    
    
    @IBAction func calculateNutritionByTextBtnDidTap(_ sender: Any) {
        imgToSend = nil
        captureType = .FOODNAME
        
        self.isTakePicture = false
        
        textMainView.isHidden = true
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CaptureImgSG", sender: nil)
        }
    }
    
    
    @IBAction func dismissTextMainViewBtnDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.textMainView.alpha = 0
        })
        
        textMainView.isHidden = true
        restartCaptureSession()
    }
    
    
    
    @objc func switchCamera(_ sender: UIButton?) {
        switchCameraInput()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !isTakePicture {
            return //이미지 버퍼로 할 일이 없음
        }
        
        //샘플버퍼에서 CVImageBuffer를 가져오기
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //CVImageBuffer에서 CIImage를 가져오기
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
                
        //CIImage를 UIImage로 변환
        let uiImage = UIImage(ciImage: ciImage)
        
        imgToSend = uiImage
        
        self.isTakePicture = false
        stopCaptureSession()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CaptureImgSG", sender: nil)
        }
    }
    
    //MARK: - util functions
    @objc func activateTextField() {
            mealNameTextField.becomeFirstResponder()
        }
    
    //MARK: - Switches function
    

    @objc func captureTypeViewChanged(_ sender: CustomSegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            captureType = .FOODIMG
            captureTypeLabel.text = "음식 사진 인식"
        } else {
            captureType = .OCR
            captureTypeLabel.text = "영양성분표 인식"
        }
    }
    
    //MARK: - Segue Prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CaptureImgSG" {
            let destinationVC = segue.destination as! CaptureImgViewController
            destinationVC.capturedImg = imgToSend
            destinationVC.captureType = captureType
            destinationVC.mealText = mealNameTextField.text
        }
    }

}

extension UIViewController {
    func checkPermissions() {
            let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch cameraAuthStatus {
              case .authorized:
                return
              case .denied:
                abort()
              case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                { (authorized) in
                  if(!authorized){
                    abort()
                  }
                })
              case .restricted:
                abort()
              @unknown default:
                fatalError()
            }
        }
}

extension SmartlensViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            imgToSend = image as! UIImage
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CaptureImgSG", sender: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        restartCaptureSession()
        dismiss(animated: true)
    }
}

