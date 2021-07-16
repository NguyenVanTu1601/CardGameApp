//
//  CardCollectionViewCell.swift
//  CardGameApp
//
//  Created by Nguyen Van Tu on 7/15/21.
//

import UIKit

// Cấu hình việc lật thẻ bài
class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    func configureCell(card: Card){
        // Theo doix thẻ mà ô này đại diện
        self.card = card
        
        //. set image front imageview
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        // thay đổi trạng thái của card để hiển thị nó ở dạng backImage hay frontImage
        if card.isFlipped == true {
            // show front
            flipUp(0)
        }else{
            // show back
            flipDown(speed: 0, delay: 0)
            
        }
    }
    
    func flipUp(_ speed:Double = 0.3) {
        // animation flip up
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
         
        // set trạng thái của card
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        // tạm dừng để hiển thị ảnh 2 trước khi lập lại vì không trùng
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            // animation flip down
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromRight], completion: nil)
        }
        
        // set trạng thái của card
        card?.isFlipped = false
    }
    
    func remove(){
        self.backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
