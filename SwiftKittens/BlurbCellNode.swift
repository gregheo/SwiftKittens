//
//  BlurbCellNode.swift
//  SwiftKittens
//
//  Created by Greg Heo on 2015-03-15.
//
//

import Foundation
import UIKit

private let kTextPadding: CGFloat = 10
private let kLinkAttributeName = "PlaceKittenNodeLinkAttributeName"

class BlurbCellNode: ASCellNode, ASTextNodeDelegate {
  private let textNode = ASTextNode()

  override init() {
    super.init()

    textNode.delegate = self
    textNode.userInteractionEnabled = true
    textNode.linkAttributeNames = [kLinkAttributeName]

    let blurb = "kittens courtesy placekitten.com 🐱" as NSString
    let string = NSMutableAttributedString(string: blurb)

    string.addAttribute(NSFontAttributeName, value:UIFont(name: "HelveticaNeue-Light", size: 16.0)!, range:NSMakeRange(0, blurb.length))
    string.addAttributes([kLinkAttributeName: NSURL(string: "http://placekitten.com/")!,
      NSForegroundColorAttributeName: UIColor.grayColor(),
      NSUnderlineStyleAttributeName: (NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternDot.rawValue)],
      range: blurb.rangeOfString("placekitten.com"))
    textNode.attributedString = string

    addSubnode(textNode)
  }

  override func didLoad() {
    layer.as_allowsHighlightDrawing = true

    super.didLoad()
  }

  override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
    // Called on a background thread.
    // Custom nodes must call measure() on their subnodes in this method.

    let measuredSize = textNode.measure(CGSize(width: constrainedSize.width - 2 * kTextPadding, height: constrainedSize.height - 2 * kTextPadding))
    return CGSize(width: constrainedSize.width, height: measuredSize.height + 2 * kTextPadding)
  }

  override func layout() {
    // Called on the main thread.
    // Use the stashed size from above, instead of blocking on text sizing.

    let textNodeSize = textNode.calculatedSize
    textNode.frame = CGRect(x: (self.calculatedSize.width - textNodeSize.width) / 2.0, y: kTextPadding, width: textNodeSize.width, height: textNodeSize.height)
  }

  // MARK: - ASTextNodeDelegate

  func textNode(textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: AnyObject!, atPoint point: CGPoint) -> Bool {
    // opt into link highlighting -- tap and hold the link to try it! must enable highlighting on a layer, see didLoad()
    return true
  }

  func textNode(textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: AnyObject!, atPoint point: CGPoint, textRange: NSRange) {
    // The node tapped a link; open it if it's a valid URL
    if let url = value as? NSURL {
      UIApplication.sharedApplication().openURL(url)
    }
  }

}
