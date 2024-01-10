import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureKeyboard()
        
        for tf in view.textFieldsInView {
            tf.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponer = textField.superview?.viewWithTag(nextTag){
            nextResponer.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }

    func configureKeyboard(){
        keyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        print("El teclado se va a mostrar")
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let seleccionado = view.selectedTextField {
                if seleccionado.frame.origin.y + seleccionado.frame.height > UIScreen.main.bounds.size.height - keyboardSize.size.height - 100 {
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= keyboardSize.height
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("El teclado se va a ocultar")
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter( {!($0 is UITextField)})
            .reduce((subviews.compactMap{$0 as? UITextField}), {summ, current in return summ + current.textFieldsInView})
    }
    
    var selectedTextField: UITextField? {
        return textFieldsInView.filter {
            $0.isFirstResponder
        }.first
    }
}

extension UIViewController{
    
    func keyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
