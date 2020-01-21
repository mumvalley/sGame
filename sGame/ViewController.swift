//
//  ViewController.swift
//  sGame
//
//  Created by HT-19R1108 on 2019/12/16.
//  Copyright © 2019 HT-19R1108. All rights reserved.
//　２枚目選択して揃わなかった時の処理を考える ok
//　同じカードを選択できないようにする ok
// カードのシャッフル ok
// オープニング ok
// removeFromSuperviewでオブジェクト削除した後の再描画 imageをnilにして
//        isUserInterctive..で対応 ok
// 音を追加する
// Game Overの際、背景色変えたりなんかしてみる
// アニメーションをつける
// ゴールしたらStage進むようにする



import UIKit

class ViewController: UIViewController {
    
    // -MARK: - プロパティ
    // ラベル
    @IBOutlet weak var lbState: UILabel!
    // ライフ
    @IBOutlet weak var lbLife: UILabel!
    // ステージ
    @IBOutlet weak var lbStage: UILabel!
    // 次に進むためのボタン
    let nextBtn = UIButton()
    @IBOutlet weak var ivHeart: UIImageView!
    
    // カードのアウトレット設定 10枚
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
    
    // タグの配列
    var tagArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    // ivCardオブジェクトを配列型に保持
    var ivFirstCardArray: [UIImageView] = []
    
    // UIImageViewのインスタンス作成
    var vw: UIImageView!
    
    // 画像の配列
    let imgs = ["images","img01", "img02","img03", "img04",
                "img05","img05", "img04","img03", "img02",
                "img01"]
    
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
    var life = 30
    let ad = UIApplication.shared.delegate as! AppDelegate
    // ステージカウント
    var stg = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNextButton()
        shuffleCard()
        ad.lifeCount = life

        lbLife.text = "\(life)"

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
        if life < 0 {
            lbState.text = "❤️がなくなりました"
            lbLife.text = "ゼロ"
            userIntaractionIsNot()
            OriginalAnime.gameoverSound(uiiv: ivHeart)

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
            if firstTapTag + sender.view!.tag == 11 {
                OriginalAnime.flipCard(uiiv: vw)
                vw.image = UIImage(named: imgs[sender.view!.tag])
                ivFirstCardArray.append(vw)
                lbState.text = "そろいましたよ"
                flg = true
                missCnt = 0
                
                life += 5
                
                pair = true
                pairCount += 1

            } else {
                // 揃わなかった時の処理
                OriginalAnime.flipCard(uiiv: vw)
                vw.image = UIImage(named: imgs[sender.view!.tag])
                ivFirstCardArray.append(vw)
                missCnt += 1
                
                life -= 10
                
                lbState.text = "ちゃいますよ"
                flg = true
                print("２回目\(sender.view!.tag)")
            }
            
        } else if flg && pair {
            // 2枚揃った後の処理
            print("揃った後の処理")
            OriginalAnime.matchCardSound()
            lbLife.text = "\(life)"
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
            if pairCount == 5 {
                
                lbStage.text = "\(stg)巡目"
                lbState.text = "おめでとうございます🤣"
                pairCount = 0
                stg += 1
                life += 100
                OriginalAnime.gameClearSound()
                ad.lifeCount = life
                view.addSubview(nextBtn)
                
                
            }

            
        } else if flg && !pair && missCnt > 0 {
            // 揃わなかった後の処理
            print("揃わなかった後の処理")
            lbLife.text = "\(life)"
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
        life = 30
        pairCount = 0
        flg = true
        
        let firstStep = 234 // 1段目のy座標
        let secondStep = 368 // 2段目のy座標
        let wid = 70 // カードの幅
        let hig = 110 // カードの高さ
        
        ivCard01.frame = CGRect(x: 20, y: firstStep, width: wid, height: hig)
        ivCard02.frame = CGRect(x: 95, y: firstStep, width: wid, height: hig)
        ivCard03.frame = CGRect(x: 171, y: firstStep, width: wid, height: hig)
        ivCard04.frame = CGRect(x: 247, y: firstStep, width: wid, height: hig)
        ivCard05.frame = CGRect(x: 322, y: firstStep, width: wid, height: hig)
        ivCard06.frame = CGRect(x: 20, y: secondStep, width: wid, height: hig)
        ivCard07.frame = CGRect(x: 95, y: secondStep, width: wid, height: hig)
        ivCard08.frame = CGRect(x: 171, y: secondStep, width: wid, height: hig)
        ivCard09.frame = CGRect(x: 247, y: secondStep, width: wid, height: hig)
        ivCard10.frame = CGRect(x: 322, y: secondStep, width: wid, height: hig)
        
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

    }
    
    // [カードをまぜる]ボタン押下処理
    @IBAction func shuffleBtn(_ sender: UIButton) {
//        ivHeart.frame = CGRect(x: 21, y: 25, width: 70, height: 80)
        OriginalAnime.shuffleCardSound(uiiv: ivHeart)
        life = 30
        stg = 1
        flg = true
        ivFirstCardArray.removeAll()
        lbLife.text = "\(life)"
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
    }
    
    // 次に進むボタン作成
    func createNextButton() {
        
        let cgr = CGRect(x: (view.center.x) - 90 , y: (view.center.y) + 130 ,
                         width: 180, height: 100)
        nextBtn.frame = cgr
        nextBtn.titleLabel?.font = UIFont(name: "TsukuARdGothic-Regular", size: 24)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        nextBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        nextBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        nextBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nextBtn.layer.cornerRadius = 0
        nextBtn.layer.borderWidth = 0.5
        nextBtn.setTitle("次に進む", for: .normal)
        
        nextBtn.addTarget(self,
                          action: #selector(nextGame(sender:)),
                          for: .touchUpInside)
    }
    
    // 次のゲームへボタン押下処理
    @objc func nextGame(sender: UIButton) {
        let vw = storyboard?.instantiateViewController(
            withIdentifier: "Stage2") as! ViewController02
        vw.modalPresentationStyle = .fullScreen
        vw.modalTransitionStyle = .flipHorizontal
        
        present(vw, animated: true) {
            self.nextBtn.removeFromSuperview()
        }
        
        OriginalAnime.startBtn()
        
    }
    
    // [裏技]ハートを長押しした時の処理
    @IBAction func lifeGesture(_ sender: UILongPressGestureRecognizer) {
        
        life += 10
        lbLife.text = "\(life)"
    }
}

