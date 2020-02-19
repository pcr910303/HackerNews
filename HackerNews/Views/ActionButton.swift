
import Cocoa
import HackerNewsAPI

class ActionButton: NSButton {

    // MARK: - Properties

    var displayedAction: Action?

    // MARK: - Overrides

    override func draw(_ dirtyRect: NSRect) {
        // super.draw(dirtyRect)

        switch displayedAction?.kind {
        case .upvote:
            drawUpvote(in: dirtyRect)
        case .unvote:
            drawUnvote(in: dirtyRect)
        case .downvote:
            drawDownvote(in: dirtyRect)
        case .undown:
            drawUndown(in: dirtyRect)
        case nil: break
        }
    }

    // MARK: - Helper Methods

    func drawUpvote(in rect: NSRect, withAttributes attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.secondaryLabelColor]) {
        let upvoteString: NSString = "􀄨"
        upvoteString.drawCentered(in: rect, withAttributes: attributes)
    }

    func drawDownvote(in rect: NSRect, withAttributes attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.secondaryLabelColor]) {
        let downvoteString: NSString = "􀄩"
        downvoteString.drawCentered(in: rect, withAttributes: attributes)
    }

    func drawUnvote(in rect: NSRect) {
        NSGraphicsContext.saveGraphicsState()
        NSColor.systemBlue.set()
        NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4).fill()
        NSGraphicsContext.restoreGraphicsState()
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.white]
        drawUpvote(in: rect, withAttributes: attributes)
    }

    func drawUndown(in rect: NSRect) {
        NSGraphicsContext.saveGraphicsState()
        NSColor.systemOrange.set()
        NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4).fill()
        NSGraphicsContext.restoreGraphicsState()
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.white]
        drawDownvote(in: rect, withAttributes: attributes)
    }
}