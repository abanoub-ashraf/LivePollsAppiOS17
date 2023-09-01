//
//  LivePollsWidgetAttributes.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 01/09/2023.
//

import Foundation
import ActivityKit

///
/// - ActivityAttributes is The protocol you implement to describe
///   the content of a Live Activity.
///
/// - This describes the content that appears in the Live Activity.
///   Its inner type ContentState represents the dynamic content of the Live Activity.
///
struct LivePollsWidgetAttributes: ActivityAttributes {
    typealias ContentState = Poll
    
    public var pollId: String
    
    init(pollId: String) {
        self.pollId = pollId
    }
}
