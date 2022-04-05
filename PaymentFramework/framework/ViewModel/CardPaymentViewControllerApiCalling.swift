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
    var presentAlert: ((String,String,@escaping ()->())->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var modelDidSet: (()->())?
    var afterPayment: ((responce)->())?
    
    var cardmodel:CardModel = CardModel.shared {
        didSet{
            guard let modelDidSet = modelDidSet else {
                return
            }
            modelDidSet()
        }
    }
    var usermodel:UserModel = UserModel.shared {
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
        let body:[String:Any] = [StringConstant.bodyemail:usermodel.email ?? ""]
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.REGISTER_API, body: body) { result in
            switch result{
            case .success(let data):
                do{
                    let resp = try JSONDecoder().decode(APIManager.ApiKey.self, from: data)
                    DispatchQueue.main.async {
                        self.usermodel.apikey = resp.apikey
                        DispatchQueue.main.async {
//                            self.presentLodingHide()
                            self.getToken()
                        }
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        self.presentError(error)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
        }
    }
    
    private func getToken(){
        let body:[String:Any] = [StringConstant.bodyplaintext:[StringConstant.bodynumber:cardmodel.number, StringConstant.bodyexpiryMonth:"\(cardmodel.expiryMonth ?? 00)", StringConstant.bodyexpiryYear: "\(cardmodel.expiryYear ?? 00 )"/*, StringConstant.bodycvv:cardPaymentmodel.cvv*/]]
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.TOKENIZE_API, body: body, apikey: usermodel.apikey) { result in
            switch result{
            case .success(let data):
                do{
                    let resp = try JSONDecoder().decode(APIManager.Token.self, from: data)
                    print(resp.token ?? "no token")
//                    self.cardPaymentmodel.token = resp.token
                    
                    DispatchQueue.main.async {
//                        self.presentLodingHide()
                        self.usermodel.token = resp.token
                        self.PresentAlert("Token", message: resp.token ?? "") {
//                            self.PaymentForword()
                        }
                            
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        self.presentError(error)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
        }
    }
    
    private func PaymentForword(){
        let body:[String:Any] = [StringConstant.bodyheaders:[StringConstant.bodymyauth:123],StringConstant.bodybody:[StringConstant.bodyname:cardmodel.name ?? "",StringConstant.bodycountry:usermodel.country ?? "",StringConstant.bodycurrency:usermodel.currency ?? "",StringConstant.bodyamount:usermodel.amount,StringConstant.bodycc:"{{json:\(String(describing: usermodel.token)):number}}", StringConstant.bodendpoint:usermodel.endpoint ?? ""]]
        
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.FORWARD_API, body: body, apikey: usermodel.apikey) { result in
            switch result{
            case .success(let data):
                do{
                    let resp = try JSONDecoder().decode(APIManager.Token.self, from: data)
                    self.usermodel.token = resp.token
                    DispatchQueue.main.async {
                        self.presentLodingHide()
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        self.presentError(error)
                    }
                }
            case .failure(let error):
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
    private func PresentAlert(_ title:String,message:String,responce:@escaping()->()){
        presentLodingHide()
        DispatchQueue.main.async {
            guard let presentAlert = self.presentAlert else {
                return
            }
            presentAlert(title,message,responce)
            
        }
    }
    private func presentLodingHide(){
        guard let hideLoading = self.hideLoading else {
            return
        }
        hideLoading()
    }
}
