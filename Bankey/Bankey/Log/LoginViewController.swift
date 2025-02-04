//
//  ViewController.swift
//  Bankey
//
//  Created by Harun Gunes on 04/05/2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
  func didLogin()
}

class LoginViewController: UIViewController {
  
  let loginView = LoginView()
  let signInButton = UIButton()
  let errorMessageLabel = UILabel()
  let primaryTitleLabel = UILabel()
  let secondaryTitleLabel = UILabel()
  let stackView = UIStackView()
  
  weak var delegate: LoginViewControllerDelegate?
  
  var username: String? {
    return loginView.usernameTextField.text
  }
  
  var password: String? {
    return loginView.passwordTextField.text
  }
  
  var leadingEdgeOnScreen: CGFloat = 16
  var leadingEdgeOffScreen: CGFloat = -1000
  
  var stackViewLeadingAnchor: NSLayoutConstraint?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    style()
    layout()
    configureStackView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    signInButton.configuration?.showsActivityIndicator = false
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loginView.passwordTextField.text = ""
  }
}

extension LoginViewController {
  
  private func style() {
    view.backgroundColor = .systemBackground
    
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    signInButton.configuration = .filled()
    signInButton.configuration?.imagePadding = 8 // for indicator spacing
    signInButton.setTitle("Sign In", for: [])
    signInButton.addTarget(self, action: #selector(signIn), for: .primaryActionTriggered)
    
    errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
    errorMessageLabel.textAlignment = .center
    errorMessageLabel.textColor = .systemRed
    errorMessageLabel.numberOfLines = 0
    errorMessageLabel.isHidden = true
    
    primaryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    primaryTitleLabel.textAlignment = .center
    primaryTitleLabel.text = "Bankey"
    primaryTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
    
    secondaryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    secondaryTitleLabel.textAlignment = .center
    secondaryTitleLabel.text = "Your premium source for all the things in banking!"
    secondaryTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
    secondaryTitleLabel.numberOfLines = 0
  }
  
  
  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .equalSpacing
    stackView.addArrangedSubview(primaryTitleLabel)
    stackView.addArrangedSubview(secondaryTitleLabel)
    stackView.alpha = 0
  }
  
  
  private func layout() {
    view.addSubview(loginView)
    view.addSubview(signInButton)
    view.addSubview(errorMessageLabel)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      loginView.topAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 3),
      loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
      view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1),
      
      
      signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
      signInButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
      view.trailingAnchor.constraint(equalToSystemSpacingAfter: signInButton.trailingAnchor, multiplier: 1),
      
      errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
      errorMessageLabel.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
      errorMessageLabel.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
    ])
    
    stackViewLeadingAnchor = stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
    stackViewLeadingAnchor!.isActive = true
  }
}

extension LoginViewController {
  @objc func signIn() {
    errorMessageLabel.isHidden = true
    signInButton.configuration?.showsActivityIndicator = true
    delegate?.didLogin()
    
    
//    login()
    
  }
  
//  private func login() {
//    guard let username = username, let password = password else {
//      assertionFailure("🔴 Username / password should never be nil!")
//      return
//    }
//
//    if username.isEmpty || password.isEmpty {
//      configureView(withMessage: "Username / password cannot be blank!")
//    }
//
//    if username == "Harun" && password == "gunes" {
//      signInButton.configuration?.showsActivityIndicator = true
//      delegate?.didLogin()
//    } else {
//      configureView(withMessage: "Incorrect username / password")
//      shakeButton()
//    }
//
//  }
  
  
  func configureView(withMessage message: String) {
    errorMessageLabel.isHidden = false
    errorMessageLabel.text = message
  }
  
  private func shakeButton() {
    let animation = CAKeyframeAnimation()
    animation.keyPath = "position.x"
    animation.values = [0, 10, -10, 10, 0]
    animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
    animation.duration = 0.4
    
    animation.isAdditive = true
    signInButton.layer.add(animation, forKey: "shake")
  }
  
}

extension LoginViewController {
  private func animate() {
    let animator1 = UIViewPropertyAnimator(duration: 0.75, curve: .easeInOut) {
      self.stackViewLeadingAnchor?.constant = self.leadingEdgeOnScreen
      
      self.view.layoutIfNeeded()
    }
    animator1.startAnimation()
    
    let animator2 = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut) {
      self.stackView.alpha = 1
    }
    animator2.startAnimation()
  }
  
}
