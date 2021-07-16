//
//  ViewController.swift
//  CardGameApp
//
//  Created by Nguyen Van Tu on 7/14/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cardsArray = [Card]()
    var model = CardModel()
    
    var timer: Timer?
    var millisecond: Int = 60 * 1000
    // lưu trữ thẻ đầu tiên được lật khi click
    // nếu click 1 thẻ thì kiểm tra first = nil thì lưu nó là thẻ dầud được lật
    // nếu click 1 cell mà thấy firstFlipped khác nil thì check gia trị xem có trùng nhau không, trùng thì xoá, không trùng thì set = nil
    var firstFlippedCardIndex : IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // tạo mảng ngẫu nhiên 16 thẻ - 8 cặp
        cardsArray = model.getCards()
        
        // set viewcontroller như là một delegate và datasource của collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        // tạo thread mới cho phép đếm tiếp thời gian khi vẫn cuộn màn hình
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // MARK: -TIME METHOD
    @objc func timerFired() {
        // khởi tạo
        millisecond -= 1
        
        // update lên label
        let seconds: Double = Double (millisecond)/1000.0
        timeLabel.text = String(format: "%.2f", seconds)
        
        // dừng thời gian khi = 0
        if seconds == 0 {
            timeLabel.textColor = UIColor.red
            titleTimer.textColor = UIColor.red
            
            timer?.invalidate()
            
            // kiểm tra nếu người dùng xoá hét các thẻ bài
            checkForGameEnd()
        }
        
        
    }

    // MARK: - COLLECTION VIEW DELEGATE METHOD
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // trả về số lương phần tử của mảng card
        return cardsArray.count
    }
    
    // hiển thị thẻ
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // print("Cell index : \(indexPath)")
        // lấy một ô
        // CardCell là thằng cardCell trong CollectionView đã dược identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
//       lấy trong hàm collectionView bên dưới để hiển thị tốt hơn
//        // lấy card từ mảng card
//        // indexPath.row trả về vị trí thẻ từ 0 đến 15
//        let card = cardsArray[indexPath.row]
//
//        // TODO: config the cell - thêm todo: thì có thể tìm kiếm dễ hơn hàm này
//        cell.configureCell(card: card)
        
        // return nó
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // video lession 27 - 29'
        // định cấu hình trạng thái của ô(cell) dựa trên các thuộc tính của thẻ mà nó đại diện
        let cardCell = cell as? CardCollectionViewCell
        
        // lấy card từ mảng card
        // indexPath.row trả về vị trí thẻ từ 0 đến 15
        let card = cardsArray[indexPath.row]
        
        // TODO: finish config the cell - thêm todo: thì có thể tìm kiếm dễ hơn hàm này
        cardCell?.configureCell(card: card)
        
    }
    
    // xử lý sự kiện click một thẻ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //nhận được một tham chiếu đến ô đã được nhấn
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // check trạngt thái thẻ để lật
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            // lật thẻ up
            cell?.flipUp(0.3)
            
            // check xem thẻ là thẻ đầu được lật không
            if firstFlippedCardIndex == nil {
                // firstFlipped trống thì ther đang click là thẻ đầu, lưu nó lại
                firstFlippedCardIndex = indexPath
            }else{
                // so sánh 2 thẻ
                checkForMatch(secondFlippedCarđIndex: indexPath)
                
            }
        }
        
    }
    
    // MARK - So sánh 2 thẻ
    func checkForMatch(secondFlippedCarđIndex : IndexPath) {
        let cardFirst = cardsArray[firstFlippedCardIndex!.row]
        let cardSecond = cardsArray[secondFlippedCarđIndex.row]
        
        // lấy 2 thẻ ở 2 cell
        let cardFirstCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardSecondCell = collectionView.cellForItem(at: secondFlippedCarđIndex) as? CardCollectionViewCell
        
        if cardFirst.imageName == cardSecond.imageName {
            // so sánh 2 thẻ giống nhau
            
            // đưa trạng thái thẻ về đã trùng nhau
            cardFirst.isMatched = true
            cardSecond.isMatched = true
        
            // xoá thẻ
            cardFirstCell?.remove()
            cardSecondCell?.remove()
            
            // check xem đã phải thẻ cuối chưa
            checkForGameEnd()
            
            
        }else {
            // so sánh thấy 2 thẻ khác nhau
            
            // lật lại 2 thẻ về mặt sau
            cardSecondCell?.flipDown(speed: 0.3)
            cardFirstCell?.flipDown(speed: 0.3)
            
        }
        
        // reset firstFlippedCarđInex = nil
        firstFlippedCardIndex = nil
        
    }

    // kiểm tra đã xoá hết thẻ chưa
    func checkForGameEnd() {
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            // user won, show alert
            showAlert(title: "Congratulations!", message: "You win the game.")
        }else{
            // user lose
            if millisecond <= 0 {
                showAlert(title: "Time's up", message: "Sorry, better luck next time!")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        // khoi tao alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // khởi tạo action
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        // add action
        alert.addAction(alertAction)
        
        // show alert
        present(alert, animated: true, completion: nil)
    }
}

