//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Vincent Leduc on 2026-05-26.
//

import UIKit

class QuestionView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @IBOutlet private var label: UILabel?
    @IBOutlet private var icon: UIImageView?
    	
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(label?.font)
     
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(label?.font)

    }

}
