//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Alamofire
import AVKit
import AVFoundation

final class  LoginViewController: BaseViewController
{
    private var isKeyboard = false
    
    private var keyboardHeight: CGFloat = 0
    
    var bg: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "login_bg")
        return i
    }()
    
    var logo: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "login_logo")
        return i
    }()
    
    var login: UITextField = {
        var t = UITextField()
        t.font = UIFont.systemFont(ofSize: 18)
        t.placeholder = "Login"
        t.backgroundColor = .clear
        t.textColor = .white
        t.attributedPlaceholder = NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.35)])
        return t
    }()
    
    var password: UITextField = {
        var t = UITextField()
        t.isSecureTextEntry = true
        t.font = UIFont.systemFont(ofSize: 18)
        t.placeholder = "Password"        
        t.backgroundColor = .clear
        t.textColor = .white
        t.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.35)])
        return t
    }()
    
    var buttonLogin: UIButton = {
        var b = UIButton()
//        b.backgroundColor = .red
        b.setTitle("LOG IN", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return b
    }()
    
    var loginTitle: UILabel = {
        var l = UILabel()
        l.text = "e-mail"
        l.numberOfLines = 0
        l.sizeToFit()
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 10)
        return l
    }()
    
    var passwordTitle: UILabel = {
        var l = UILabel()
        l.text = "password"
        l.numberOfLines = 0
        l.sizeToFit()
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 10)
        return l
    }()
    
    var sep1: UIView = {
        var s = UIView()
        s.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return s
    }()
    
    var sep2: UIView = {
        var s = UIView()
        s.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return s
    }()
    
    var buttonPwdHide: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "login_pwd_hide_off"), for: .normal)
        return b
    }()
    
    var testButton: UIButton!
    
    // MARK: - Public properties -
    var presenter: LoginPresenterProtocol!

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
//        Logger.log("\(type(of: self))")
        
        super.viewDidLoad()
        
        //--- check if logon
        
        print("*** LoginViewController viewDidLoad 1")
        
        if(self.presenter.IsLogon())
        {
            print("*** LoginViewController viewDidLoad 2")

            self.presenter.refreshToken {
                print("*** LoginViewController viewDidLoad 3")

                NotificationCenter.default.post(name: Constants.Notify.UserUid, object: nil)

                self.presenter.switchToMap()
            } completitionWithError: { error in
                print("*** LoginViewController viewDidLoad 4")
                self.setupView()
            }
        }
        else
        {
            setupView()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification)
    {
//        print("*** keyboardWillShow isKeyboard \(isKeyboard)")

        if(isKeyboard)
        {
            return
        }

        DispatchQueue.main.async(execute: {

            if let userInfo = (sender as NSNotification).userInfo
            {
                self.isKeyboard = true

                self.keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).size.height

                let offset: CGFloat = self.keyboardHeight * -1

                UIView.animate(withDuration: 0.3) {
                    self.view.setY(offset)
                }

            }
        })
    }

    @objc func keyboardWillHide(_ sender: NSNotification)
    {
        DispatchQueue.main.async(execute: {
            self.isKeyboard = false
            
            self.view.setY(0)
        })
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }

//    // MARK: - Constraints -
//    override func updateViewConstraints()
//    {
//        if (!didSetupConstraints)
//        {
//
//                        
//            didSetupConstraints = true
//        }
//        super.updateViewConstraints()
//    }

    // MARK: - Methdos -
    func setupView()
    {
//        view.setNeedsUpdateConstraints()

        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(bg)
        
        self.view.addSubview(logo)
        
        self.view.addSubview(login)
        
        self.view.addSubview(password)
        
        self.view.addSubview(buttonLogin)
        
        self.view.addSubview(loginTitle)
        
        self.view.addSubview(passwordTitle)
        
        self.view.addSubview(sep1)
        
        self.view.addSubview(sep2)
        
        self.view.addSubview(buttonPwdHide)
        
        
//        testButton = UIButton()
//        testButton.backgroundColor = .blue
//        testButton.setSize(100, 100)
//        testButton.setX(0)
//        testButton.setY(50)
//
//        self.view.addSubview(testButton)
//
//        testButton.addAction {
//            print("*** TEST")
//        }
        
        
        bg.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        
        logo.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        login.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().inset(36)
            make.top.equalTo(self.logo.snp.bottom)
            make.height.equalTo(40)
        }
        
        password.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().inset(36)
            make.top.equalTo(self.login.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
        
        buttonLogin.snp.makeConstraints { make in
            make.width.equalTo(182)
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(58)
        }
        
        loginTitle.snp.makeConstraints { make in
            make.left.equalTo(login.snp.left)
            make.right.equalTo(login.snp.right)
            make.bottom.equalTo(self.login.snp.top)
        }
        
        passwordTitle.snp.makeConstraints { make in
            make.left.equalTo(password.snp.left)
            make.right.equalTo(password.snp.right)
            make.bottom.equalTo(self.password.snp.top)
        }
          
        sep1.snp.makeConstraints { make in
            make.left.equalTo(login.snp.left)
            make.right.equalTo(login.snp.right)
            make.height.equalTo(1)
            make.bottom.equalTo(self.login.snp.bottom)
        }
        
        sep2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(password.snp.left)
            make.right.equalTo(password.snp.right)
            make.bottom.equalTo(self.password.snp.bottom)
        }
        
        buttonPwdHide.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(password.snp.right)
            make.centerY.equalTo(self.password.snp.centerY)
        }

        //---
        
        let creds = self.presenter.getSavedLoginPassword()
        
        if(creds.count > 1)
        {
            self.login.text = creds[0]
            self.password.text = creds[1]
        }
            
        
        buttonPwdHide.addAction {
            self.showPassword()
        }
        
        buttonLogin.addAction {
            self.actionLogin()
        }
    }
    
    @objc func test(_ sender: AnyObject)
    {
        print("*** TEST")
    }
    
    func showPassword()
    {
        print("*** showPassword")
        if(password.isSecureTextEntry)
        {
            buttonPwdHide.setImage(UIImage(named: "login_pwd_hide_on"), for: .normal)
            
            password.isSecureTextEntry = false
        }
        else
        {
            buttonPwdHide.setImage(UIImage(named: "login_pwd_hide_off"), for: .normal)
            
            password.isSecureTextEntry = true
        }
    }
    
    func actionLogin()
    {
        print("*** actionLogin")
        
        self.view.endEditing(true)
        
        self.buttonLogin.isEnabled = false
        
        var isNext = true
        
        if(login.text!.isEmpty)
        {
            isNext = false
        }
        
        if(password.text!.isEmpty)
        {
            isNext = false
        }
        
        if(isNext)
        {
            self.presenter.login(email: login.text!, password: password.text!) {
                self.presenter.switchToMap()
            } completitionWithError: { error in
                
            }
        }
        else
        {
            self.buttonLogin.isEnabled = true
        }
    }

}

// MARK: - Extensions -
extension LoginViewController: LoginViewProtocol
{

}
