//
//  ViewController.swift
//  OpenQuiz
//
//  Created by Vi	ncent Leduc on 2026-05-12.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game()

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
                self.questionsLoaded()
            }
        
        startNewGame() // On lance une partie tout de suite
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .ended, .cancelled:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        print("transformQuestionViewWith")
    }

    private func answerQuestion() {
        print("answerQuestion")
       
    }
    
    
    func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion?.title ?? "Pas de question initiale"
    }
    
    @IBAction func didTapNewGameButton() {
        print("didTapnewgameButton")
        startNewGame()
    }
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true

        questionView.title = "Loading..."
        questionView.style = .standard

        scoreLabel.text = "0 / 10"
        
        game.refresh()
    }
}

