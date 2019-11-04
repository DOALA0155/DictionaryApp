import UIKit
import Firebase

class AddDictionaryWordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordField: UITextField!
    @IBOutlet weak var explanationView: UITextView!
    var dictionaryName: String!
    var me: AppUser!
    var database: Firestore!
    var dictionaryWords: Dictionary<String, String>!
    var allData: Array<String>!
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        wordField.delegate = self
        explanationView.layer.cornerRadius = 5
        explanationView.layer.masksToBounds = true
        setupTextView()
    }
    @IBAction func addButtonPushed(_ sender: Any) {
        let wordName = wordField.text!
        let wordExplanation = explanationView.text!
        database.collection(me.userId).document(dictionaryName).getDocument{ (document, error) in if error == nil, let document = document{
            let data = document.data()!
            let words = data["dictionaryWord"] as! Dictionary<String, String>
            self.allData = Array(words.keys)
            }
            if self.allData.contains(wordName) || wordName == ""{
                let alert = UIAlertController(title: "同じ名前の辞書は追加できません。", message: "その名前の辞書は既に存在しています。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let saveDocument = self.database.collection(self.me.userId).document(self.dictionaryName)
                self.dictionaryWords.updateValue(wordExplanation, forKey: wordName)
                saveDocument.setData([
                    "dictionaryName": self.dictionaryName!,
                    "dictionaryWord": self.dictionaryWords!
                ]){error in if error == nil{
                    self.navigationController?.popViewController(animated: true)
                    }}
                
            }
        }
    
        
    }
    func setupTextView() {
        let toolBar = UIToolbar()
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolBar.items = [flexibleSpaceBarButton, doneButton]
        toolBar.sizeToFit()
        explanationView.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard() {
        explanationView.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "ログアウト", message: "本当にログアウトしますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            try? Auth.auth().signOut()
            let StartViewController: StartViewController = self.storyboard?.instantiateViewController(identifier: "start") as! StartViewController
            self.navigationController?.pushViewController(StartViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
