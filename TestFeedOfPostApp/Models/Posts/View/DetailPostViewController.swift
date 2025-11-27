//
//  DetailPostViewController.swift
//  TestFeedOfPostApp
//

import UIKit

class DetailPostViewController: UIViewController {

    private let post: PostEntity

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        return view
    }()

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
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 3
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
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.22, alpha: 1.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.setTitle(" 43", for: .normal)
        button.tintColor = UIColor(red: 0.65, green: 0.66, blue: 0.70, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(post: PostEntity) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithPost()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        title = "Post"

        setupNavigationBar()
        setupScrollView()
        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(red: 0.16, green: 0.17, blue: 0.22, alpha: 1.0)]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Close",
                style: .plain,
                target: self,
                action: #selector(closeButtonTapped)
            )
            navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
        }
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)

        cardView.addSubviews(
            avatarImageView,
            userInfoLabel,
            titleLabel,
            bodyLabel,
            postInfoLabel,
            likeButton,
            commentButton
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),

            userInfoLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 25),
            userInfoLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            userInfoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            postInfoLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 20),
            postInfoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),

            likeButton.centerYAnchor.constraint(equalTo: postInfoLabel.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -16),

            commentButton.centerYAnchor.constraint(equalTo: postInfoLabel.centerYAnchor),
            commentButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            postInfoLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
    }

    private func configureWithPost() {
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

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

