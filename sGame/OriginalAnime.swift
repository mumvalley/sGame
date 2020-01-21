//
//  OriginalAnime.swift
//  sGame
//
//  Created by HT-19R1108 on 2019/12/19.
//  Copyright © 2019 HT-19R1108. All rights reserved.
//
// カード揃った時にアニメーションが終わった後にnilにする ok
// カード揃わなかった時にアニメーションが終わってからイメージを変える ok

import UIKit
import AudioToolbox

class OriginalAnime: UIViewController {
    
    // MARK: - プロパティ
    
    static var ssId00: SystemSoundID = 0 // [開始]ボタン押したの音
    static var ssId01: SystemSoundID = 0 // トランプめくる音
    static var ssId02: SystemSoundID = 0 // トランプもどす音
    static var ssId03: SystemSoundID = 0 // [遊び方]ボタン押した時の音
    static var ssId04: SystemSoundID = 0 // オープニング効果音
    static var ssId05: SystemSoundID = 0 // [遊び方]を閉じる時の音
    static var ssId06: SystemSoundID = 0 // ゲームオーバー時の音
    static var ssId07: SystemSoundID = 0 // ゲームクリア時の音
    static var ssId08: SystemSoundID = 0 // シャッフル時の音
    static var ssId09: SystemSoundID = 0 // 揃った時の音

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    // MARK: - SoundEffectイニシャライザ
    // 　効果音初期化処理
    static func initSoundEffect() {
        
        let bnd = Bundle.main
        let url00 = bnd.url(
            forResource: "drum_japanese",
            withExtension: "mp3")
        let url01 = bnd.url(
            forResource: "tramp_hiku",
            withExtension: "mp3")
        let url02 = bnd.url(
            forResource: "tramp_dasu",
            withExtension: "mp3")
        let url03 = bnd.url(
            forResource: "water_drop2",
            withExtension: "mp3")
        let url04 = bnd.url(
            forResource: "erhu01",
            withExtension: "mp3")
        let url05 = bnd.url(
            forResource: "water-drop1",
            withExtension: "mp3")
        let url06 = bnd.url(
            forResource: "gong-solo",
            withExtension: "mp3")
        let url07 = bnd.url(
            forResource: "people_uwaa1",
            withExtension: "mp3")
        let url08 = bnd.url(
            forResource: "drip3",
            withExtension: "mp3")
        let url09 = bnd.url(
        forResource: "kotsudumi1",
        withExtension: "mp3")
        
        AudioServicesCreateSystemSoundID(
            url00! as CFURL, &ssId00)
        AudioServicesCreateSystemSoundID(
            url01! as CFURL, &ssId01)
        AudioServicesCreateSystemSoundID(
            url02! as CFURL, &ssId02)
        AudioServicesCreateSystemSoundID(
            url03! as CFURL, &ssId03)
        AudioServicesCreateSystemSoundID(
            url04! as CFURL, &ssId04)
        AudioServicesCreateSystemSoundID(
            url05! as CFURL, &ssId05)
        AudioServicesCreateSystemSoundID(
            url06! as CFURL, &ssId06)
        AudioServicesCreateSystemSoundID(
            url07! as CFURL, &ssId07)
        AudioServicesCreateSystemSoundID(
            url08! as CFURL, &ssId08)
        AudioServicesCreateSystemSoundID(
            url09! as CFURL, &ssId09)
    }
    
    // MARK: - アニメーションメソッド
    // 揃った時のアニメーション
    static func pairAnime(uiiv: UIImageView) {
        
        print(#function)

            UIView.animate(withDuration: 0.4) {
                uiiv.transform = CGAffineTransform(translationX: 0, y: -80.0)
            }
        
            UIView.transition(with: uiiv,
            duration: 0.3,
            options: [.transitionFlipFromLeft],
            animations: nil,
            completion: {(fin) in
                uiiv.image = nil
                uiiv.isUserInteractionEnabled = false
            })
        
        
    }
    
    // カードをめくるアニメーション
    static func flipCard(uiiv: UIImageView) {
        
        UIView.transition(with: uiiv,
                          duration: 0.3,
                          options: [.transitionCurlUp],
                          animations: nil,
                          completion: {(fin) in
                AudioServicesPlaySystemSound(ssId01)
        })
        
        
    }
    
    // カードを戻すアニメーション
    static func backFlipCard(uiiv: UIImageView) {
        
        UIView.transition(with: uiiv,
                          duration: 0.3,
                          options: [.transitionCurlUp],
                          animations: nil,
                          completion: {(fin) in
                            AudioServicesPlaySystemSound(ssId02)
                            uiiv.image = UIImage(named: "images")
        })
        
        
    }
    
    // [開始]ボタン押下時のアニメーション
    static func startBtn() {
        print(#function)
//        initSoundEffect()
        AudioServicesPlaySystemSound(ssId00)
        
    }
    
    // ライフラベルダメージのアニメーション
    static func lifeLabelDamage(label: UILabel,uiiv: UIImageView) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0, options: [.curveLinear, .autoreverse],
                       animations: {
                        label.center.x += 6.0
                        uiiv.center.x += 6.0
        }) { _ in
            label.center.x -= 6.0
            uiiv.center.x -= 6.0
        }
    }
    
    
    // ライフラベル回復アニメーション
    static func lifeLabelRecovery(label: UILabel, uiiv: UIImageView) {
        
        UIView.animate(
                withDuration: 0.3,
                animations: {
                    let tf01 = CGAffineTransform(translationX: 1.3, y: -1.3)
                    let tf02 = CGAffineTransform(scaleX: 1.3, y: 1.3)

                    label.transform = tf01.concatenating(tf02)
                    uiiv.transform = tf01.concatenating(tf02)
            },
                completion: { (finished) in
                    // 変換処理リセット
                    label.transform = .identity
                    uiiv.transform = .identity
            })
        
    
    }
    
    // [遊び方]ボタン押下時の表示アニメーション
    static func disctiptionTextView(uitv: UITextView) {
        
        UIView.animate(withDuration: 0.8) {
            // フェード
            uitv.alpha = 0.8
            AudioServicesPlaySystemSound(ssId03)
        
        }
    }
    
    // カードを集めるアニメーション
    static func shuffleCardAnime(uiiv: UIImageView) {

        UIView.animate(withDuration: 0.6,
                       animations: { uiiv.center = CGPoint(x: 205 , y: 654)},
                       completion: { (finished) in
                        
        })
    }
    
    // 遊び方を閉じる時の効果音
    static func playDiscriptionClosed() {
        
        AudioServicesPlaySystemSound(ssId05)
    }
    
    // オープニングの効果音
    static func opening() {
        
        AudioServicesPlaySystemSound(ssId04)
    }
    
    // タイトルボタン押下時の効果音
    static func titleSound() {
        
        AudioServicesPlaySystemSound(ssId05)
    }
    
    // 揃った時の効果音
    static func matchCardSound() {
        
        AudioServicesPlaySystemSound(ssId09)
    }
    
    // ゲームオーバー時効果音とハートアニメーション
    static func gameoverSound(uiiv: UIImageView) {
        print(#function)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.7,
                       animations: { () in
                        uiiv.transform = CGAffineTransform(translationX: 0, y: 550)
        },
                       completion: { (_) in
                        uiiv.image = UIImage(named: "heart02")})
        
        AudioServicesPlaySystemSound(ssId06)
        
    }
    
    // ゲームクリア時効果音
    static func gameClearSound() {
        
        AudioServicesPlaySystemSound(ssId07)
    }
    
    // カードを混ぜる押下時の効果音とハートの処理
    static func shuffleCardSound(uiiv: UIImageView) {
        print(#function)
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       animations: { () in
                        uiiv.frame.origin = CGPoint(x: 21, y: 25)
        },
                       completion: { (_) in
                        uiiv.image = UIImage(named: "heart01")
                        
        })
        
        AudioServicesPlaySystemSound(ssId08)
    }
    
}
