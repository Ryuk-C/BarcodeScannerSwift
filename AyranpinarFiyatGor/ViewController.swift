//
//  ViewController.swift
//  AyranpinarFiyatGor
//
//  Created by Cuma Haznedar on 11.02.2022.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {

    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var previewArea: UIView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var topArea: UIView!
    @IBOutlet weak var ivGeri: UIImageView!
    
    var gidenFiyat = "Null"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let redColor = UIColor(hexString: "cc2829")
        self.topArea.backgroundColor = redColor

        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //ivGeri.isUserInteractionEnabled = true
        //ivGeri.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
        
       // tvRepeat.isHidden = true
        
       // let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
       // tvRepeat.addGestureRecognizer(tapGestureRecognizer)

        
        avCaptureSession = AVCaptureSession()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                        self.failed()
                        return
                    }
                    
                    let avVideoInput: AVCaptureDeviceInput
                    
                    do {
                        avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                    } catch {
                        self.failed()
                        return
                    }
                    
                    if (self.avCaptureSession.canAddInput(avVideoInput)) {
                        self.avCaptureSession.addInput(avVideoInput)
                    } else {
                        self.failed()
                        return
                    }
                    
                    let metadataOutput = AVCaptureMetadataOutput()
                    
                    if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                        self.avCaptureSession.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
                    } else {
                        self.failed()
                        return
                    }
                    
                    self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
                    self.avPreviewLayer.frame = self.previewArea.layer.bounds
                    self.avPreviewLayer.videoGravity = .resizeAspectFill
                    self.previewArea.layer.addSublayer(self.avPreviewLayer)
                    self.avCaptureSession.startRunning()
                }
        
        
        
    }
    
  /*  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    } */
    
    
  /*  @IBAction func tekrarla(_ sender: Any) {
        
        print("Tiklandı")
        
        avCaptureSession.startRunning()
        tvRepeat.isHidden = true
        
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer? = nil) {
                
        print("Tiklandı")
        
        avCaptureSession.startRunning()
       // tvRepeat.isHidden = true
        
        
    
    }*/

    func failed() {
            let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            avCaptureSession = nil
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if (avCaptureSession?.isRunning == false) {
                avCaptureSession.startRunning()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if (avCaptureSession?.isRunning == true) {
                
                avCaptureSession.stopRunning()
                
            }
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
        
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
        
    }
    extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            
            //okuma bitince duruyor
            avCaptureSession.stopRunning()
            //tvRepeat.isHidden = false
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                var deviceID = UIDevice.current.identifierForVendor?.uuidString
                                
                if let cihazKodu = deviceID {
                    
                    getPriceWithBarcode(barcode: stringValue, cihazKodu: cihazKodu)
                    print(cihazKodu)
                    
                }
                
                found(code: stringValue)
                
            }
            
            dismiss(animated: true)
        }
        
        func found(code: String) {
            
            print(code)
            //getPrice(barcode: code)
            
        }
        
        func getPriceWithBarcode(barcode:String, cihazKodu:String){
            
            print("Servis Başladı")

            
            let parametreler : Parameters = [
                "Pst_Barkod" : barcode,
                "Pst_CihazKodu" : cihazKodu

            ]
            
            AF.request("https://www.biyons.com/services/beesip/firm/ConFiyatGorIOS.php", method: .post, parameters:parametreler).responseJSON{
                response in
                
                if let data = response.data {
                    
                    do {
                             
                        let cevap = try JSONDecoder().decode(PriceModel.self, from: data)
                        
                        if let liste = cevap.fiyatGorJSON {
                            
                            print("Liste Dolu")
                                                 
                            for i in liste {
                                    
                            
                                self.gidenFiyat = i.fiyat
                                
                                print(i.fiyat)
                                
                             }
                                            

                        }else{
                            

                            
                            
                        }

                        
                    }catch{
                           
                        print("Hata : \(error.localizedDescription)")


                    }
                    
                }else{
                    
                    print("Liste Boş")

                    
                }
                
            }
            
            
        }

}

