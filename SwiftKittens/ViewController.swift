//
//  ViewController.swift
//  SwiftKittens
//
//  Created by Greg Heo on 2015-03-15.
//
//

import UIKit

private let kLitterSize = 20
private let kLitterBatchSize = 10
private let kMaxLitterSize = 100

// array of CGSize instances corresponding to placekitten kittens
typealias KittenData = [CGSize]

class ViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate {
  private let tableView: ASTableView

  var dataSourceLocked = false

  var kittenDataSource: KittenData {
    willSet {
      assert(!dataSourceLocked, "Could not update data source when it is locked!")
    }
  }

  override init() {
    tableView = ASTableView(frame: .zeroRect, style: .Plain)
    kittenDataSource = []

    super.init(nibName: nil, bundle: nil)

    tableView.separatorStyle = .None
    tableView.asyncDataSource = self
    tableView.asyncDelegate = self

    // populate our "data source" with some random kittens
    kittenDataSource = createLitterWithSize(kLitterSize)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("")
  }

  func createLitterWithSize(litterSize: Int) -> KittenData {
    var kittens = KittenData()

    for i in 0..<litterSize {
      let deltaX = Int(arc4random_uniform(10)) - 5
      let deltaY = Int(arc4random_uniform(10)) - 5
      let size = CGSize(width: 350 + 2 * deltaX, height: 350 + 4 * deltaY)

      kittens.append(size)
    }

    return kittens
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)
  }

  override func viewWillLayoutSubviews() {
    tableView.frame = view.bounds
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  // MARK: - Kittens

  func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
    if indexPath.section == 0 {
      return BlurbCellNode()
    } else {
      let size = kittenDataSource[indexPath.row]
      return KittenCellNode(size: size)
    }
  }

  func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return kittenDataSource.count
    }
  }

  func tableView(tableView: UITableView!, shouldHighlightRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    return false
  }

  func tableViewLockDataSource(tableView: ASTableView) {
    dataSourceLocked = true
  }

  func tableViewUnlockDataSource(tableView: ASTableView) {
    dataSourceLocked = false
  }

  func shouldBatchFetchForTableView(tableView: ASTableView!) -> Bool {
    return kittenDataSource.count < kMaxLitterSize
  }

  func tableView(tableView: ASTableView!, willBeginBatchFetchWithContext context: ASBatchContext!) {
    NSLog("adding kitties")

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      sleep(1)
      dispatch_async(dispatch_get_main_queue()) {
        let moarKittens = self.createLitterWithSize(kLitterBatchSize)

        var indexPaths = [NSIndexPath]()
        let existingKittens = self.kittenDataSource.count

        for i in 0..<moarKittens.count {
          indexPaths.append(NSIndexPath(forRow: existingKittens + i, inSection: 1))
        }

        self.kittenDataSource += moarKittens
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)

        context.completeBatchFetching(true)

        NSLog("kittens added!")
      }
    }
  }

}
