//
//  QrScreenVC.swift
//  AyranpinarFiyatGor
//
//  Created by Cuma Haznedar on 11.02.2022.
//

import UIKit
import AVFoundation
import Alamofire

class QrScreenVC: UIViewController {

    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var previewArea: UIView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var topArea: UIView!
    @IBOutlet weak var ivGeri: UIImageView!
    @IBOutlet weak var pricesTableView: UITableView!
    @IBOutlet var mainArea: UIView!
    
    var productList = [FiyatGorJSON]()
    var gidenFiyat = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        let redColor = UIColor(hexString: "cc2829")
        self.topArea.backgroundColor = redColor
        self.mainArea.backgroundColor = redColor
        // Do any additional setup after loading the view.
        
        pricesTableView.delegate = self
        pricesTableView.dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ivGeri.isUserInteractionEnabled = true
        ivGeri.addGestureRecognizer(tapGestureRecognizer)
        
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
     {
         self.dismiss(animated: true, completion: nil)
     }
    
    func getPriceWithBarcode(barcode:String, cihazKodu:String){
        
        print("Servis Başladı")
        
        let parametreler : Parameters = [
            "Pst_Barkod" : barcode,
            "Pst_CihazKodu" : cihazKodu]
        
        AF.request("Your awasome URL", method: .post, parameters:parametreler).responseJSON{ [self]
            response in
            
            if let data = response.data {
                
                do {
                         
                    let cevap = try JSONDecoder().decode(PriceModel.self, from: data)
                    
                    if cevap.success == 1 {
                        
                        
                        if let liste = cevap.fiyatGorJSON {
                            
                            var cevap = 0
                            
                            for i in liste {
                                        
                                cevap += 1
                                
                                self.gidenFiyat = i.fiyat
                                
                                print(i.fiyat)
                                
                             }
                            
                            if cevap > 1 {
                                
                                self.productList = liste
                                
                                DispatchQueue.main.async {
                                    self.pricesTableView.reloadData()
                                }
                                
                            }else{
                                
                                
                                let alertControllerBayiiMod = UIAlertController(title: "Fiyat : \(self.gidenFiyat) TL", message: "Barkod okutmaya devam etmek için Tamam butonuna tıklayınız", preferredStyle: .alert)
                                   
                                   let tamamActionBayiMod = UIAlertAction(title: "Tamam", style: .cancel){
                                       
                                       action in
                                       
                                       print("Tamam Tıklandı")
                                       
                                       self.avCaptureSession.startRunning()
                                       
                                   }
                                   
                                   alertControllerBayiiMod.addAction(tamamActionBayiMod)
                                   
                                   self.present(alertControllerBayiiMod, animated: true)
                                
                            }
                
                                            
                        }else{
                            
                            
                        }
                    }
                    
                    if cevap.success == 0 {
                        
                        
                        let alertControllerBayiiMod = UIAlertController(title: "Ürün Bulunamadı!", message: "Barkod okutmaya devam etmek için Tamam butonuna tıklayınız", preferredStyle: .alert)
                           
                           let tamamActionBayiMod = UIAlertAction(title: "Tamam", style: .cancel){
                               
                               action in
                               print("Tamam Tıklandı")
                               
                               self.avCaptureSession.startRunning()
                               
                           }
                           
                           alertControllerBayiiMod.addAction(tamamActionBayiMod)
                           
                           self.present(alertControllerBayiiMod, animated: true)
                        
                        
                    }
                    
                    

                    
                }catch{
                       
                    print("Hata : \(error.localizedDescription)")

                }
                
            }else{
                
                print("Liste Boş")

            }
            
        }
        
    }


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

extension QrScreenVC : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            var deviceID = UIDevice.current.identifierForVendor?.uuidString
                            
            if let cihazKodu = deviceID {
                
                getPriceWithBarcode(barcode: stringValue, cihazKodu: cihazKodu)
                print(cihazKodu)
                
            }
            
            
        }
        
       // dismiss(animated: true)
    }

}

extension QrScreenVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = productList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fiyatHucre", for: indexPath) as! PricesTableViewCell
        
        cell.tvProductName.text = kelime.urunAdi
        cell.tvProductsPrice.text = kelime.fiyat
        
        return cell
    
    }
    
    
}
