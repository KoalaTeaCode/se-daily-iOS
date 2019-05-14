//
//  EpisodeViewController.swift
//  SEDaily-IOS
//
//  Created by Dawid Cedrych on 4/30/19.
//  Copyright © 2019 Altalogy. All rights reserved.
//

protocol WebViewCellDelegate {
	func updateWebViewHeight(didCalculateHeight height: CGFloat)
}
import UIKit
import WebKit
import Tags

class EpisodeViewController: UIViewController {
	
	weak var delegate: PodcastDetailViewControllerDelegate?
	private weak var audioOverlayDelegate: AudioOverlayDelegate?
	
	var loaded: Bool = false // to check if HTML content has loaded
	var webView: WKWebView = WKWebView()
	let networkService: API = API()
	
	var topics:[Topic] = [] { didSet {
		tableView.reloadData()
		}
	}
	
	var topicsStringArray: [String] {
		get {
			return topics.map{ $0.name }
		}
	}
	
	var webViewHeight: CGFloat = 600
	
	var viewModel: PodcastViewModel = PodcastViewModel() {
		willSet {
			guard newValue != self.viewModel else { return }
		}
		didSet {
			tableView.reloadData()
		}
	}
	var isPlaying = false { didSet { tableView.reloadData() }}
	var transcriptURL: String?
	var tableView = UITableView()
	
	
	required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, audioOverlayDelegate: AudioOverlayDelegate?) {
		self.audioOverlayDelegate = audioOverlayDelegate
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(tableView)
		
		networkService.getTopicsForPost(podcastId: viewModel._id, onSuccess: { [weak self] data in
			self?.topics = data
		}, onFailure: { _ in print("error")})
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(EpisodeViewController.shareTapped))
			
		tableView.snp.makeConstraints { (make) -> Void in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.right.equalToSuperview()
			make.left.equalToSuperview()
		}
		tableView.register(cellType: EpisodeHeaderCell.self)
		tableView.register(cellType: WebViewCell.self)
		tableView.register(cellType: TagsCell.self)
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 50.0
		tableView.separatorStyle = .none
		
		//tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .white
		
		self.audioOverlayDelegate?.setCurrentShowingDetailView(
			podcastViewModel: viewModel)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onDidReceiveData(_:)),
			name: .viewModelUpdated,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.willExpand(_:)),
			name: .episodeViewWillExpand,
			object: nil)
		
		
		self.getTrascriptURL()
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.isPlaying = CurrentlyPlaying.shared.getCurrentlyPlayingId() == viewModel._id
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.audioOverlayDelegate?.setCurrentShowingDetailView(
			podcastViewModel: nil)
	}
	
	deinit {
		// perform the deinitialization
		NotificationCenter.default.removeObserver(self)
	}
	
	func playButtonPressed(isPlaying: Bool) {
		
		if !isPlaying {
			self.audioOverlayDelegate?.animateOverlayIn()
			self.audioOverlayDelegate?.playAudio(podcastViewModel: viewModel)
			AskForReview.triggerEvent()
		} else {
			self.audioOverlayDelegate?.animateOverlayOut()
			self.audioOverlayDelegate?.stopAudio()
		}
		self.isPlaying = !self.isPlaying
	}
	
	@objc func shareTapped() {
		
		if let link = viewModel.postLinkURL {
			let objectsToShare = [link]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			self.present(activityVC, animated: true, completion: nil)
		}
	}
}


extension EpisodeViewController {
	private func relatedLinksButtonPressed() {
		Analytics2.relatedLinksButtonPressed(podcastId: viewModel._id)
		let relatedLinksStoryboard = UIStoryboard.init(name: "RelatedLinks", bundle: nil)
		guard let relatedLinksViewController = relatedLinksStoryboard.instantiateViewController(
			withIdentifier: "RelatedLinksViewController") as? RelatedLinksViewController else {
				return
		}
		let podcastId = viewModel._id
		relatedLinksViewController.postId = podcastId
		relatedLinksViewController.transcriptURL = transcriptURL
		self.navigationController?.pushViewController(relatedLinksViewController, animated: true)
	}
	func commentsButtonPressed() {
		Analytics2.podcastCommentsViewed(podcastId: viewModel._id)
		let commentsViewController: CommentsViewController = CommentsViewController()
		if let thread = viewModel.thread {
			commentsViewController.rootEntityId = thread._id
			self.navigationController?.pushViewController(commentsViewController, animated: true)
		}
	}
}

extension EpisodeViewController {
	func getTrascriptURL() {
		networkService.getPost(podcastId: viewModel._id, completion: { [weak self] (success, result) in
			if success {
				guard let transcriptURL = result?.transcriptURL else { return }
				self?.transcriptURL = transcriptURL
			}
		})
	}
}

extension EpisodeViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch indexPath.row {
		case 0:
			let cell: EpisodeHeaderCell = tableView.dequeueReusableCell(for: indexPath)
			cell.selectionStyle = .none
			cell.bookmarkService = BookmarkService(podcastViewModel: viewModel)
			cell.upvoteService = UpvoteService(podcastViewModel: viewModel)
			cell.downloadService = DownloadService(podcastViewModel: viewModel)
			
			cell.isPlaying = isPlaying
			cell.viewModel = viewModel
			cell.playButtonCallBack = { [weak self] isPlaying in
				self?.playButtonPressed(isPlaying: isPlaying)
			}
			cell.relatedLinksButtonCallBack = { [weak self] in
				self?.relatedLinksButtonPressed()
			}
			cell.actionView.commentShowCallback = { [weak self] in
				self?.commentsButtonPressed()
			}
			return cell
		case 1:
			let cell: TagsCell = tableView.dequeueReusableCell(for: indexPath)
			cell.tagsView.delegate = self
			cell.topics = self.topicsStringArray
			return cell
			
		default:
			let cell: WebViewCell = tableView.dequeueReusableCell(for: indexPath)
			var htmlString = HtmlHelper.getHTML(html: viewModel.encodedPodcastDescription)
			cell.webViewHeight = webViewHeight
			cell.webView.loadHTMLString(htmlString, baseURL: nil)
			cell.webView.navigationDelegate = cell
			cell.delegate = self
			return cell
		}
	}
	
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
}

extension EpisodeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}


extension EpisodeViewController: WebViewCellDelegate {
	func updateWebViewHeight(didCalculateHeight height: CGFloat) {
		if !loaded {
			webViewHeight = height
			tableView.reloadData()
			loaded = true
		} else { return }
	}
}

extension EpisodeViewController {
	@objc func onDidReceiveData(_ notification: Notification) {
		if let data = notification.userInfo as? [String: PodcastViewModel] {
			for (_, viewModel) in data {
				guard viewModel._id == self.viewModel._id else { return }
				self.viewModel = viewModel
			}
		}
	}
}


extension EpisodeViewController: TagsDelegate {
	
	// Tag Touch Action
	func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
		
	}
	
	// Last Tag Touch Action
	func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
		
	}
	
	// TagsView Change Height
	func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
		//self.tableView.reloadData()
	}
}


extension EpisodeViewController {
	@objc func willExpand(_ notification: Notification) {
		self.tableView.reloadData()
	}
}
