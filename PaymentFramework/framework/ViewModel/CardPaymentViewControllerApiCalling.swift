//
//  Extension.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 16/03/22.
//

import UIKit

public enum responce{
    case sucess
    case fail
}
class CardPaymentViewModel{
    
    //MARK: Shared Instance
    static let shared = CardPaymentViewModel()
    
    var viewController:CardPaymentViewController?
    var showError: ((Error?)->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var modelDidSet: (()->())?
    var afterPayment: ((responce)->())?
    
    var cardPaymentmodel:CardPaymentModel = CardPaymentModel.shared {
        didSet{
            guard let modelDidSet = modelDidSet else {
                return
            }
            modelDidSet()
        }
    }
    
    func start(){
        guard let showLoading = showLoading else {
            return
        }
        showLoading()
        
        self.getApiKey()
//        self.getToken()
//        self.PaymentForword()
    }
}

extension CardPaymentViewModel{
    private func getApiKey(){
        let body:[String:Any] = [StringConstant.bodyemail:cardPaymentmodel.email ?? ""]
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.REGISTER_API, body: body) { data, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIManager.ApiKey.self, from: data)
                DispatchQueue.main.async {
                    self.cardPaymentmodel.apikey = resp.apikey
                    DispatchQueue.main.async {
//                        self.presentLodingHide()
                        print(self.cardPaymentmodel.apikey)
                        self.getToken()
                    }
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
        }
    }
    
    private func getToken(){
        let body:[String:Any] = [StringConstant.bodyplaintext:[StringConstant.bodynumber:cardPaymentmodel.number,StringConstant.bodyexpiry:"\(cardPaymentmodel.expiryMonth ?? 00)/\(cardPaymentmodel.expiryYear ?? 00 )",StringConstant.bodycvv:cardPaymentmodel.cvv]]
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.TOKENIZE_API, body: body, apikey: cardPaymentmodel.apikey) { data, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIManager.Token.self, from: data)
                self.cardPaymentmodel.token = resp.token
                DispatchQueue.main.async {
//                    self.presentLodingHide()
                    self.PaymentForword()
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
        }
    }
    
    private func PaymentForword(){
        let body:[String:Any] = [StringConstant.bodyheaders:[StringConstant.bodymyauth:123],StringConstant.bodybody:[StringConstant.bodyname:cardPaymentmodel.name ?? "",StringConstant.bodycountry:cardPaymentmodel.country ?? "",StringConstant.bodycurrency:cardPaymentmodel.currency ?? "",StringConstant.bodyamount:cardPaymentmodel.amount,StringConstant.bodycc:"{{json:\(String(describing: cardPaymentmodel.token)):number}}", StringConstant.bodendpoint:cardPaymentmodel.endpoint ?? ""]]
        
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.FORWARD_API, body: body, apikey: cardPaymentmodel.apikey) { data, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIManager.Token.self, from: data)
                self.cardPaymentmodel.token = resp.token
                DispatchQueue.main.async {
                    self.presentLodingHide()
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
        }
    }
}
    
extension CardPaymentViewModel{
    private func presentError(_ error:Error?){
        presentLodingHide()
        DispatchQueue.main.async {
            guard let showError = self.showError else {
                return
            }
            showError(error)
        }
    }
    private func presentLodingHide(){
        guard let hideLoading = self.hideLoading else {
            return
        }
        hideLoading()
    }
}
