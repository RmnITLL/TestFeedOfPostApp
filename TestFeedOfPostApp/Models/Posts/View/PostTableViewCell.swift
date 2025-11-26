//
//  PostTableViewCell.swift
//  TestFeedOfPostApp
//


import UIKit

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            bodyLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with post: PostEntity) {
        titleLabel.text = post.title
        bodyLabel.text = post.body

        if let avatarURLString = post.avatarURL, let avatarURL = URL(string: avatarURLString) {
            loadImage(from: avatarURL)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }.resume()
    }
}
