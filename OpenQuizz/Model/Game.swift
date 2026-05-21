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
    


    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    func refresh_() {
        print("refresh start \(self.questions)")
        score = 0
        currentIndex = 0
        state = .over

        QuestionManager.shared.get(completionHandler: receiveQuestions)
        print("refresh end \(self.questions)")
    }
    
    func refresh() {
        print("refresh start \(self.questions)")
        score = 0
        currentIndex = 0
        state = .over

        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            print("fermeture end \(self.questions)")
        }
        print("refresh end \(self.questions)")
    }
    
    private func receiveQuestions(_ questions: [Question]) {
        self.questions = questions
        state = .ongoing
        print("receiveQuestions end \(self.questions)")
    }

    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
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
