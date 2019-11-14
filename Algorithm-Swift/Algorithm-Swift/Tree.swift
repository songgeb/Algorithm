//
//  Tree.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/11/7.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

public class TreeNode {
  public var val: Int
  public var left: TreeNode?
  public var right: TreeNode?
  public init(_ val: Int) {
    self.val = val
  }
}

// 二叉搜索树、二叉查找树 Binary Search Tree--BST
//
class Tree {
  class func createATree() -> TreeNode {
    let node19 = TreeNode(19)
    let node27 = TreeNode(27)
    let node25 = TreeNode(25)
    node25.left = node19
    node25.right = node27
    
    let node18 = TreeNode(18)
    node18.right = node25
    
    let node17 = TreeNode(17)
    node17.right = node18
    
    let node33 = TreeNode(33)
    node33.left = node17
    
    let node16 = TreeNode(16)
    let node13 = TreeNode(13)
    node13.right = node16
    node17.left = node13
    
    let node51 = TreeNode(51)
    let node66 = TreeNode(66)
    let node58 = TreeNode(58)
    node58.left = node51
    node58.right = node66
    
    let node34 = TreeNode(34)
    let node50 = TreeNode(50)
    node50.left = node34
    node50.right = node58
    
    node33.right = node50
    
    return node33
  }
  
  class func findRecursively(value: Int, root: TreeNode?) -> TreeNode? {
    guard let root = root else { return nil }
    if value < root.val {
      return findRecursively(value: value, root: root.left)
    } else if value > root.val {
      return findRecursively(value: value, root: root.right)
    } else {
      return root
    }
  }
  
  class func find(val: Int, root: TreeNode) -> TreeNode? {
    //一个当前的游标pNode，指向正在遍历的节点
    //初始等于根节点
    //只要pNode不为空，就开始比较
    var pNode: TreeNode? = root
    while pNode != nil {
      guard let current = pNode else { return nil }
      if val < current.val {
        pNode = current.left
      } else if val > current.val {
        pNode = current.right
      } else {
        return pNode
      }
    }
    return nil
  }
  
  class func midOrder(root: TreeNode?) {
    guard let root = root else { return }
    midOrder(root: root.left)
    print(root.val)
    midOrder(root: root.right)
  }
  
  class func insert(val: Int, root: TreeNode) {
    // 递归不容易实现
    // pNode当前节点，初始等于根节点
    // ppNode是pNode的父节点
    // 插入节点，肯定是插入到叶子节点
    // 只要pNode不是空，说明还没有到叶子节点的下一层
    // 当和pNode相等时，程序结束，不能插入
    // val < pNode.val时，去左子树中找
    // while循环结束后，说明ppNode就是要插入的新节点的父节点
    // 若val < ppNode.val，则新建一个节点作为ppNode的左子树
    // 反之作为ppNode的右子树
    
    var pNode: TreeNode? = root
    var ppNode: TreeNode? = nil
    while pNode != nil {
      if val == pNode!.val {
        return
      } else if val < pNode!.val {
        ppNode = pNode
        pNode = pNode?.left
      } else {
        ppNode = pNode
        pNode = pNode?.right
      }
    }
    
    if val < ppNode!.val {
      ppNode?.left = TreeNode(val)
    } else {
      ppNode?.right = TreeNode(val)
    }
  }
  
  class func deleteNodeOptimize(val: Int, root: TreeNode) {
    // deleteNode方法，可以有两个优化点
    // 1. 第3种情况最后也是要删除节点，和前面的2情况是类似的，可以复用
    // 2.
    
    var ppNode: TreeNode? = nil
    var pNode: TreeNode? = root
    // 找到待删除节点
    while pNode != nil {
      let cv = pNode!.val
      if val < cv {
        ppNode = pNode
        pNode = pNode?.left
      } else if val > cv {
        ppNode = pNode
        pNode = pNode?.right
      } else {
        break
      }
    }
    
    if pNode == nil { return }
    
    // 情况3
    // 找到pNode右子树中最小的节点
    if pNode?.left != nil, pNode?.right != nil {
      var subppNode = pNode
      var subpNode = pNode?.right
      while subpNode?.left != nil {
        subppNode = subpNode
        subpNode = subpNode?.left
      }
      // 将最小值替换到待删除节点位置
      pNode?.val = subpNode!.val
      
      // 更新要删除的节点pNode, 复用下面删除节点代码
      pNode = subpNode
      ppNode = subppNode
    }
    
    let isLeft = ppNode?.left?.val == pNode?.val
    var child: TreeNode?
    // 情况1
    if pNode?.left == nil, pNode?.right == nil {
      child = nil
    }
    
    // 情况2
    if pNode?.left != nil {
      child = pNode?.left
    } else {
      child = pNode?.right
    }
    
    if isLeft {
      ppNode?.left = child
    } else {
      ppNode?.right = child
    }
  }
  
  class func deleteNode(val: Int, root: TreeNode) {
    // 未优化删除代码
    // 删除分三种情况
    // 1. 被删除节点是叶子节点时，直接删除节课
    // 2. 被删除节点仅有左子树或只有右子树
    // 3. 被删除节点既有左子树又有右子树
    
    // 第1种情况下，直接删除
    // 第2种情况，删除节点后，还要将父节点连接到被删除节点的子节点
    // 第3种情况，找到被删除节点右子树中最小的节点，被删除节点值替换为最小节点的值，并删除最小节点
    // 由于右子树中最小的节点肯定没有左子树了，所以只用考虑有右子树的情况
    // ppNode记录被删除节点的父节点
    
    var ppNode: TreeNode? = nil
    var pNode: TreeNode? = root
    // 找到待删除节点
    while pNode != nil {
      let cv = pNode!.val
      if val < cv {
        ppNode = pNode
        pNode = pNode?.left
      } else if val > cv {
        ppNode = pNode
        pNode = pNode?.right
      } else {
        break
      }
    }
    
    if pNode == nil { return }
    let isLeft = ppNode?.left?.val == pNode?.val
    // 情况1
    if pNode?.left == nil, pNode?.right == nil {
      if isLeft {
        ppNode?.left = nil
      } else {
        ppNode?.right = nil
      }
      return
    }
    
    // 情况2
    if pNode?.left == nil, pNode?.right != nil {
      if isLeft {
        ppNode?.left = pNode?.right
      } else {
        ppNode?.right = pNode?.right
      }
    }
    
    if pNode?.left != nil, pNode?.right == nil {
      if isLeft {
        ppNode?.left = pNode?.left
      } else {
        ppNode?.right = pNode?.left
      }
    }
    
    // 情况3
    // 找到pNode右子树中最小的节点
    var subppNode = pNode
    var subpNode = pNode?.right
    while subpNode?.left != nil {
      subppNode = subpNode
      subpNode = subpNode?.left
    }
    
    pNode?.val = subpNode!.val
    
    // 删除subpNode
    if subppNode?.left?.val == subpNode?.val {
      subppNode?.left = subpNode?.right
    }
    
    if subppNode?.right?.val == subpNode?.val {
      subppNode?.right = subpNode?.right
    }
  }
  
  public class func testTree() {
    let root = Tree.createATree()
//    let node = findRecursively(value: 19, root: root)
//    let node = find(val: 19, root: root)
    midOrder(root: root)
//    insert(val: 100, root: root)
    print("我勒个去")
//    midOrder(root: root)
    deleteNodeOptimize(val: 33, root: root)
//    deleteNode(val: 13, root: root)
    
    print(root.val)
    
//    midOrder(root: root)
  }
}


/// 数组存储的完全二叉树
class ArrayTree {
  
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
    // 当队列不为空时，取出队列的所有节点，将这些节点值放到res中下标未level的位置，如果没有则创建一个空数组再加入
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