//
//  ExampleViewAssembler.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

protocol ExampleViewAssembler {
    func resolve() -> ExampleView
}

extension ExampleViewAssembler {
    func resolve() -> ExampleView {
        return ExampleView(viewModel: resolve())
    }
    
    func resolve() -> ExampleViewModel {
        return ExampleViewModel()
    }
}

class ExampleViewAssemblerInjection: ExampleViewAssembler {}
