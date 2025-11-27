//
//  PostsViewController.swift
//  TestFeedOfPostApp
//

import UIKit

class PostsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        title = "TestFeedOfPostApp"

        setupTableView()
        setupActivityIndicator()
        setupTableViewFooter()
        setupRefreshControl()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.16, green: 0.17, blue: 0.22, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(red: 0.16, green: 0.17, blue: 0.22, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationController?.navigationBar.tintColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
    }

    private func setupTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.postCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableViewFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        footerView.backgroundColor = .clear

        loadMoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadMoreIndicator.color = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0)
        footerView.addSubview(loadMoreIndicator)

        noMorePostsLabel.translatesAutoresizingMaskIntoConstraints = false
        noMorePostsLabel.text = "Больше постов нет"
        noMorePostsLabel.textColor = UIColor(red: 0.65, green: 0.66, blue: 0.70, alpha: 1.0)
        noMorePostsLabel.textAlignment = .center
        noMorePostsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let post = viewModel.post(at: indexPath.row) else { return }

        let detailVC = DetailPostViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.numberOfPosts - 1
        if indexPath.row >= lastRowIndex - 2 {
            loadMoreIndicator.startAnimating()
            viewModel.loadNextPage()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
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

            if self.viewModel.numberOfPosts == 0 {
                self.showError(error)
            }
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
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showEndOfPostsAlert() {
        let alert = UIAlertController(
            title: "Больше постов нет",
            message: "Вы просмотрели все доступные посты",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
