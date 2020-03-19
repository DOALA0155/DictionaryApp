import UIKit
import Firebase

class StartViewController: UIViewController {

    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func startButtonPushed(_ sender: Any) {
        if auth.currentUser != nil{
        auth.currentUser?.reload(completion: { error in if error == nil{
            if self.auth.currentUser?.isEmailVerified == true{
                self.performSegue(withIdentifier: "toTabView", sender: nil)
            }else if self.auth.currentUser?.isEmailVerified == false{
                let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }})
        
        }else if auth.currentUser == nil{
            self.performSegue(withIdentifier: "toLogInView", sender: nil)
        }
    }

}
