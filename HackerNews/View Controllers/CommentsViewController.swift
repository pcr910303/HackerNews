
import Cocoa
import PromiseKit
import HackerNewsAPI

class CommentsViewController: NSViewController {

    // MARK: - IBOutlets

    @IBOutlet var commentOutlineView: NSOutlineView!
    @IBOutlet var progressView: ProgressView!

    // MARK: - Properties

    // Always in sync with it's parent view controller
    var currentListableItem: ListableItem? {
        didSet {
            loadAndDisplayComments()
        }
    }

    var currentTopLevelItem: TopLevelItem?

    var commentLoadProgress: Progress? {
        didSet {
            progressView.progress = commentLoadProgress
        }
    }

    // MARK: - Methods

    func loadAndDisplayComments() {
        guard let currentListableItem = currentListableItem else {
            return
        }
        commentOutlineView.reloadData()
        commentOutlineView.isHidden = true

        let progress = Progress(totalUnitCount: 100)
        commentLoadProgress = progress
        progress.becomeCurrent(withPendingUnitCount: 100)

        firstly {
            HackerNewsAPI.topLevelItem(from: currentListableItem)
        }.done { topLevelItem in
            self.commentLoadProgress = nil
            self.currentTopLevelItem = topLevelItem
            self.commentOutlineView.reloadData()
            self.commentOutlineView.expandItem(nil, expandChildren: true)
            self.commentOutlineView.isHidden = false
        }.catch { error in
            print(error)
        }
        progress.resignCurrent()
    }

    func initializeInterface() {
        progressView.labelText = "Loading Comments..."
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
    }
}

// MARK: - NSOutlineViewDataSource

extension CommentsViewController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard case .story(let currentStory) = currentTopLevelItem else {
            fatalError()
        }
        guard let comment = item as? Comment else {
            return currentStory.comments[index]
        }
        return comment.comments[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let comment = item as? Comment else {
            return false
        }
        return !comment.comments.isEmpty
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard case .story(let currentStory) = currentTopLevelItem else {
            return 0
        }
        guard let comment = item as? Comment else {
            return currentStory.comments.count
        }
        return comment.comments.count
    }

    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        guard let comment = item as? Comment else {
            return nil
        }
        return comment
    }
}

// MARK: - NSOutlineViewDelegate

extension CommentsViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        // objectValue is automatically populated
        let commentCellView = outlineView.makeView(withIdentifier: .commentCellView, owner: self) as! CommentCellView
        return commentCellView
    }
}

// MARK: - NSStoryboard.Name

extension NSStoryboard.Name {

    static let main = NSStoryboard.Name("Main")
}

// MARK: - NSStoryboard.SceneIdentifier

extension NSStoryboard.SceneIdentifier {

    static let authorPopupViewController = NSStoryboard.SceneIdentifier("AuthorPopupViewController")
}
