//
//  AlertView.swift


import UIKit


enum ActionType{
    case yes
    case nothanks
}

class AlertView: NSObject {
    static let instance: AlertView = {
    
        return AlertView()
    }()
    static let title = "lbl_AppName".localized()
    typealias alertHandler = (Any?) -> Void
}


extension AlertView {

    func showAlert(message: String, delegate: UIViewController , pop:Bool) {
        
        let alert = UIAlertController(title:AlertView.self.title, message: NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            if pop == true
            {
                delegate.navigationController?.popViewController(animated: true)

            }
        }))
        delegate.present(alert, animated: true, completion: nil)
    }

    func showNoInternetAlert(delegate: UIViewController , pop:Bool,isDismissButton:Bool=false,handler:@escaping ()->Void ) {

        let alert = UIAlertController(title:AlertView.self.title, message:"msg_NoInternet".localized(), preferredStyle: UIAlertController.Style.alert)
        var btnTitle = "btn_Retry".localized()
        if(isDismissButton){
            btnTitle = "btn_Dismiss".localized()
        }
        alert.addAction(UIAlertAction(title:btnTitle, style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            handler()
        }))


        delegate.present(alert, animated: true, completion: nil)
    }

    func showLocationSettingAlert(message: String, delegate: UIViewController , pop:Bool) {

        let alert = UIAlertController(title:AlertView.self.title, message:message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title:"btn_Setting".localized(), style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))

        alert.addAction(UIAlertAction(title:"btn_Dismiss".localized(), style: UIAlertAction.Style.destructive, handler: {(alert: UIAlertAction!) in

        }))

        delegate.present(alert, animated: true, completion: nil)
    }

}
