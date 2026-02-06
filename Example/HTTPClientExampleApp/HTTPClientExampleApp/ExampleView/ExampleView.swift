//
//  ExampleView.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

import SwiftUI

struct ExampleView: View {
    
    @ObservedObject var viewModel: ExampleViewModel
    
    var body: some View {
        VStack {
            Button("network async") {
                viewModel.networkAsyncButtonPressed()
            }
            Button("network combine") {
                viewModel.networkCombineButtonPressed()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView(viewModel: ExampleViewModel())
    }
}
