//
//  HomeView.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 31/08/2023.
//

import SwiftUI

struct HomeView: View {
    @Bindable var vm = HomeViewModel()

    var body: some View {
        List {
            livePollsSection
            
            createPollsSection
            
            addOptionsSection
        }
        .alert("Error", isPresented: .constant(vm.error != nil)) {
            
        } message: {
            Text(vm.error ?? "an error occured")
        }
        .sheet(item: $vm.modalPollId) { id in
            NavigationStack {
                PollView(vm: .init(pollId: id))
            }
        }
        .navigationTitle("Latest Live Polls")
        .onAppear {
            vm.listenToLivePolls()
        }
    }
    
    var livePollsSection: some View {
        Section {
            DisclosureGroup("Active Polls") {
                ForEach(vm.polls) { poll in
                    VStack {
                        HStack {
                            Text(poll.name)
                            
                            Spacer()
                            
                            Image(systemName: "chart.bar.xaxis")
                            
                            Text(String(poll.totalCount))
                            
                            if let updatedAt = poll.updatedAt {
                                Image(systemName: "clock.fill")
                                
                                Text(updatedAt, style: .time)
                            }
                        }
                        
                        PollChartView(options: poll.options)
                            .frame(height: 160)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.vm.modalPollId = poll.id
                    }
                }
            }
        }
    }
    
    var createPollsSection: some View {
        Section {
            TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("Submit") {
                Task {
                    await vm.createNewPoll()
                }
            }
            .disabled(vm.isCreateNewPollButtonDisabled)
            
            if vm.isLoading {
                ProgressView()
            }
        } header: {
            Text("Create a Poll")
        } footer: {
            Text("Enter poll name & add 2-4 options to submit")
        }
    }
    
    var addOptionsSection: some View {
        Section("Options") {
            TextField("Enter option name", text: $vm.newOptionName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("+ Add Option") {
                vm.addOption()
            }
            .disabled(vm.isAddOptionsButtonDisabled)
            
            ForEach(vm.newPollOptions) {
                Text($0)
            }
            .onDelete { indexSet in
                vm.newPollOptions.remove(atOffsets: indexSet)
            }
        }
    }
}

extension String: Identifiable {
    public var id: Self { self }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
