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

    // Méthode async/await pour récupérer les questions
    func fetchQuestions() async throws -> [Question] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try parse(data: data)
    }

    // Parse avec gestion des erreurs
    private func parse(data: Data?) throws -> [Question] {
        guard let data = data else {
            throw NSError(domain: "QuestionManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])
        }

        do {
            let response = try JSONDecoder().decode(TriviaResponse.self, from: data)
            return response.results
        } catch {
            throw error
        }
    }
}
	
