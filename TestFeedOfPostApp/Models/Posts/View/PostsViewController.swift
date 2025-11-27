//
//  PostsViewController.swift
//  TestFeedOfPostApp
//

import UIKit

class PostsViewController: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let viewModel = PostsViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadMoreIndicator = UIActivityIndicatorView(style: .medium)
    private let noMorePostsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        loadData()
    }

    private func setupUI() {
        title = "TestFeedOfPostApp"
        view.backgroundColor = .white
        setupTableView()
        setupActivityIndicator()
        setupTableViewFooter()
        setupNavigationBar()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.postCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableViewFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))

            // Настройка индикатора загрузки
        loadMoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(loadMoreIndicator)

            // Настройка label для сообщения о конце списка
        noMorePostsLabel.translatesAutoresizingMaskIntoConstraints = false
        noMorePostsLabel.text = "Больше новостей нет"
        noMorePostsLabel.textColor = .gray
        noMorePostsLabel.textAlignment = .center
        noMorePostsLabel.font = UIFont.systemFont(ofSize: 14)
        noMorePostsLabel.isHidden = true
        footerView.addSubview(noMorePostsLabel)

        NSLayoutConstraint.activate([
            loadMoreIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            loadMoreIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

            noMorePostsLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            noMorePostsLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            noMorePostsLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            noMorePostsLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16)
        ])

        tableView.tableFooterView = footerView
        loadMoreIndicator.hidesWhenStopped = true
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupViewModel() {
        viewModel.delegate = self
    }

    private func loadData() {
        activityIndicator.startAnimating()
        viewModel.loadPosts()
    }

    @objc private func refreshData() {
        viewModel.refreshPosts()
    }

    private func showEndOfPostsAlert() {
        let alert = UIAlertController(
            title: "Больше новостей нет",
            message: "Вы просмотрели все доступные посты",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AppConstants.CellIdentifiers.postCell,
            for: indexPath
        ) as? PostTableViewCell,
              let post = viewModel.post(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: post)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Загружаем следующую страницу когда пользователь доскроллил до последних 3 ячеек
        let lastRowIndex = viewModel.numberOfPosts - 1
        if indexPath.row >= lastRowIndex - 2 {
            loadMoreIndicator.startAnimating()
            viewModel.loadNextPage()
        }
    }
}


extension PostsViewController: PostsViewModelDelegate {
    func postsDidUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.loadMoreIndicator.stopAnimating()
        }
    }

    func postsDidFailWithError(_ error: String) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.loadMoreIndicator.stopAnimating()
            self.showError(error)
        }
    }

    func didReachEndOfPosts() {
        DispatchQueue.main.async {
            self.loadMoreIndicator.stopAnimating()
            self.noMorePostsLabel.isHidden = false
            self.showEndOfPostsAlert()
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
