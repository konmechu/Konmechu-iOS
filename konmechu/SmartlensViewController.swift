//
//  SmartlensViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import AVFoundation

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
    
    
    //let capturedImageView = CapturedImageView()
    var imgToSend :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        imagePickerController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartCaptureSession), name: NSNotification.Name("DidDismissCaptureImgViewController"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        setupAndStartCaptureSession()
    }
    
    //MARK: - UI setup
    func setupView() {
        captureImageBtn.layer.cornerRadius = captureImageBtn.frame.width / 2
        captureImageBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        captureImageBtn.layer.shadowOpacity = 0.8
        previewView.layer.cornerRadius = 35
        previewView.clipsToBounds = true
    }
    
    //MARK: - Camera Setup
    func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            //세션 초기화
            captureSession = AVCaptureSession()
            //구성 (configuration) 시작
            captureSession.beginConfiguration()
            
            //session specific configuration
            //세션 프리셋을 설정하기 전에 지원여부를 확인해야 합니다.
            if captureSession.canSetSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }
            
            //사용가능한 경우 세션이 자동으로 광역 색상을 사용해야 하는지 여부를 지정합니다.
            captureSession.automaticallyConfiguresCaptureDeviceForWideColor =  true
            
            //setup inputs
            setupInputs()
            
            //UI 관련 부분은 메인 스레드에서 실행되어야 한다.
            DispatchQueue.main.async {
                //미리보기 레이어 셋업
                self.setupPreviewLayer()
            }
            
            setupOutput()
            
            //commit configuration: 단일 atomic 업데이트에서 실행중인 캡처 세션의 구성에 대한 하나 이상의 변경 사항을 커밋합니디.
            self.captureSession.commitConfiguration()
            
            //캡처 세션 실행
            captureSession.startRunning()
        }
    }
    
    func setupInputs() {
        //후면 back 및 전면 front 카메라
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            self.backCamera = backCamera
            self.frontCamera = frontCamera
        } else {
            fatalError("No cameras. ")
        }
        
        //기기로부터 입력 오브젝트 만들기
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
        
        //후면 카메라 입력을 세션에 연결
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
        // 사용자에게는 재미가 있지만 성능에는 재미가 없습니다.
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
    
    //MARK: - Segue Prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CaptureImgSG" {
            let destinationVC = segue.destination as! CaptureImgViewController
            destinationVC.capturedImg = imgToSend
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

