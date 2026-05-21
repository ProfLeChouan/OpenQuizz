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
    
    var scoringStrategy: (Bool) -> Int = { isCorrect in
        return isCorrect ? 1 : 0		
    }	

    func refresh() {
        print("refresh start \(self.questions)")
        score = 0
        currentIndex = 0
        state = .over		

        Task {
            do {
                let questions = try await QuestionManager.shared.fetchQuestions()
                self.questions = questions
                self.state = .ongoing
                NotificationCenter.default.post(name: .questionsLoaded, object: nil)
                print("Refesh task end \(self.questions)")
                			
                //Exercice2 - Pratique des fermetures - 1) Filtre
                print("Questions ayant un film : \(filterQuestions({ $0.title.contains("film") }))")
                
                //Exercice2 - 2) Filtre des questions correctes
                print("Questions correctes : \(filterQuestions({ $0.isCorrect }))")
                
      
                //Exercice2 - 3) Tri des questions
                print("Questions triees par titre croissant: \(sortQuestions({ $0.title < $1.title }))")
                
                //4)
                let sortedQuestionsShort = sortQuestions {
                    $0.isCorrect != $1.isCorrect ? $0.isCorrect && !$1.isCorrect : $1.title < $0.title
                }
                print("Questions triees par flag puis par titre: \(sortedQuestionsShort)")
                
                //5) strategie de score
                self.questions = filterQuestions({ $0.isCorrect })
                
                answerCurrentQuestion(with: true)
                print("Game score default strategy +1 = \(score)")
                
                // Stratégie alternative : +2 points
                scoringStrategy = { isCorrect in return isCorrect ? 2 : 0 }
                answerCurrentQuestion(with: true)
                print("Game score double strategy = \(score)")
                
                // Stratégie complexe : +1/-1
                scoringStrategy = { isCorrect in return isCorrect ? 1 : -1 }
                answerCurrentQuestion(with: false)
                print("Game score minus 1 strategy if false = \(score)")
            } catch {
                print("[Game] Refresh Erreur : \(error)")		
                self.questions = []
            }
        }
    }
    
    func answerCurrentQuestion(with answer: Bool) {
        if let question = currentQuestion {
            if (question.isCorrect && answer) || (!question.isCorrect && !answer) {
                score += scoringStrategy(true)
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
    
    func sortQuestions(_ comparator: (Question, Question) -> Bool) -> [Question] {
         // Utilisation de la méthode `sorted(by:)` de Swift, qui prend une fermeture en paramètre.
         // La fermeture `comparator` définit l'ordre de tri.
        return self.questions.sorted(by: comparator)
    }
    
    func filterQuestions(_ condition: (Question) -> Bool) -> [Question] {
        return self.questions.filter(condition)
    }

}

extension Notification.Name {
    static let questionsLoaded = Notification.Name("QuestionsLoaded")
}
