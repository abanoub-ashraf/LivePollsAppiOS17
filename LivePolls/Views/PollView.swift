//
//  PollView.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 01/09/2023.
//

import SwiftUI

struct PollView: View {
    var vm: PollViewModel
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("Poll ID")
                    
                    Text(vm.pollId)
                        .font(.caption)
                        .textSelection(.enabled)
                }
                
                HStack {
                    Text("Updated At")
                    
                    Spacer()
                    
                    if let updatedAt = vm.poll?.updatedAt {
                        Text(updatedAt, style: .time)
                    }
                }
                
                HStack {
                    Text("Total Vote Count")
                    
                    Spacer()
                    
                    if let totalCount = vm.poll?.totalCount {
                        Text(String(totalCount))
                    }
                }
            }
            
            if let options = vm.poll?.options {
                Section {
                    PollChartView(options: options)
                        .frame(height: 200)
                        .padding(.vertical)
                }
                
                Section("Vote") {
                    ForEach(options) { option in
                        Button {
                            vm.incrementOption(option)
                        } label: {
                            HStack {
                                Text("+1")
                                
                                Text(option.name)
                                
                                Spacer()
                                
                                Text(String(option.count))
                            }
                        }

                    }
                }
            }
        }
        .navigationTitle(vm.poll?.name ?? "")
        .onAppear {
            vm.listenToPoll()
        }
    }
}

#Preview {
    NavigationStack {
        PollView(
            vm: .init(pollId: "C5C5A514-64D4-44C4-8CED-6397969CACF1")
        )
    }
}
