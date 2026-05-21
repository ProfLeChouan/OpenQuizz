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
        guard let data = data else { return [] }

        do {
            // Décode directement en TriviaResponse → [Question]
            // Le décodage HTML est géré par l'initialiseur de Question !
            let response = try JSONDecoder().decode(TriviaResponse.self, from: data)
            return response.results
        } catch {
            print("Erreur de décodage : \(error)")
            return []
        }
    }
}
	
