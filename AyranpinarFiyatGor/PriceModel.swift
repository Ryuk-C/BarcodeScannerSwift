//
//  PriceModel.swift
//  AyranpinarFiyatGor
//
//  Created by Cuma Haznedar on 11.02.2022.
//

import Foundation

class PriceModel: Codable {
    let fiyatGorJSON: [FiyatGorJSON]?
    let success: Int?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case fiyatGorJSON = "FiyatGorJSON"
        case success, message
    }

    init(fiyatGorJSON: [FiyatGorJSON], success: Int, message: String) {
        self.fiyatGorJSON = fiyatGorJSON
        self.success = success
        self.message = message
    }
}

// MARK: - FiyatGorJSON
class FiyatGorJSON: Codable {
    let urunAdi, barkod, fiyat, kampanyaliFiyat: String

    enum CodingKeys: String, CodingKey {
        case urunAdi = "UrunAdi"
        case barkod = "Barkod"
        case fiyat = "Fiyat"
        case kampanyaliFiyat = "KampanyaliFiyat"
    }

    init(urunAdi: String, barkod: String, fiyat: String, kampanyaliFiyat: String) {
        self.urunAdi = urunAdi
        self.barkod = barkod
        self.fiyat = fiyat
        self.kampanyaliFiyat = kampanyaliFiyat
    }
}
