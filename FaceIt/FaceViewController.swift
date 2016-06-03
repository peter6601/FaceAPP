//
//  ViewController.swift
//  FaceIt
//
//  Created by 丁暐哲 on 2016/5/21.
//  Copyright © 2016年 Din. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Open, eyesBrow: .Furrowed, mouth: .Smile){didSet{updataUI()}}
    
    

    @IBOutlet weak var wacthView: FaceView!{
  
        didSet{
             wacthView.addGestureRecognizer(UIPinchGestureRecognizer(target: wacthView, action: #selector(wacthView.changeScale(_:))))
            let happierSwipeGestureRegonizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappier))
            happierSwipeGestureRegonizer.direction = .Up
            wacthView.addGestureRecognizer(happierSwipeGestureRegonizer)
            updataUI()
            let saddnerSwipeGestureRegonizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappier))
           saddnerSwipeGestureRegonizer.direction = .Down
            wacthView.addGestureRecognizer(saddnerSwipeGestureRegonizer)
            
        }
    }
    @IBAction func tapEyesBrow(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyesBrow {
            case .Furrowed:expression.eyesBrow = .Normal
            case .Normal:expression.eyesBrow = .Relaxd
            case .Relaxd:expression.eyesBrow = .Furrowed
       
            }
        }
    }

    @IBAction func Tapeyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting:break
           
            }
        }
    }
    func increaseHappier(){
        expression.mouth = expression.mouth.happerMouth()
    }
    
    func decreaseHappier(){
        expression.mouth = expression.mouth.sadderMouth()
    }
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0, .Grin:0.5, .Smile:1.0, .Smirk:-0.5, .Neutal:0.0]
    private var eyeBrowTitlts = [FacialExpression.Eyesborw.Relaxd:0.5, .Normal:0.0, .Furrowed:-0.5]
    private func updataUI(){
        switch expression.eyes {
        case .Open: wacthView.eyeopen = true
        case .Closed: wacthView.eyeopen = false
        case .Squinting: wacthView.eyeopen = false
        }
        wacthView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        wacthView.eyeBrowTilt = eyeBrowTitlts[expression.eyesBrow] ?? 0.0
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

