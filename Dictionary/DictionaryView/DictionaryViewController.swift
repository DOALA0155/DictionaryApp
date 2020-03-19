import UIKit
import Firebase

class DictionaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var dictionaryNameLabel: UILabel!
    @IBOutlet weak var wordList: UITableView!
    var me: AppUser!
    var dictionaryWord: Dictionary<String, String> = [:]
    var dictionaryWords: Array<String> = []
    var dictionaryName: String!
    var database: Firestore!
    var wordName = ""
    var wordExplanation = ""
    let wordSearchBar = UISearchBar()
    var searchResult: Array<String>!
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        wordSearchBar.delegate = self
        wordList.delegate = self
        wordList.dataSource = self
        wordList.register(UINib(nibName: "WordTableViewCell", bundle: nil), forCellReuseIdentifier: "WordTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dictionaryNameLabel.text! = dictionaryName
        database.collection(me.userId).document(dictionaryName).getDocument{ (document, error) in if error == nil, let document = document{
            let data = document.data()!
            self.dictionaryWords = []
            self.dictionaryWord = data["dictionaryWord"] as! Dictionary<String, String>
            for key in Array(self.dictionaryWord.keys){
                self.dictionaryWords.append(key)
            }
            self.wordList.reloadData()
            }}
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.searchResult = dictionaryWords.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        self.wordList.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.wordList.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    @IBAction func addButtonPushed(_ sender: Any) {
        performSegue(withIdentifier: "toAddWordView", sender: dictionaryWord)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddWordView"{
            let AddDictionaryWordViewController = segue.destination as! AddDictionaryWordViewController
            AddDictionaryWordViewController.dictionaryWords = (sender as! Dictionary<String, String>)
            AddDictionaryWordViewController.me = me
            AddDictionaryWordViewController.dictionaryName = dictionaryName
        }else if segue.identifier == "toWordCell"{
            let DictionaryWordViewController = segue.destination as! DictionaryWordViewController
            let wordData = sender as! Array<String>
            
            DictionaryWordViewController.wordName = wordData[0]
            DictionaryWordViewController.wordExplanation = wordData[1]
        }else if segue.identifier == "toPostView"{
            let PostViewController = segue.destination as! PostViewController
            PostViewController.dictionaryName = dictionaryName
            PostViewController.dictiobnaryWords = dictionaryWord
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if wordSearchBar.text == ""{
            wordName = dictionaryWords[indexPath.row]
            wordExplanation = dictionaryWord[wordName]!
        }else{
            wordName = searchResult[indexPath.row]
            wordExplanation = dictionaryWord[wordName]!
        }
        
        performSegue(withIdentifier: "toWordCell", sender: [wordName, wordExplanation])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wordSearchBar.text == ""{
            return dictionaryWords.count
        }else{
            return searchResult.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as! WordTableViewCell
        if wordSearchBar.text == ""{
            cell.wordNameLabel.text! = self.dictionaryWords[indexPath.row]
        }else{
            cell.wordNameLabel.text! = self.searchResult[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        wordSearchBar.placeholder = "辞書内の言葉を検索"
        return wordSearchBar
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let alert = UIAlertController(title: "削除", message: "本当に削除しますか？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                if self.wordSearchBar.text == ""{
                    self.dictionaryWords.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                    let data = self.database.collection(self.me.userId).document(self.dictionaryName)
                    data.updateData(["dictionaryWord": [:]])
                }else{
                    if let index = self.dictionaryWords.firstIndex(of: self.searchResult[indexPath.row]){
                        self.dictionaryWords.remove(at: index)
                    }
                    self.searchResult.remove(at: indexPath.row)
                    let data = self.database.collection(self.me.userId).document(self.dictionaryName)
                    data.updateData(["dictionaryWord": [:]])
                }
                
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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
