//
//  CommentTableViewCell.swift
//  SEDaily-IOS
//
//  Created by jason on 2/2/18.
//  Copyright © 2018 Koala Tea. All rights reserved.
//

import UIKit

protocol  CommentReplyTableViewCellDelegate: class {
    func replyToCommentPressed(comment: Comment)
}

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: CommentReplyTableViewCellDelegate?
    var hideReplyCell = false {
        didSet {
            replyButton.isHidden = hideReplyCell
        }
    }
    
    var comment: Comment? {
        didSet {
            let prettyDate = comment?.getDatedCreatedPretty()
            dateLabel.text = prettyDate
            contentLabel.attributedText = comment?.commentBody()
            usernameLabel.text = comment?.author.displayName()
            
            if let imageString = comment?.author.avatarUrl {
                let url = URL(string: imageString)
                avatarImage.kf.setImage(with: url)
            } else {
                avatarImage.image = UIImage(named: "profile-icon-9")
            }
            if comment?.deleted == true {
                contentLabel.textColor = UIColor.lightGray
            } else {
                contentLabel.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func replyButtonPressed(_ sender: UIButton) {
        if let comment = comment {
            delegate?.replyToCommentPressed(comment: comment)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
