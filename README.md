# ISOnDemandTableView

**Load your TableView content dynamically as you scroll**

`ISOnDemandTableView` allows you to load the TableView content in little chunks as you scroll down the list instead of loading everything at once. This is important if your list contains a lot of information.

![](https://raw.githubusercontent.com/Ilhasoft/ISOnDemandTableView/master/Resources/OnDemandTableView.gif)

# Usage

To quickly implement an "on demand" list, make your UITableView a subclass of ISOnDemandTableView:

![](https://raw.githubusercontent.com/Ilhasoft/ISOnDemandTableView/master/Resources/usage01.png)

In your ViewController, implement the `ISOnDemandTableViewDelegate` protocol. You're required to implement two method at least:

```swift
extension ViewController: ISOnDemandTableViewDelegate {
    func reuseIdentifierForCell(at indexPath: IndexPath) -> String {
        return "YourCellIdentifier"
    }

    func onContentLoadFinishedWithError(_ error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
```

# Loading Content

In order to load content for the TableView, you must create your own class subclassing `ISOnDemandTableViewInteractor`:

```swift
class CustomTableViewInteractor: ISOnDemandTableViewInteractor {

    override init() {
        super.init(paginationCount: 20)
    }

    override func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        var objectsList: [Any] = []
        // get the content of the list for the current page
        handler(objectsList, nil)
    }
}
```

The TableView will automatically call this method and reload the list when you scroll to the bottom of the list.

In your `viewDidLoad` method, assing your ViewController as the delegate of the tableView and assing the correct TableViewInteractor subclass:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "YourCellNibName", bundle: nil), forCellReuseIdentifier: "YourCellIdentifier")
    tableView.onDemandTableViewDelegate = self
    tableView.interactor = CustomTableViewInteractor()
    tableView.loadContent() // this must be called the first time
}
```

# Installation

## CocoaPods

To install it using CocoaPods, add the following line the project's `Podfile`:

```
pod 'ISOnDemandTableView', '1.0.0'
```
