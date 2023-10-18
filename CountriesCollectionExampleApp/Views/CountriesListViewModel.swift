//
//  RubriqueViewModel.swift
//  CountriesCollectionExampleApp
//
//  Created by Denys on 17.10.2023.
//

import Foundation
import Combine

final class CountriesListViewModel: ObservableObject {
    @Published var sections: [Rubrique] = [
        Rubrique(title: "Ukraine", isSelected: false),
        Rubrique(title: "France", isSelected: true),
        Rubrique(title: "Poland", isSelected: false),
        Rubrique(title: "Czesh Republic", isSelected: false),
        Rubrique(title: "Slovakia", isSelected: false),
    ]
    private var originalRubriques = [Rubrique]()
    
    init() {
        self.originalRubriques = sections
    }
    
    func resetToOriginal() {
        sections = originalRubriques
    }
}
