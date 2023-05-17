import UIKit
import Foundation
import WebKit

class ViewedView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var networkManager = Network()
    var pages = [Viewed]();
    @IBOutlet weak var viewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchMostViewed{ values in
            self.pages = values
            self.viewTable.reloadData()
        }
        viewTable.delegate = self
        viewTable.dataSource = self
    }
    
    lazy var webView: WKWebView = {
         let web = WKWebView.init(frame: UIScreen.main.bounds)
         return web
     }()
    
    func goToWebview(with url: String) {
        let controller = UIViewController()
        let url = URL.init(string: url)!
        let request = URLRequest.init(url: url)
        webView.load(request)
        controller.view.addSubview(webView)
        self.present(controller,animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellViewed
        let hero = pages[indexPath.row]
        let id = hero.id
        cell.info.text = hero.title
        cell.faworit.tag = indexPath.row
        cell.faworit.setTitle("", for: .normal)
        let test = fetchArticles.shared.searchObjectByID(id: Int64(id))
        if test == false {
            cell.faworit.setImage (UIImage (named: "fav1"), for: .normal)
        } else {
            cell.faworit.setImage (UIImage (named: "fav2"), for: .normal)
        }
            cell.faworit.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
    return cell
    }
   
    @objc func addtoButton(sender : UIButton){
        let indexpath1 = IndexPath(row:sender.tag,section:0)
        let hero = pages[indexpath1.row]
        let id = hero.id
        let url = hero.url
        let title = hero.title
        let test = fetchArticles.shared.searchObjectByID(id: Int64(id))
        if test == false{
            fetchArticles.shared.create(id: Int64(id), url: url, title: title)
            fetchArticles.shared.updata(with: Int64(id), nevFav: true)
        } else {
            fetchArticles.shared.deletaOne(with: Int64(id))
        }
        self.viewTable.reloadData()
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = pages[indexPath.row]
        goToWebview(with: hero.url)
    }
}
