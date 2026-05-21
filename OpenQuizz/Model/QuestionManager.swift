//
//  QuestionManager.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 15/06/2017.
//  Copyright © 2017 OpenClassrooms. All rights reserved.
//

import UIKit

class QuestionManager {
    private let url = URL(string: "https://opentdb.com/api.php?amount=10&type=boolean")!

    static let shared = QuestionManager()
    private init() {}


    func get(completionHandler: @escaping ([Question]) -> ()) {
        let task = URLSession.shared.dataTask(with: self.url) { (data, response, error) in
            guard error == nil else {
                completionHandler([Question]())
                return
            }
            DispatchQueue.main.async {
                completionHandler(self.parse(data: data))
            }
        }
        task.resume()
    }

    private func parse(data: Data?) -> [Question] {
        guard let data = data else {
            return []
        }

        do {
            // 1. Décode la réponse JSON en TriviaResponse
            let response = try JSONDecoder().decode(TriviaResponse.self, from: data)

            // 2. Crée un tableau vide pour stocker les questions décodées
            var decodedQuestions = [Question]()

            // 3. Parcourt chaque question dans response.results
            for question in response.results {
                
                // 4. Applique le décodage HTML au titre
                let decodedTitle = String(htmlEncodedString: question.title) ?? question.title

                // 5. Crée une nouvelle Question avec le titre décodé
                let newQuestion = Question(title: decodedTitle, isCorrect: question.isCorrect)

                // 6. Ajoute la question au tableau
                decodedQuestions.append(newQuestion)
            }

            // 7. Retourne le tableau de questions
            return decodedQuestions

        } catch {
            print("Erreur de décodage : \(error)")
            return []
        }
    }
}


extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }
    
}
