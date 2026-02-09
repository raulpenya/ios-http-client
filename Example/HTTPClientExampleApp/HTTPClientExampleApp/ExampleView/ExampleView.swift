//
//  ExampleView.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

import SwiftUI

struct ExampleView: View {
    
    @StateObject var viewModel: ExampleViewModel
    
    var body: some View {
        VStack {
            Button("network async") {
                viewModel.networkAsyncButtonPressed()
            }
            Button("network async with cache") {
                viewModel.networkAsyncButtonPressed()
            }
            Button("network combine") {
                viewModel.networkCombineButtonPressed()
            }
        }
        .padding()
    }
}

#Preview {
    ExampleView(viewModel: ExampleViewModel())
}
