//
//  Game.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 13/06/2017.
//  Copyright © 2017 OpenClassrooms. All rights reserved.
//

import Foundation

class Game {
    var score = 0

    private var questions = [Question]()
    private var currentIndex = 0

    var state: State = .ongoing

    enum State {
        case ongoing, over
    }
    


    var currentQuestion: Question? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }
    
    func refresh() {
        print("refresh start \(self.questions)")
        score = 0
        currentIndex = 0
        state = .over

        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            NotificationCenter.default.post(name: .questionsLoaded, object: nil)
            print("fermeture end \(self.questions)")
        }
        print("refresh end \(self.questions)")	
    }

    func answerCurrentQuestion(with answer: Bool) {
        if let question = currentQuestion {
            if (question.isCorrect && answer) || (!question.isCorrect && !answer) {
                score += 1
            }
            goToNextQuestion()
        }

    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }
}

extension Notification.Name {
    static let questionsLoaded = Notification.Name("QuestionsLoaded")
}
