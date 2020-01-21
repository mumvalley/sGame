//
//  ViewController02.swift
//  sGame
//
//  Created by HT-19R1108 on 2019/12/26.
//  Copyright © 2019 HT-19R1108. All rights reserved.
//

import UIKit

class ViewController02: UIViewController {
    
    // -MARK: - プロパティ
    // ラベル
    @IBOutlet weak var lbState: UILabel!
    // ライフ
    @IBOutlet weak var lbLife: UILabel!
    // ステージ
    @IBOutlet weak var lbStage: UILabel!
    // 次に進むためのボタン
    let nextBtn = UIButton()
    // ハート
    @IBOutlet weak var ivHeart: UIImageView!
    
    // カードのアウトレット設定 20枚
    @IBOutlet weak var ivCard01: UIImageView!
    @IBOutlet weak var ivCard02: UIImageView!
    @IBOutlet weak var ivCard03: UIImageView!
    @IBOutlet weak var ivCard04: UIImageView!
    @IBOutlet weak var ivCard05: UIImageView!
    @IBOutlet weak var ivCard06: UIImageView!
    @IBOutlet weak var ivCard07: UIImageView!
    @IBOutlet weak var ivCard08: UIImageView!
    @IBOutlet weak var ivCard09: UIImageView!
    @IBOutlet weak var ivCard10: UIImageView!
    @IBOutlet weak var ivCard11: UIImageView!
    @IBOutlet weak var ivCard12: UIImageView!
    @IBOutlet weak var ivCard13: UIImageView!
    @IBOutlet weak var ivCard14: UIImageView!
    @IBOutlet weak var ivCard15: UIImageView!
    @IBOutlet weak var ivCard16: UIImageView!
    @IBOutlet weak var ivCard17: UIImageView!
    @IBOutlet weak var ivCard18: UIImageView!
    @IBOutlet weak var ivCard19: UIImageView!
    @IBOutlet weak var ivCard20: UIImageView!
    
    // タグの配列
    var tagArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    
    // ivCardオブジェクトを配列型に保持
    var ivFirstCardArray: [UIImageView] = []
    
    // UIImageViewのインスタンス作成
    var vw: UIImageView!
    
    // 画像の配列
    let imgs = ["images","img01", "img02","img03", "img04",
                "img05", "img06","img07", "img08","img09",
                "img10", "img10","img09", "img08","img07",
                "img06", "img05","img04", "img03","img02", "img01"]
    
    // １枚目の選択true, 2枚目の選択false
    var flg = true
    
    // 1枚目のカードのタグを保持
    var firstTapTag: Int!
    
    // 間違いカウント
    var missCnt = 0
    
    // ペア判断 ペア: true, noペア: false
    var pair = false
    
    // ペアカウント
    var pairCount = 0
    // ライフカウント
    let ad = UIApplication.shared.delegate as! AppDelegate
//    var life: Int = 0
    // ステージカウント
    var stg = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNextButton()
        shuffleCard()
        lbState.text = "❤️が100増えました"
        
        lbLife.text = "\(Int(ad.lifeCount))"
        print(ad.lifeCount)

    }
    
    // MARK: - アクションメソッド
    // カードをタップした時の処理
    @IBAction func tapCard(_ sender: UITapGestureRecognizer) {
        
        // UIImageViewクラスのプロパティを使うためキャスト
        vw = (sender.view as! UIImageView)
        
        // 同じカードを2回連続タップした時の処理
        if !flg && sender.view!.tag == firstTapTag {
            firstTapTag = sender.view!.tag
            return
        }
        
        // ライフが0より小さくなった時の処理
        if Int(ad.lifeCount) < 0 {
            lbState.text = "❤️がなくなりました"
            lbLife.text = "ゼロ"
            OriginalAnime.gameoverSound(uiiv: ivHeart)
            userIntaractionIsNot()
//            shuffleCard()
        }
        
        // 1枚目カードをタップした時の処理
        if flg && !pair && missCnt == 0 {
            OriginalAnime.flipCard(uiiv: vw)
            vw.image  = UIImage(named: imgs[sender.view!.tag])
            firstTapTag = sender.view!.tag
            ivFirstCardArray.append(vw)
            lbState.text = "同じ数字をさがしてね"
            flg = false
            print("１回目\(sender.view!.tag)")

        } else if !flg {
            // 2枚揃った時の処理
            if firstTapTag + sender.view!.tag == 21 {
                OriginalAnime.flipCard(uiiv: vw)
                vw.image = UIImage(named: imgs[sender.view!.tag])
                ivFirstCardArray.append(vw)
                lbState.text = "そろいましたよ"
                flg = true
                missCnt = 0
                
                ad.lifeCount += 5
                
                pair = true
                pairCount += 1

            } else {
                // 揃わなかった時の処理
                OriginalAnime.flipCard(uiiv: vw)
                vw.image = UIImage(named: imgs[sender.view!.tag])
                ivFirstCardArray.append(vw)
                missCnt += 1
                
                ad.lifeCount -= 10
                
                lbState.text = "ちゃいますよ"
                flg = true
                print("２回目\(sender.view!.tag)")
            }
            
        } else if flg && pair {
            // 2枚揃った後の処理
            print("揃った後の処理")
            OriginalAnime.matchCardSound()
            lbLife.text = "\(Int(ad.lifeCount))"
            OriginalAnime.lifeLabelRecovery(label: lbLife, uiiv: ivHeart)
            
            vw = ivFirstCardArray[0]
//            vw.removeFromSuperview()
            OriginalAnime.pairAnime(uiiv: vw)
//            vw.image = nil
//            vw.isUserInteractionEnabled = false
            
            vw = ivFirstCardArray[1]
//            vw.removeFromSuperview()
            OriginalAnime.pairAnime(uiiv: vw)
//            vw.image = nil
//            vw.isUserInteractionEnabled = false
            ivFirstCardArray.removeAll()
            pair = false
            
            // 全部揃えた時
            if pairCount == 10 {
                
                lbStage.text = "\(stg)巡目"
                lbState.text = "上がりです〜😄"
                pairCount = 0
                stg += 1
                
                view.addSubview(nextBtn)
                
                
            }

            
        } else if flg && !pair && missCnt > 0 {
            // 揃わなかった後の処理
            print("揃わなかった後の処理")
            lbLife.text = "\(Int(ad.lifeCount))"
            OriginalAnime.lifeLabelDamage(label: lbLife, uiiv: ivHeart)
            
            vw = ivFirstCardArray[0]
            OriginalAnime.backFlipCard(uiiv: vw)
//            vw.image = UIImage(named: "images")
            
            vw = ivFirstCardArray[1]
            OriginalAnime.backFlipCard(uiiv: vw)
//            vw.image = UIImage(named: "images")
            ivFirstCardArray.removeAll()
            missCnt = 0
            
        }
        
    }
    
    
    // MARK: - オリジナルメソッド
    // カードリセットシャッフルメソッド
    func shuffleCard() {
        createNextButton()
//        ad.lifeCount = 30
        pairCount = 0
        flg = true
        
        let firstStep = 206 // 1段目のy座標
        let secondStep = 324 // 2段目のy座標
        let thirdStep  = 442
        let fourthStep = 560
        let wid = 65 // カードの幅
        let hig = 105 // カードの高さ
        
        ivCard01.frame = CGRect(x: 20, y: firstStep, width: wid, height: hig)
        ivCard02.frame = CGRect(x: 98, y: firstStep, width: wid, height: hig)
        ivCard03.frame = CGRect(x: 174, y: firstStep, width: wid, height: hig)
        ivCard04.frame = CGRect(x: 250, y: firstStep, width: wid, height: hig)
        ivCard05.frame = CGRect(x: 329, y: firstStep, width: wid, height: hig)
        ivCard06.frame = CGRect(x: 20, y: secondStep, width: wid, height: hig)
        ivCard07.frame = CGRect(x: 98, y: secondStep, width: wid, height: hig)
        ivCard08.frame = CGRect(x: 174, y: secondStep, width: wid, height: hig)
        ivCard09.frame = CGRect(x: 250, y: secondStep, width: wid, height: hig)
        ivCard10.frame = CGRect(x: 329, y: secondStep, width: wid, height: hig)
        ivCard11.frame = CGRect(x: 20, y: thirdStep, width: wid, height: hig)
        ivCard12.frame = CGRect(x: 98, y: thirdStep, width: wid, height: hig)
        ivCard13.frame = CGRect(x: 174, y: thirdStep, width: wid, height: hig)
        ivCard14.frame = CGRect(x: 250, y: thirdStep, width: wid, height: hig)
        ivCard15.frame = CGRect(x: 329, y: thirdStep, width: wid, height: hig)
        ivCard16.frame = CGRect(x: 20, y: fourthStep, width: wid, height: hig)
        ivCard17.frame = CGRect(x: 98, y: fourthStep, width: wid, height: hig)
        ivCard18.frame = CGRect(x: 174, y: fourthStep, width: wid, height: hig)
        ivCard19.frame = CGRect(x: 250, y: fourthStep, width: wid, height: hig)
        ivCard20.frame = CGRect(x: 329, y: fourthStep, width: wid, height: hig)
        
        // タップで反応するように
        ivCard01.isUserInteractionEnabled = true
        ivCard02.isUserInteractionEnabled = true
        ivCard03.isUserInteractionEnabled = true
        ivCard04.isUserInteractionEnabled = true
        ivCard05.isUserInteractionEnabled = true
        ivCard06.isUserInteractionEnabled = true
        ivCard07.isUserInteractionEnabled = true
        ivCard08.isUserInteractionEnabled = true
        ivCard09.isUserInteractionEnabled = true
        ivCard10.isUserInteractionEnabled = true
        ivCard11.isUserInteractionEnabled = true
        ivCard12.isUserInteractionEnabled = true
        ivCard13.isUserInteractionEnabled = true
        ivCard14.isUserInteractionEnabled = true
        ivCard15.isUserInteractionEnabled = true
        ivCard16.isUserInteractionEnabled = true
        ivCard17.isUserInteractionEnabled = true
        ivCard18.isUserInteractionEnabled = true
        ivCard19.isUserInteractionEnabled = true
        ivCard20.isUserInteractionEnabled = true
        
        // カードを表示
//        view.addSubview(ivCard01)
//        view.addSubview(ivCard02)
//        view.addSubview(ivCard03)
//        view.addSubview(ivCard04)
//        view.addSubview(ivCard05)
//        view.addSubview(ivCard06)
//        view.addSubview(ivCard07)
//        view.addSubview(ivCard08)
//        view.addSubview(ivCard09)
//        view.addSubview(ivCard10)
        
        // タグシャッフル
        tagArray.shuffle()
        
        // カードのタグを代入
        ivCard01.tag = tagArray[0]
        ivCard02.tag = tagArray[1]
        ivCard03.tag = tagArray[2]
        ivCard04.tag = tagArray[3]
        ivCard05.tag = tagArray[4]
        ivCard06.tag = tagArray[5]
        ivCard07.tag = tagArray[6]
        ivCard08.tag = tagArray[7]
        ivCard09.tag = tagArray[8]
        ivCard10.tag = tagArray[9]
        ivCard11.tag = tagArray[10]
        ivCard12.tag = tagArray[11]
        ivCard13.tag = tagArray[12]
        ivCard14.tag = tagArray[13]
        ivCard15.tag = tagArray[14]
        ivCard16.tag = tagArray[15]
        ivCard17.tag = tagArray[16]
        ivCard18.tag = tagArray[17]
        ivCard19.tag = tagArray[18]
        ivCard20.tag = tagArray[19]
        
        // カード全て裏向きにする
        ivCard01.image = UIImage(named: "images")
        ivCard02.image = UIImage(named: "images")
        ivCard03.image = UIImage(named: "images")
        ivCard04.image = UIImage(named: "images")
        ivCard05.image = UIImage(named: "images")
        ivCard06.image = UIImage(named: "images")
        ivCard07.image = UIImage(named: "images")
        ivCard08.image = UIImage(named: "images")
        ivCard09.image = UIImage(named: "images")
        ivCard10.image = UIImage(named: "images")
        ivCard11.image = UIImage(named: "images")
        ivCard12.image = UIImage(named: "images")
        ivCard13.image = UIImage(named: "images")
        ivCard14.image = UIImage(named: "images")
        ivCard15.image = UIImage(named: "images")
        ivCard16.image = UIImage(named: "images")
        ivCard17.image = UIImage(named: "images")
        ivCard18.image = UIImage(named: "images")
        ivCard19.image = UIImage(named: "images")
        ivCard20.image = UIImage(named: "images")

    }
    
    // [カードをまぜる]ボタン押下処理
    @IBAction func shuffleBtn(_ sender: UIButton) {
        OriginalAnime.shuffleCardSound(uiiv: ivHeart)
        ad.lifeCount = 100
        stg = 1
        flg = true
        ivFirstCardArray.removeAll()
        lbLife.text = "\(Int(ad.lifeCount))"
        nextBtn.removeFromSuperview()
        
        
        lbState.text = "カードをまぜました"
        flg = true
        
        // カードを集めるアニメーション
        OriginalAnime.shuffleCardAnime(uiiv: ivCard01)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard02)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard03)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard04)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard05)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard06)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard07)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard08)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard09)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard10)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard11)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard12)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard13)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard14)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard15)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard16)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard17)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard18)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard19)
        OriginalAnime.shuffleCardAnime(uiiv: ivCard20)
        
        
        shuffleCard()
        
    }
    
    
    //　すべてのカードをタップ反応しないようにする
    func userIntaractionIsNot () {
        
        ivCard01.isUserInteractionEnabled = false
        ivCard02.isUserInteractionEnabled = false
        ivCard03.isUserInteractionEnabled = false
        ivCard04.isUserInteractionEnabled = false
        ivCard05.isUserInteractionEnabled = false
        ivCard06.isUserInteractionEnabled = false
        ivCard07.isUserInteractionEnabled = false
        ivCard08.isUserInteractionEnabled = false
        ivCard09.isUserInteractionEnabled = false
        ivCard10.isUserInteractionEnabled = false
        ivCard11.isUserInteractionEnabled = false
        ivCard12.isUserInteractionEnabled = false
        ivCard13.isUserInteractionEnabled = false
        ivCard14.isUserInteractionEnabled = false
        ivCard15.isUserInteractionEnabled = false
        ivCard16.isUserInteractionEnabled = false
        ivCard17.isUserInteractionEnabled = false
        ivCard18.isUserInteractionEnabled = false
        ivCard19.isUserInteractionEnabled = false
        ivCard20.isUserInteractionEnabled = false
    }
    
    // 次に進むボタン作成
    func createNextButton() {
        
        let cgr = CGRect(x: (view.center.x) - 90 , y: (view.center.y) - 100 ,
                         width: 180, height: 100)
        nextBtn.frame = cgr
        nextBtn.titleLabel?.font = UIFont(name: "TsukuARdGothic-Regular", size: 24)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        nextBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        nextBtn.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        nextBtn.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        nextBtn.layer.cornerRadius = 50
        nextBtn.layer.borderWidth = 0.5
        nextBtn.setTitle("天晴れ", for: .normal)
        
        nextBtn.addTarget(self,
                          action: #selector(nextGame(sender:)),
                          for: .touchUpInside)
    }
    
    // 次のゲームへボタン押下処理
    @objc func nextGame(sender: UIButton) {
        print(#function)
        
    }
    
    // [裏技]ハートを長押しした時の処理
    @IBAction func lifeGesture(_ sender: UILongPressGestureRecognizer) {
        
        ad.lifeCount += 10
        lbLife.text = "\(Int(ad.lifeCount))"
    }
}

