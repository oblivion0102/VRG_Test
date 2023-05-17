import UIKit

class ViewControllerTabs: UITabBarController, UITabBarControllerDelegate {
    let networkManager = Network()

    var isFirstPageDataFetched = false
    var isSecondPageDataFetched = false
    var isThirdPageDataFetched = false
    var isFourthPageDataFetched = false
    var isFifthPageDataFetched = false
    let emailedUrl = "https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json?api-key=AIYjmXreh9jHVemueHHmzwejpeHoms2G"
    var facebookUrl = "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=AIYjmXreh9jHVemueHHmzwejpeHoms2G"
    var viewedUrl = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=AIYjmXreh9jHVemueHHmzwejpeHoms2G"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        emailedData(URL: emailedUrl)
    }

    func emailedData(URL Url: String) {
        let url = Url
        networkManager.fetchRec(URL: url) { result in
            DispatchQueue.main.async {
                if let secVC = self.viewControllers?[0] as? StateView {
                    secVC.pages = result
                    secVC.viewTable.reloadData()
                }
            }
        }
    }

    func facebookData(URL Url: String) {
        let url = Url
        networkManager.fetchRec(URL: url) { result in
            DispatchQueue.main.async {
                if let thtVC = self.viewControllers?[1] as? StateView {
                    thtVC.pages = result
                    thtVC.viewTable.reloadData()
                }
            }
        }
    }

    func viewedData(URL Url: String) {
        let url = Url
        networkManager.fetchRec(URL: url) { result in
            DispatchQueue.main.async {
                if let foVC = self.viewControllers?[2] as? StateView {
                    foVC.pages = result
                    foVC.viewTable.reloadData()
                }
            }
        }
    }

    func combinedResponseData(URL UrlEmailed: String, URL Urlfacebook: String, URL Urlviewed: String) {
        let emailed = UrlEmailed
        let facebook = Urlfacebook
        let viewed = Urlviewed
        let group = DispatchGroup()

        var combinedResponse = CombinedResponse(response1: [], response2: [], response3: [])

        group.enter()
        networkManager.fetchRec(URL: emailed) { result in
            if let networkData = result as? [Article] {
                combinedResponse.response1 = networkData
            }
            group.leave()
        }

        group.enter()
        networkManager.fetchRec(URL: facebook) { result in
            if let networkData = result as? [Article] {
                combinedResponse.response2 = networkData
            }
            group.leave()
        }

        group.enter()
        networkManager.fetchRec(URL: viewed) { result in
            if let networkData = result as? [Article] {
                combinedResponse.response3 = networkData
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            if let sixthVC = self.viewControllers?[3] as? StateViewMonth {

                let combinedResult = combinedResponse.response1 + combinedResponse.response2 + combinedResponse.response3

                sixthVC.combinedPages = combinedResult
            }
        }
    }

    func favoriteData() {
        DispatchQueue.main.async {
            if let firstVC = self.viewControllers?[4] as? FavoriteView {
                firstVC.viewTable.reloadData()
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {

            if selectedIndex == 0 && !isFirstPageDataFetched {
                if let firstVC = viewController as? StateView {
                    emailedData(URL: emailedUrl)
                    isFirstPageDataFetched = true
                }
            } else if selectedIndex == 1 && !isSecondPageDataFetched {
                if let secVC = viewController as? StateView {
                    facebookData(URL: facebookUrl)
                    isSecondPageDataFetched = true
                }
            } else if selectedIndex == 2 && !isThirdPageDataFetched {
                if let thtVC = viewController as? StateView {
                    viewedData(URL: viewedUrl)
                    isThirdPageDataFetched = true
                }
            } else if selectedIndex == 3 && !isFourthPageDataFetched {
                if let foVC = viewController as? StateViewMonth {
                    combinedResponseData(URL: emailedUrl, URL: facebookUrl, URL: viewedUrl)
                    isFourthPageDataFetched = true
                }
            } else if selectedIndex == 4 && !isFifthPageDataFetched {
                if let fiVC = viewController as? FavoriteView {
                    favoriteData()
                    isFifthPageDataFetched = true
                }
            } else{
                return true
            }
        }

        return true
    }
}

