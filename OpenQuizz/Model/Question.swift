//
//  Question.swift
//  OpenQuizz
//
//  Created by Vincent Leduc on 2026-05-14.
//

import Foundation

struct Question: Codable {
    let title: String
    let isCorrect: Bool

    // Initialiseur par défaut pour rester compatible avec le code existant
    init(title: String = "", isCorrect: Bool = false) {
        self.title = title
        self.isCorrect = isCorrect
    }

    // Clés pour mapper le JSON de l'API
    enum CodingKeys: String, CodingKey {
        case title = "question"
        case isCorrect = "correct_answer"
    }
    
    // Initialiseur personnalisé pour convertir "True"/"False" en Bool
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let title = try container.decode(String.self, forKey: .title)
            let correctAnswerString = try container.decode(String.self, forKey: .isCorrect)

            // Convertit "True" en true, "False" en false
            let isCorrect = correctAnswerString == "True"

            self.title = title
            self.isCorrect = isCorrect
        }
}

// Structure pour décoder la réponse complète de l'API
struct TriviaResponse: Codable {
    let results: [Question]
}
