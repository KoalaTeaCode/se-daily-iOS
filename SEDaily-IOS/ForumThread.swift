//
//  ForumThread.swift
//  SEDaily-IOS
//
//  Created by jason on 4/24/18.
//  Copyright © 2018 Koala Tea. All rights reserved.
//

import Foundation
import SwiftMoment

public struct ForumThread: BaseFeedItem {
    var _id: String
    let title: String
    let content: String
    let author: Author
    let commentsCount: Int
    let dateCreated: String
    let dateLastAcitiy: String // An annoying bug that will require database migrations + miner update
    var score: Int = 0
    let deleted: Bool
    var downvoted: Bool?
    var upvoted: Bool?
    let podcastEpisode: PodcastLite?
}

extension ForumThread {
    func getPrettyTitle() -> String {
        if podcastEpisode == nil {
            return self.title
        }
        // Remove "Discuss: " from threads with posts defined:
        return self.title.substring(from: self.title.index(self.title.startIndex, offsetBy: 9))
    }
    func getCommentsSummary() -> String {
        if commentsCount != 1 {
            return  "\(commentsCount) comments"
        } else {
            return  "\(commentsCount) comment"
        }
    }
    
    func getDateLastActivityPretty() -> String {
        return moment(self.dateLastAcitiy)?.fromNow() ?? ""
    }
    
    func getDatedCreatedPretty() -> String {
        return moment(self.dateCreated)?.fromNow() ?? ""
    }
}
