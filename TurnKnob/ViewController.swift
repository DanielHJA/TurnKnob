//
//  ViewController.swift
//  TurnKnob
//
//  Created by Daniel Hjärtström on 2017-08-12.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let knobView = KnobView(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width), maxValue: 100.0)
        knobView.center = self.view.center
        
        self.view.addSubview(knobView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

