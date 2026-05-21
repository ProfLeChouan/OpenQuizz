//
//  ViewController.swift
//  OpenQuiz
//
//  Created by Vi	ncent Leduc on 2026-05-12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let balhamFileName = Bundle.main.path(forResource: "Balham", ofType: "otf")
        print(balhamFileName ?? "Fichier de police pas trouvé")

        let fontValue = Bundle.main.object(forInfoDictionaryKey: "UIAppFonts") as? [String]
        print(fontValue ?? "Clef UIAppFonts pas trouvée")

        NotificationCenter.default.addObserver(
                forName: .questionsLoaded,
                object: nil,
                queue: .main
            ) { notification in
                print("Notification questionsLoaded reçue !")
            }
    }
}

