//
//  ViewController.swift
//  CardGameApp
//
//  Created by Nguyen Huu Tien on 7/14/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cardsArray = [Card]()
    var model = CardModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // tạo mảng ngẫu nhiên 16 thẻ - 8 cặp
        cardsArray = model.getCards()
        
        // set viewcontroller như là một delegate và datasource của collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    // MARK: - COLLECTION VIEW DELEGATE METHOD
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // trả về số lương phần tử của mảng card
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // lấy một ô
        // CardCell là thằng cardCell trong CollectionView đã dược identifier
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
            
        
        // TODO: config the cell - thêm todo: thì có thể tìm kiếm dễ hơn hàm này
        
        
        // return nó
        return cell
    }

}

