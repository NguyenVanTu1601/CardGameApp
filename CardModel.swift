//
//  CardModel.swift
//  CardGameApp
//
//  Created by Nguyen Huu Tien on 7/15/21.
//

import Foundation
class CardModel {
    
    func getCards() -> [Card] {
        // tạo mảng card rỗng
        var cards = [Card]()
        
        // tạo 1 mảng random chứa các random chỉ xuất hiện 1 lần
        var arrayCard = [Int]()
        
        // Random cặp giá trị
        while arrayCard.count < 8 {
            let num = Int.random(in: 2...14)
            if !arrayCard.contains(num) {
                arrayCard.append(num)
            }
        }
        
        // Tạo 8 cặp thẻ
        for i in arrayCard {
            // tạo 2 card mới
            let CardOne = Card()
            let CardTwo = Card()
            
            // thêm ảnh vào card
            CardOne.imageName = "card\(i)"
            CardTwo.imageName = "card\(i)"
            
            // đưa card vào mảng cards
            cards.append(CardOne)
            cards.append(CardTwo)
            
            //Logging
            print("number card random : \(i)")
        }
        
        // xáo trộn đưa vào mảng
        cards.shuffle()
        
        // trả về mảng card gồm 16 thẻ
        return cards
    }
    
    func setCard() {
        
    }
    
}
