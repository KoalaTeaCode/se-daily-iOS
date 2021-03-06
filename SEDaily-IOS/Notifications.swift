//
//  Notifications.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 7/24/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

extension Notification.Name {
	static let loginChanged = Notification.Name("loginChanged")
	static let viewModelUpdated = Notification.Name("viewModelUpdated")
	static let episodeViewWillExpand = Notification.Name("episodeViewWillExpand")
	static let reloadEpisodeView = Notification.Name("reloadEpisodeView")
}
