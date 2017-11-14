//
//  UsersListViewController.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import UIKit

fileprivate let model = try! AppDelegate.assembly.resolve() as UsersModel
fileprivate let manager = try! AppDelegate.assembly.resolve() as Manager
class UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let control = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        configTableView()
        configPullToRefresh()
        model.delegate = self
        manager.delegate = self
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configs
    func configTableView() {
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.lightBlue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: String(describing: UserTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
    }
    
    func configPullToRefresh() {
        control.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        control.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            tableView?.refreshControl = control
        } else {
            tableView?.addSubview(control)
        }
    }
    
    func initData() {
        model.loadUsersList()
    }
    
    @objc func refresh() {
        initData()
    }
    
    // MARK: - Navigation
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        manager.user = User()
        if let detailVC = DetailViewController.storyboardInstance() {
            let navVC = UINavigationController(rootViewController: detailVC)
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.done, target: detailVC, action: #selector(detailVC.dismissVC))
            present(navVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.config(with: model.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manager.user = model.users[indexPath.row]
        if let detailVC = DetailViewController.storyboardInstance() {
            detailVC.isEdit = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UsersModel Delegate
extension UsersListViewController: UsersModelDelegate {
    func didUpdateUsers(model: UsersModel) {
        tableView.reloadData()
        control.endRefreshing()
    }
}

// MARK: - Manager Delegate
extension UsersListViewController: ManagerDelegate {
    func needUpdateData() {
        initData()
        tableView.reloadData()
    }
}
