//
//  PricesTableViewCell.swift
//  AyranpinarFiyatGor
//
//  Created by Cuma Haznedar on 16.02.2022.
//

import UIKit

class PricesTableViewCell: UITableViewCell {

    @IBOutlet weak var tvProductName: UILabel!
    @IBOutlet weak var tvProductsPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
