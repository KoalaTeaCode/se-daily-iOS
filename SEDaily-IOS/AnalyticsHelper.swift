//
//  AnalyticsHelper.swift
//  SEDaily-IOS
//
//  Created by jason on 5/9/18.
//  Copyright © 2018 Koala Tea. All rights reserved.
//

import Foundation
import Firebase

class Analytics2 {
    // TODO: combine with AnswerTracker.swift
    // MARK: Page Views
    class func notificationPageViewed() {
        Analytics.logEvent("notifications_page_viewed", parameters: nil)
    }
    class func bookmarksPageViewed() {
        Analytics.logEvent("bookmarks_page_viewed", parameters: nil)
    }
    class func loginFormViewed() {
        Analytics.logEvent("login_form_viewed", parameters: nil)
    }
    class func registrationFormViewed() {
        Analytics.logEvent("registration_form_viewed", parameters: nil)
    }
    class func podcastPageViewed(podcastId: String) {
        Analytics.logEvent("podcast_episode_viewed", parameters: [
            AnalyticsParameterItemID: "id-\(podcastId)",
            AnalyticsParameterItemName: podcastId,
            AnalyticsParameterContentType: "view"
        ])
    }
    class func podcastCommentsViewed(podcastId: String) {
        Analytics.logEvent("podcast_comments_viewed", parameters: [
            AnalyticsParameterItemID: "id-\(podcastId)",
            AnalyticsParameterItemName: podcastId,
            AnalyticsParameterContentType: "view"
            ])
    }
    class func feedViewed() {
        Analytics.logEvent("feed_list_viewed", parameters: nil)
    }
    
    class func forumThreadViewed(forumThread: ForumThread) {
        Analytics.logEvent("forum_thread_viewed", parameters: [
            AnalyticsParameterItemID: "id-\(forumThread.title)",
            AnalyticsParameterItemName: forumThread.title,
            AnalyticsParameterContentType: "view"
        ])
    }
    
    class func relatedLinkSafariOpen(url: URL) {
        Analytics.logEvent("related_link_in_safari", parameters: [
            AnalyticsParameterItemID: "\(url.absoluteString)",
            AnalyticsParameterItemName: url.absoluteString,
            AnalyticsParameterContentType: "tapped"
            ])
    }
    
    class func relatedLinkViewed(url: URL) {
        Analytics.logEvent("related_link_viewed", parameters: [
            AnalyticsParameterItemID: "\(url.absoluteString)",
            AnalyticsParameterItemName: url.absoluteString,
            AnalyticsParameterContentType: "view"
            ])
    }
    
    class func newPodcastsListViewed(tabTitle: String) {
        Analytics.logEvent("podcast_new_list_viewed", parameters: [
            AnalyticsParameterItemID: "tabTitle-\(tabTitle)",
            AnalyticsParameterItemName: tabTitle,
            AnalyticsParameterContentType: "view"
        ])
    }
    class func topPodcastsListViewed(tabTitle: String) {
        Analytics.logEvent("podcast_top_list_viewed", parameters: [
            AnalyticsParameterItemID: "tabTitle-\(tabTitle)",
            AnalyticsParameterItemName: tabTitle,
            AnalyticsParameterContentType: "view"
        ])
    }
    class func recommendedPodcastsListViewed(tabTitle: String) {
        Analytics.logEvent("podcast_recommended_list_viewed", parameters: [
            AnalyticsParameterItemID: "tabTitle-\(tabTitle)",
            AnalyticsParameterItemName: tabTitle,
            AnalyticsParameterContentType: "view"
        ])
    }
    
    // MARK: Button Presses
    class func searchNavButtonPressed() {
        Analytics.logEvent("search_button_nav_pressed", parameters: nil)
    }
    class func loginNavButtonPressed() {
        Analytics.logEvent("login_button_nav_pressed", parameters: nil)
    }
    class func logoutNavButtonPressed() {
        Analytics.logEvent("logout_button_nav_pressed", parameters: nil)
    }
    class func cancelRegistrationButtonPressed() {
        Analytics.logEvent("cancel_registration_button_nav_pressed", parameters: nil)
    }
    class func relatedLinksButtonPressed(podcastId: String) {
        Analytics.logEvent("related_links_button_pressed", parameters: [
            AnalyticsParameterItemID: "id-\(podcastId)",
            AnalyticsParameterItemName: podcastId,
            AnalyticsParameterContentType: "view"
        ])
    }
    class func bookmarkButtonPressed(podcastId: String) {
        Analytics.logEvent("bookmark_button_pressed", parameters: [
            AnalyticsParameterItemID: "id-\(podcastId)",
            AnalyticsParameterItemName: podcastId,
            AnalyticsParameterContentType: "view"
            ])
    }
    class func refreshMyBookmarksPressed() {
        Analytics.logEvent("bookmark_refresh_button_pressed", parameters: nil)

    }
}
