//
//  SearchWithNameVC.swift
//  AyranpinarFiyatGor
//
//  Created by Cuma Haznedar on 16.02.2022.
//

import UIKit
import Alamofire

class SearchWithNameVC: UIViewController {

    @IBOutlet weak var ivGeri: UIImageView!
    @IBOutlet var ivMainArea: UIView!
    @IBOutlet weak var etProductsNAme: UITextField!
    @IBOutlet weak var pricesTableViewName: UITableView!
    @IBOutlet weak var topArea: UIView!
    
    var gidenFiyat = ""
    var productList = [FiyatGorJSON]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ivGeri.isUserInteractionEnabled = true
        ivGeri.addGestureRecognizer(tapGestureRecognizer)
        design()
        // Do any additional setup after loading the view.
    }
    
    func design(){
        
        let redColor = UIColor(hexString: "cc2829")
    
        self.ivMainArea.backgroundColor = redColor
        
        self.topArea.backgroundColor = redColor
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
     {
         self.dismiss(animated: true, completion: nil)
     }
    
    @IBAction func btnPrice(_ sender: Any) {
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
                        
        let name = self.etProductsNAme.text
        
        
        
        if let productNames = name {
            
            getPriceWithName(name: productNames, cihazKodu: deviceID)
            
        }
        
        
    }
    
    func getPriceWithName(name:String, cihazKodu:String){
                
        let parametreler : Parameters = [
            "Pst_UrunAdi" : name,
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
                                    self.pricesTableViewName.reloadData()
                                }
                                
                            }else{
                                
                                
                                let alertControllerBayiiMod = UIAlertController(title: "Fiyat : \(self.gidenFiyat) TL", message: "Barkod okutmaya devam etmek için Tamam butonuna tıklayınız", preferredStyle: .alert)
                                   
                                   let tamamActionBayiMod = UIAlertAction(title: "Tamam", style: .cancel){
                                       
                                       action in
                                       self.etProductsNAme.text = ""

                                       print("Tamam Tıklandı")
                                                                              
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
                               self.etProductsNAme.text = ""
                               print("Tamam Tıklandı")
                               
                               
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

}

extension SearchWithNameVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = productList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fiyatHucreName", for: indexPath) as! PricesTableViewCell
        
        cell.tvProductName.text = kelime.urunAdi
        cell.tvProductsPrice.text = kelime.fiyat
        
        return cell
    
    }
    
    
}
