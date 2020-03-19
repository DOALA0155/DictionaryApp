import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mailField.delegate = self
        passwordField.delegate = self
    }
    @IBAction func logInButtonPushed(_ sender: Any) {
        let mail = mailField.text!
        let password = passwordField.text!
        Auth.auth().signIn(withEmail: mail, password: password){ (result, error) in if error == nil, let result = result, result.user.isEmailVerified{
            self.performSegue(withIdentifier: "toTabView", sender: result.user)
        }else if error != nil{
            let alert = UIAlertController(title: "ログインエラー", message: "パスワードまたはメールアドレスが違います。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }}
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
