//
//  CardPaymentViewController.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 15/03/22.
//

import UIKit

@IBDesignable open class CardPaymentViewController: UIViewController {

    //MARK: - Outlets
    @IBInspectable public var scrollView = UIScrollView()
    @IBInspectable public var viewScrolling = UIView()
    @IBInspectable public var cardPaumentView = cardPaymentView()
    @IBInspectable public var activityIndicator = UIActivityIndicatorView()
    
    //MARK: - Properties
    
    var _model: CardPaymentViewModel = CardPaymentViewModel.shared
    
    /// The navigationTitle  set title in cardPaymentViewController navigationBar Title
    @IBInspectable public var NavigationTitle = ""{
        didSet{
            self.title = NavigationTitle
        }
    }
    
    /// The email set in card payment model for use apikey get
    @IBInspectable public var email: String? = nil{ didSet {
        if let email = email,email.isValidEmail(){
            _model.cardPaymentmodel.email = email
        }
        else{
            _model.cardPaymentmodel.email = nil
        }
    } }
    
    /// The country set in card payment model for use payment
    @IBInspectable public var country: String? = nil{ didSet {
        if let country = country{
            _model.cardPaymentmodel.country = country
        }
        else{
            _model.cardPaymentmodel.country = nil
        }
    } }
    /// The currency set in card payment model for use payment
    @IBInspectable public var currency: String? = nil{ didSet {
        if let currency = currency{
            _model.cardPaymentmodel.currency = currency
        }
        else{
            _model.cardPaymentmodel.currency = nil
        }
    } }
    
    /// The amount set in card payment model for use payment
    @IBInspectable public var amount: Int = 0{ didSet {
        _model.cardPaymentmodel.amount = amount
    } }

    /// The endpoint set in card payment model for use payment
    @IBInspectable public var endpoint: String? = nil{ didSet {
        if let endpoint = endpoint{
            _model.cardPaymentmodel.endpoint = endpoint
        }
        else{
            _model.cardPaymentmodel.endpoint = nil
        }
    } }
    
    //MARK: - View Controller Life Cycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUIConstrain()
        cardPaumentView.cardView.addShadow(color: ColorConstant.shadowColor, radius: 5)
        _model.showLoading = {
            self.activityIndicator.startAnimating()
            if self._model.cardPaymentmodel.isEnable{
                self.cardPaumentView.inputFieldDisable(isDisable: true)
            }else{
                self.cardPaumentView.inputFieldDisable(isDisable: false)
            }
        }
        _model.hideLoading = {
            self.stopActivity()
            self.cardPaumentView.inputFieldDisable(isDisable: true)
        }
        _model.showError = { error in
            self.alertGenrate(title: "error", message:error?.localizedDescription ?? "" )
        }
    }
}

//MARK: - Methods
extension CardPaymentViewController{
    /// setup View Controller
    private func setupView(){
        _model.viewController = self
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(scrollView)
        scrollView.addSubview(viewScrolling)
        viewScrolling.addSubview(cardPaumentView)
        viewScrolling.addSubview(activityIndicator)
        self.NavigationTitle = "Payment"
        setUIConstrain()
        
    }
    

    /// set UIConstrain
    private func setUIConstrain(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        viewScrolling.translatesAutoresizingMaskIntoConstraints = false
        viewScrolling.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        viewScrolling.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        viewScrolling.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        viewScrolling.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        viewScrolling.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        cardPaumentView.translatesAutoresizingMaskIntoConstraints = false
        cardPaumentView.leadingAnchor.constraint(equalTo: viewScrolling.leadingAnchor).isActive = true
        cardPaumentView.trailingAnchor.constraint(equalTo: viewScrolling.trailingAnchor).isActive = true
        cardPaumentView.topAnchor.constraint(equalTo: viewScrolling.topAnchor).isActive = true
        cardPaumentView.bottomAnchor.constraint(equalTo: viewScrolling.bottomAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        cardPaumentView.buttonPay.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
//        cardPaumentView.buttonPay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
//        viewScrolling.heightAnchor.constraint(equalToConstant: self.view.bounds.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom).isActive = true
    }
}

//MARK: - Methods
extension CardPaymentViewController{
    
    func alertGenrate(title:String,message:String){
        if `self` == self{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { k in
                alert.removeFromParent()
            }
            alert.addAction(ok)
            `self`.present(alert, animated: true, completion: nil)
        }
    }
    func stopActivity(){
        if `self` == self{
            `self`.activityIndicator.stopAnimating()
        }
    }
}
