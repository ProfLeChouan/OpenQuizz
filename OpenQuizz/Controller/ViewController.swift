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

        let balhamFileName = Bundle.main.path(
            forResource: "Balham",
            ofType: "otf"
        )
        print(balhamFileName ?? "Fichier de police pas trouvé")

        let fontValue =
            Bundle.main.object(forInfoDictionaryKey: "UIAppFonts") as? [String]
        print(fontValue ?? "Clef UIAppFonts pas trouvée")

        // Personnaliser le bouton "New Game" (Tag = 42)
        if let button = view.viewWithTag(42) as? UIButton {
            button.titleLabel?.font = UIFont(name: "Balham", size: 15)
        }

        NotificationCenter.default.addObserver(
            forName: .questionsLoaded,
            object: nil,
            queue: .main
        ) { notification in
            print("Notification questionsLoaded reçue !")
            self.questionsLoaded()
        }

        startNewGame()  // On lance une partie tout de suite

        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(dragQuestionView(_:))
        )
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
        let translation = gesture.translation(in: questionView)

        let translationTransform = CGAffineTransform(
            translationX: translation.x,
            y: translation.y
        )

        let translationPercent =
            translation.x / (UIScreen.main.bounds.width / 2)
        let rotationAngle = (CGFloat.pi / 3) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)

        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform

        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }

    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }

        scoreLabel.text = "\(game.score) / 10"

        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(
                translationX: screenWidth,
                y: 0
            )
        } else {
            translationTransform = CGAffineTransform(
                translationX: -screenWidth,
                y: 0
            )
        }

        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.questionView.transform = translationTransform
            },
            completion: { (success) in
                if success {
                    self.showQuestionView()
                }
            }
        )
    }

    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        questionView.style = .standard

        switch game.state {
        case .ongoing:
            questionView.title =
                game.currentQuestion?.title ?? "No question title"
        case .over:
            questionView.title = "Game Over"
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.questionView.transform = .identity
            },
            completion: nil
        )
    }

    func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title =
            game.currentQuestion?.title ?? "Pas de question initiale"
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
