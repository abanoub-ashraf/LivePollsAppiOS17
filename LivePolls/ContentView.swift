//
//  ContentView.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 31/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<30) { _ in
                Section {
                    DisclosureGroup("Hellooo") {
                        ForEach(0..<30) { _ in
                            Text("sss")
                        }
                    }
                    .padding()
                    .background(.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 24)
                    .foregroundStyle(.red)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
