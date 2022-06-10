//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Harun Gunes on 22/05/2022.
//

import UIKit

class AccountSummaryViewController: UIViewController {
  
  var profile: Profile?
  
//  var headerViewModel = AccountSummaryHeaderView.ViewModel(name: "", greeting: "Welcome", date: Date())
  
  var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
  var header = AccountSummaryHeaderView(frame: .zero)
  var tableView = UITableView()
  
  lazy var logoutButton: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    barButtonItem.tintColor = .label
    return barButtonItem
  }()
  
  @objc func logoutTapped() {
    NotificationCenter.default.post(name: .logout, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

extension AccountSummaryViewController {
  private func setup() {
    setupTableView()
    setupTableHeaderView()
    //    fetchAccounts()
    fetchDataAndLoadViews()
    
    navigationItem.rightBarButtonItem = logoutButton
  }
  
  private func setupTableView() {
    tableView.backgroundColor = appColor
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
    tableView.rowHeight = AccountSummaryCell.rowHeight
    tableView.tableFooterView = UIView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  
  private func setupTableHeaderView() {
    var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    size.width = UIScreen.main.bounds.width
    header.frame.size = size
    
    tableView.tableHeaderView = header
  }
}

extension AccountSummaryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
    let account = accountCellViewModels[indexPath.row]
    cell.configure(with: account)
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return accountCellViewModels.count
  }
}

extension AccountSummaryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension AccountSummaryViewController {
  func fetchAccounts() {
    let savings = AccountSummaryCell.ViewModel(accountType: .Banking,
                                               accountName: "Basic Savings",
                                               balance: 929466.23)
    let chequing = AccountSummaryCell.ViewModel(accountType: .Banking,
                                                accountName: "No-Fee All-In Chequing",
                                                balance: 17562.44)
    let visa = AccountSummaryCell.ViewModel(accountType: .CreditCard,
                                            accountName: "Visa Avion Card",
                                            balance: 412.83)
    let masterCard = AccountSummaryCell.ViewModel(accountType: .CreditCard,
                                                  accountName: "Student Mastercard",
                                                  balance: 50.83)
    let investment1 = AccountSummaryCell.ViewModel(accountType: .Investment,
                                                   accountName: "Tax-Free Saver",
                                                   balance: 2000.00)
    let investment2 = AccountSummaryCell.ViewModel(accountType: .Investment,
                                                   accountName: "Growth Fund",
                                                   balance: 15000.00)
    
    accountCellViewModels.append(savings)
    accountCellViewModels.append(chequing)
    accountCellViewModels.append(visa)
    accountCellViewModels.append(masterCard)
    accountCellViewModels.append(investment1)
    accountCellViewModels.append(investment2)
  }
}

// MARK: - Networking
extension AccountSummaryViewController {
  private func fetchDataAndLoadViews() {
    
    fetchProfile(forUserId: "1") { result in
      switch result {
      case .success(let profile):
        self.profile = profile
        self.configureTableHeaderView(with: profile)
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    fetchAccounts()
  }
  
  private func configureTableHeaderView(with profile: Profile) {
    let vm = AccountSummaryHeaderView.ViewModel(name: profile.firstName, greeting: "Welcome", date: Date())
    header.configureViewModel(viewModel: vm)
  }
}
