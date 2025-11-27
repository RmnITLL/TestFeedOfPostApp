//
//  PostTableViewCell.swift
//  TestFeedOfPostApp
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.22, alpha: 1.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        label.textColor = UIColor(red: 0.38, green: 0.39, blue: 0.45, alpha: 1.0)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let postInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 0.65, green: 0.66, blue: 0.70, alpha: 1.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setTitle(" 256", for: .normal)
        button.tintColor = UIColor(red: 0.65, green: 0.66, blue: 0.70, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.setTitle(" 43", for: .normal)
        button.tintColor = UIColor(red: 0.65, green: 0.66, blue: 0.70, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let readMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Read more..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupSelectionStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubviews(
            avatarImageView,
            userInfoLabel,
            titleLabel,
            bodyLabel,
            postInfoLabel,
            likeButton,
            commentButton,
            readMoreLabel
        )

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            userInfoLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            userInfoLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            userInfoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            readMoreLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            readMoreLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            postInfoLabel.topAnchor.constraint(equalTo: readMoreLabel.bottomAnchor, constant: 12),
            postInfoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            postInfoLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            likeButton.centerYAnchor.constraint(equalTo: postInfoLabel.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -12),

            commentButton.centerYAnchor.constraint(equalTo: postInfoLabel.centerYAnchor),
            commentButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    private func setupSelectionStyle() {
        selectionStyle = .none

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 0.1)
        selectedView.layer.cornerRadius = 16
        selectedBackgroundView = selectedView
    }

    func configure(with post: PostEntity) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        userInfoLabel.text = "User #\(post.userId)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        postInfoLabel.text = "Posted on \(dateFormatter.string(from: Date()))"

        if let avatarURLString = post.avatarURL, let avatarURL = URL(string: avatarURLString) {
            loadImage(from: avatarURL)
        } else {

            let defaultAvatarURL = URL(string: "https://i.pravatar.cc/150?img=\(post.userId)")!
            loadImage(from: defaultAvatarURL)
        }

        let randomLikes = Int.random(in: 1...100)
        let randomComments = Int.random(in: 1...100)
        likeButton.setTitle(" \(randomLikes)", for: .normal)
        commentButton.setTitle(" \(randomComments)", for: .normal)
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.avatarImageView.image = UIImage(systemName: "person.circle.fill")
                    self?.avatarImageView.tintColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
                }
                return
            }

            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        titleLabel.text = nil
        bodyLabel.text = nil
        userInfoLabel.text = nil
        postInfoLabel.text = nil
    }
}
