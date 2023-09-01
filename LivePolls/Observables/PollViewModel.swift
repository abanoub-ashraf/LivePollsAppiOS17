//
//  PollViewModel.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 01/09/2023.
//

import SwiftUI
import FirebaseFirestore
import Foundation
import Observation
import ActivityKit

@Observable
class PollViewModel {
    let db = Firestore.firestore()
    
    let pollId: String
    var poll: Poll? = nil
    
    var activity: Activity<LivePollsWidgetAttributes>?
    
    init(pollId: String, poll: Poll? = nil) {
        self.pollId = pollId
        self.poll = poll
    }
    
    @MainActor
    func listenToPoll() {
        db.document("polls/\(pollId)")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else { return }
                
                do {
                    let poll = try snapshot.data(as: Poll.self)
                    
                    withAnimation {
                        self.poll = poll
                    }
                    
                    self.startActivityIfNeeded()
                } catch {
                    print("Failed to fetch poll")
                }
            }
    }
    
    func incrementOption(_ option: Option) {
        guard let index = poll?.options.firstIndex(where: { $0.id == option.id }) else { return }
        
        db.document("polls/\(pollId)")
            .updateData([
                "totalCount": FieldValue.increment(Int64(1)),
                "option\(index).count": FieldValue.increment(Int64(1)),
                "lastUpdatedOptionId": option.id,
                "updatedAt": FieldValue.serverTimestamp()
            ]) { error in
                print(error?.localizedDescription ?? "")
            }
    }
    
    ///
    /// start tracking the poll on the dynamic island
    ///
    func startActivityIfNeeded() {
        guard
            ///
            /// the content of this poll will show on the dynamic island
            ///
            let poll = self.poll,
            activity == nil,
            ActivityAuthorizationInfo().frequentPushesEnabled
        else { return }
        
        if let currentPollIdActivity = Activity<LivePollsWidgetAttributes>.activities.first(where: { activity in activity.attributes.pollId == pollId }) {
            ///
            /// if we have activity already strted then continue tracking the updates of that activity
            ///
            self.activity = currentPollIdActivity
        } else {
            do {
                ///
                /// if not then start new activity, get the content of the activity
                ///
                let activityAttributes = LivePollsWidgetAttributes(pollId: pollId)
                
                ///
                /// create the structure that describes the state and configuration of the Activity
                ///
                let activityContent = ActivityContent(state: poll, staleDate: Calendar.current.date(byAdding: .hour, value: 8, to: Date()))
                
                ///
                /// requests and starts the Activity
                ///
                self.activity = try Activity.request(attributes: activityAttributes, content: activityContent, pushType: .token)
                
                print("Requested a live activity \(String(describing: activity?.id))")
            } catch {
                print("Error requesting live activity \(error.localizedDescription)")
            }
        }
        
        ///
        /// observe the push token of the live activity we started for the poll
        /// and save them in a sub collection in firestores inside the poll document
        /// using the device id as document name
        ///
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        
        Task {
            guard let activity else { return }
            
            for try await token in activity.pushTokenUpdates {
                let tokenParts = token.map { data in String(format: "%02.2hhx", data) }
                
                let token = tokenParts.joined()
                
                print("Live activity token updated: \(token)")
                
                do {
                    try await db.collection("polls/\(pollId)/push_tokens")
                        .document(deviceId)
                        .setData(["token": token])
                } catch {
                    print("failed to update token: \(error.localizedDescription)")
                }
            }
        }
    }
}
