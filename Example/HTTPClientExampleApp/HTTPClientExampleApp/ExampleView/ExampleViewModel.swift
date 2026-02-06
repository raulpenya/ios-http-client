//
//  ExampleViewModel.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

import Combine

@MainActor
final class ExampleViewModel: ObservableObject {
    private let datasource = ExampleDataSource()
    private var cancellableSet: Set<AnyCancellable> = []
    
    func networkAsyncButtonPressed() {
        Task {
            do {
                let persons = try await datasource.getAllPersons()
                print(persons)
            } catch {
                print(error)
            }
        }
    }
    
    func networkCombineButtonPressed() {
        datasource.getAllPersons().sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("networkCombineButtonPressed :: publisher finished")
            }
        } receiveValue: { persons in
            print(persons)
        }.store(in: &cancellableSet)
    }
}
