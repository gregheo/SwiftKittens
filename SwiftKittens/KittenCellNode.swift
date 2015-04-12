//
//  KittenCellNode.swift
//  SwiftKittens
//
//  Created by Greg Heo on 2015-03-15.
//
//

import UIKit

private let kImageSize: CGFloat = 80.0
private let kOuterPadding: CGFloat = 16.0
private let kInnerPadding: CGFloat = 10.0

private let placeholders = [
  "Kitty ipsum dolor sit amet, purr sleep on your face lay down in your way biting, sniff tincidunt a etiam fluffy fur judging you stuck in a tree kittens.",
  "Lick tincidunt a biting eat the grass, egestas enim ut lick leap puking climb the curtains lick.",
  "Lick quis nunc toss the mousie vel, tortor pellentesque sunbathe orci turpis non tail flick suscipit sleep in the sink.",
  "Orci turpis litter box et stuck in a tree, egestas ac tempus et aliquam elit.",
  "Hairball iaculis dolor dolor neque, nibh adipiscing vehicula egestas dolor aliquam.",
  "Sunbathe fluffy fur tortor faucibus pharetra jump, enim jump on the table I don't like that food catnip toss the mousie scratched.",
  "Quis nunc nam sleep in the sink quis nunc purr faucibus, chase the red dot consectetur bat sagittis.",
  "Lick tail flick jump on the table stretching purr amet, rhoncus scratched jump on the table run.",
  "Suspendisse aliquam vulputate feed me sleep on your keyboard, rip the couch faucibus sleep on your keyboard tristique give me fish dolor.",
  "Rip the couch hiss attack your ankles biting pellentesque puking, enim suspendisse enim mauris a.",
  "Sollicitudin iaculis vestibulum toss the mousie biting attack your ankles, puking nunc jump adipiscing in viverra.",
  "Nam zzz amet neque, bat tincidunt a iaculis sniff hiss bibendum leap nibh.",
  "Chase the red dot enim puking chuf, tristique et egestas sniff sollicitudin pharetra enim ut mauris a.",
  "Sagittis scratched et lick, hairball leap attack adipiscing catnip tail flick iaculis lick.",
  "Neque neque sleep in the sink neque sleep on your face, climb the curtains chuf tail flick sniff tortor non.",
  "Ac etiam kittens claw toss the mousie jump, pellentesque rhoncus litter box give me fish adipiscing mauris a.",
  "Pharetra egestas sunbathe faucibus ac fluffy fur, hiss feed me give me fish accumsan.",
  "Tortor leap tristique accumsan rutrum sleep in the sink, amet sollicitudin adipiscing dolor chase the red dot.",
  "Knock over the lamp pharetra vehicula sleep on your face rhoncus, jump elit cras nec quis quis nunc nam.",
  "Sollicitudin feed me et ac in viverra catnip, nunc eat I don't like that food iaculis give me fish.",
]

class KittenCellNode: ASCellNode {
  private let kittenSize: CGSize
  private let imageNode = ASNetworkImageNode()
  private let textNode = ASTextNode()
  private let divider = ASDisplayNode()

  private lazy var textStyle: [NSObject: AnyObject] = {
    let font = UIFont(name: "HelveticaNeue", size: 12)!

    let style = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
    style.paragraphSpacing = 0.5 * font.lineHeight
    style.hyphenationFactor = 1.0

    return [NSFontAttributeName: font, NSParagraphStyleAttributeName: style]
  }()

  init(size: CGSize) {
    kittenSize = size

    super.init()

    imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
    imageNode.URL = NSURL(string: "http://placekitten.com/\(Int(size.width))/\(Int(size.height))")!
    addSubnode(imageNode)

    textNode.attributedString = NSAttributedString(string: kittyIpsum(), attributes: textStyle)
    addSubnode(textNode)

    divider.backgroundColor = UIColor.lightGrayColor()
    addSubnode(divider)
  }

  override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
    let imageSize = CGSize(width: kImageSize, height: kImageSize)
    let textSize = textNode.measure(CGSize(width: constrainedSize.width - kImageSize - 2 * kOuterPadding - kInnerPadding, height: constrainedSize.height))

    // ensure there's room for the text
    let requiredHeight = max(textSize.height, imageSize.height)
    return CGSize(width: constrainedSize.width, height: requiredHeight + 2 * kOuterPadding)
  }

  override func layout() {
    let pixelHeight: CGFloat = 1.0 / UIScreen.mainScreen().scale

    divider.frame = CGRect(x: 0, y: 0, width: calculatedSize.width, height: pixelHeight)
    imageNode.frame = CGRect(x: kOuterPadding, y: kOuterPadding, width: kImageSize, height: kImageSize)
    let textSize = textNode.calculatedSize
    textNode.frame = CGRect(x: kOuterPadding + kImageSize + kInnerPadding, y: kOuterPadding, width: textSize.width, height: textSize.height)
  }

  private func kittyIpsum() -> String {
    let location = arc4random_uniform(UInt32(placeholders.count))
    let length = arc4random_uniform(UInt32(placeholders.count) - location)

    var ipsum = ""

    for i in Int(location)...Int(location+length) {
      ipsum += placeholders[i] + (i % 2 == 0 ? "\n" : " ")
    }

    return ipsum
  }
}
