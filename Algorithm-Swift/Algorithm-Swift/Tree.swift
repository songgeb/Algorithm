//
//  Tree.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/11/7.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

class Tree {
  
  /// 数组存储完全二叉树, 记得下标要从1开始
  static let tree = [-1, 1, 3, 2, 4, 5, 6, 7, 9, 11, 34]
  
  ///      1
  ///   3             2
  ///  4   5       6     7
  /// 9  11   34
  
  /// 前序遍历二叉树的递归实现
  /// print root, preOrder(root->left), preOrder(root->right)
  class func preOrder(root: Int) {
    if root >= tree.count { return }
    print(tree[root])
    let left = root * 2
    let right = left + 1
    preOrder(root: left)
    preOrder(root: right)
  }
  
  /// 中序遍历
  /// midOrder(root->left), print root, midOrder(root->right)
  /// - Parameter root:
  class func midOrder(root: Int) {
    if root >= tree.count { return }
    let left = 2 * root
    let right = left + 1
    midOrder(root: left)
    print(tree[root])
    midOrder(root: right)
  }
  
  /// 按层遍历(递归)
  /// 关键点在于，若用递归的话，递归只能一直往深处走，所以需要一个类似res的全局空间，来存储每一层的结果
  /// for root, print root, floorOrder(left),
  /// - Parameter root:
  class func levelOrder(root: Int) {
    var res: [[Int]] = []
    func what(root: Int, level: Int) {
      // level表示层数，当res中下标为level的数组不空时，则往数组中加入下标为root的节点
      // 当res中数组为空，说明还未加如节点，那就创建一个数组
      if root >= tree.count { return }
      if level >= res.count {
        res.append([tree[root]])
      } else {
        res[level].append(tree[root])
      }
      let left = 2 * root
      let right = left + 1
      what(root: left, level: level + 1)
      what(root: right, level: level + 1)
    }
    what(root: 1, level: 0)
    
    print(res)
  }
  
  /// 非递归实现按层遍历二叉树
  /// - Parameter root:
  class func levelOrder1(root: Int) -> [[Int]] {
    // 有一个结果集来存放每一层的节点信息res，[[Int]]
    // 还要有一个level信息，记录当前层数，从0开始，
    // 让更节点入队列
    // 当队列不为空时，取出队列的所有节点，将这些节点值放到res中level的下标中，如果没有则创建一个空数组再加入
    // 再将这些节点的所有子节点放入队列中继续上面过程
    
    var res: [[Int]] = []
    let queue = CircularQueue(length: 10)
    _ = queue.enqueue(root)
    var level = 0
    
    while !queue.isEmpty() {
      
      var subNodeIndices: [Int] = []
      while let nodeIndex = queue.dequeue() {
        if level >= res.count {
          res.append([tree[nodeIndex]])
        } else {
          res[level].append(tree[nodeIndex])
        }
        
        let left = nodeIndex * 2
        let right = left + 1
        if left < tree.count {
          subNodeIndices.append(left)
        }
        if right < tree.count {
          subNodeIndices.append(right)
        }
      }
      
      subNodeIndices.forEach { (subNodeIndex) in
        _ = queue.enqueue(subNodeIndex)
      }
      
      level += 1
    }
    return res
  }
  
  public class func testTree() {
    let res = levelOrder1(root: 1)
    print(res)
  }
}
