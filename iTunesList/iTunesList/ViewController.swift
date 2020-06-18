import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var queenImage: UIImageView!
    @IBOutlet weak var beatlesImage: UIImageView!
    @IBOutlet weak var bandName: UILabel!
    
    var urlStr = ""
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queenImage.image = UIImage(named: "Queen")
        beatlesImage.image = UIImage(named: "Beatles")
    }
    
    @IBAction func showQueen(_ sender: Any) {
        tableView.isHidden = false
        urlStr = "https://itunes.apple.com/search?term=queen&limit=10"
        bandName.text = "Queen"
        tableView.reloadData()
    }
    @IBAction func showBeatles(_ sender: Any) {
        tableView.isHidden = false
        urlStr = "https://itunes.apple.com/search?term=the+beatles&limit=10"
        bandName.text = "The Beatles"
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let response = try? self.decoder.decode(Song.self, from: data) {
                        DispatchQueue.main.async {
                            cell.textLabel?.text = response.results[indexPath.row].trackName
                            cell.detailTextLabel?.text = response.results[indexPath.row].collectionName
                        }
                    }
                }
            }
            task.resume()
        }
        return cell
    }
}
