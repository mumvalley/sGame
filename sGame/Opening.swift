//
//  Opening.swift
//  sGame
//
//  Created by HT-19R1108 on 2019/12/18.
//  Copyright © 2019 HT-19R1108. All rights reserved.
//

import UIKit

class Opening: UIViewController {
    
    // ゲームの説明 textView
    @IBOutlet weak var tvDiscription: UITextView!
    // ロゴ
    @IBOutlet weak var ivLogo: UIImageView!
    // [開始]ボタン
    @IBOutlet weak var btnStart: UIButton!
    // [遊び方]ボタン
    @IBOutlet weak var btnDiscription: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OriginalAnime.initSoundEffect()
        
        tvDiscription.font = UIFont(name: "TsukuARdGothic-Regular", size: 20)
        tvDiscription.font = UIFont.systemFont(ofSize: 18)
        tvDiscription.alpha = 0
        tvDiscription.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tvDiscription.layer.borderWidth = 0.5
        tvDiscription.layer.cornerRadius = 50
        tvDiscription.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 30, right: 10)
//        tvDiscription.sizeToFit()
        
        OriginalAnime.opening()
        
    }
    
    // 他画面の遷移前（準備処理）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier else {
            return
        }
        
        // セグエIDの判定
        if id == "opToMain" {
            
            // 遷移先の画面
//            let destViewController =
            segue.destination as! ViewController
//            print(destViewController)
        }
    }
    
    // タイトルへを押された時の処理
    @IBAction func unwindToOp(_ unwindSegue: UIStoryboardSegue) {
        print(#function)
        OriginalAnime.titleSound()
        guard let id = unwindSegue.identifier else {
            return
        }
        
        if id == "mainToOp" {
            // 遷移元の画面
//            let sourceViewController =
                unwindSegue.source as! Opening
//            print(sourceViewController)
        }
    }
    
    
    // [開始]ボタン押下時
    @IBAction func startBtn(_ sender: UIButton) {
        
        OriginalAnime.startBtn()
        
    }
    
    // [遊び方]ボタン押下時
    @IBAction func DiscriptionBtn(_ sender: UIButton) {
        
        ivLogo.alpha = 0.3
        btnStart.alpha = 0.3
        btnDiscription.alpha = 0.3
        
//        tvDiscription.alpha = 0.8
        OriginalAnime.disctiptionTextView(uitv: tvDiscription)
        tvDiscription.text = "★神経衰弱ゲームの遊び方★\n\n" +

        "1. 開始ボタンを押すと画面が変わり場にカードが10枚並んでいます。\n\n" +

        "2. 好きな2枚のカードをタップするとカードがめくられ数字が書かれています。\n\n" +

        "3. めくったカードの数字が同じ場合、❤️が5増え、場からカードが消えます。\n\n" +

        "4. めくったカードの数字が異なる場合、❤️が10減り、カードは元どおり伏せられます。\n\n" +

        "5. 開始時の❤️は30です。\n\n" +

        "6. ❤️が0より小さくなるとはじめからやり直しになります。\n\n" +

        "7. 10枚すべてのカードを消すとゲームクリアです。\n\n" +

        "ここまで読んでいただきありがとうございます。\n\n" +
        "では、開始ボタンを押して遊んでみてください。\n" +
        "(この説明画面をもう一度タップすると説明画面が消えます。)"
    }
    
    // テキストビュータップ時
    @IBAction func tvToTapGesture(_ sender: UITapGestureRecognizer) {
        
        OriginalAnime.playDiscriptionClosed()
        ivLogo.alpha = 1.0
        btnStart.alpha = 1.0
        btnDiscription.alpha = 1.0
        tvDiscription.alpha = 0
        tvDiscription.text = ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
