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
    
    // Décodage personnalisé : convertit le HTML ET "True"/"False" en Bool
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // 1. Décode le titre brut (avec HTML)
        let rawTitle = try container.decode(String.self, forKey: .title)

        // 2. Décode la réponse brute (String "True" ou "False")
        let correctAnswerString = try container.decode(String.self, forKey: .isCorrect)

        // 3. Applique le décodage HTML au titre
        self.title = String.fromHTML(rawTitle) ?? rawTitle
        
        // 4. Convertit "True" en Bool
        self.isCorrect = correctAnswerString == "True"
    }
}

// Structure pour décoder la réponse complète de l'API
struct TriviaResponse: Codable {
    let results: [Question]
}

extension String {
    static func fromHTML(_ html: String) -> String? {
        guard let data = html.data(using: .utf8) else { return nil }
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else { return nil }
        return attributedString.string
    }
}
