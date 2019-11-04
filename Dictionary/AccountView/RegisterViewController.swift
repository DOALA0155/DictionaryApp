import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    var auth: Auth!
    var me: AppUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        mailField.delegate = self
        passwordField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func registerButtonPushed(_ sender: Any) {
        let userMail = mailField.text!
        let userPassword = passwordField.text!
        if userPassword.count < 6{
            let alert = UIAlertController(title: "パスワードエラー", message: "パスワードは６文字上にしてください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        auth.createUser(withEmail: userMail, password: userPassword){ (result, error) in
        if error == nil, let result = result {
            result.user.sendEmailVerification(completion: { (error) in if error == nil{
                let alert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }})
        }else if error != nil{
            let alert = UIAlertController(title: "登録エラー", message: "新規登録ができませんでした。メールアドレスの形式などを確認してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
}

