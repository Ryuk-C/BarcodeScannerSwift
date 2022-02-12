//
//  QRCodeVC.swift
//  AyranpinarFiyatGor
//
//  Created by Cuma Haznedar on 11.02.2022.
//

import UIKit
import AVFoundation
import Alamofire

class HomeVC: UIViewController {

    @IBOutlet weak var searchWithBarcode: UIView!
    @IBOutlet weak var searchWithName: UIView!
    @IBOutlet weak var labelPrice: UIView!
    @IBOutlet weak var topArea: UIView!
    
    var qrCodeTekliFiyat = "Null"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapBarcode(_:)))
        searchWithBarcode.addGestureRecognizer(tapGestureRecognizer)
        
        print("Test-----\(qrCodeTekliFiyat)")

        
        if qrCodeTekliFiyat != "Null" {
            
            print("Tekrar-----\(qrCodeTekliFiyat)")
            
            
            
            
        }
        

}
    
    
    @IBAction func handleTapBarcode(_ sender: UITapGestureRecognizer? = nil) {
                
        print("Tiklandı")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         
        let gidilecekVC = storyBoard.instantiateViewController(withIdentifier:"searcWithBarcodeID") as! QrScreenVC
        
        gidilecekVC.modalPresentationStyle = .currentContext

        self.present(gidilecekVC, animated: true, completion: nil)
    }
    
    func design(){
        
        let grayColor = UIColor(hexString: "F5F6FB")
        let redColor = UIColor(hexString: "cc2829")
        
        self.searchWithBarcode.layer.cornerRadius = 9
        self.searchWithBarcode.layer.borderWidth = 0.85
        self.searchWithBarcode.layer.borderColor = UIColor.gray.cgColor
        
        self.searchWithName.layer.cornerRadius = 9
        self.searchWithName.layer.borderWidth = 0.85
        self.searchWithName.layer.borderColor = UIColor.gray.cgColor
        self.topArea.backgroundColor = redColor
        
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension HomeVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
    
