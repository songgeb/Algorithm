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
    
    // MARK: - 递归实现前序、中序遍历
    class func preTraversal(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        print(root.val)
        preTraversal(root.left)
        preTraversal(root.right)
    }
    
    class func inTraversal(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        inTraversal(root.left)
        print(root.val)
        inTraversal(root.right)
    }
    
    // MARK: - 非递归实现前序、中序、后序遍历
    func inOrderWithoutRecursion(_ root: TreeNode?) {
        // 因为深度访问到底之后，需要向上回溯，所以借助Stack比较方便
        // 梳理一下整体思路
        // 1. 从根节点一直往左下走，每经过一个节点，就入栈，走到最后一个节点p，打印，看下是否右右子树
        // 2.1 有的话，右子树也要进行1的操作，同时p出栈
        // 2.2 没有的话，那p出栈，找到p的父节点，父节点打印，同时父节点出栈，转到父节点的右节点进行1操作
        // 只要栈不为空，就可以一直做1和2的工作
        guard let root = root else { return }
        let stack = Stack<TreeNode>()
        
        var p: TreeNode? = root
        while !stack.isEmpty || p != nil {
            // 找到最左下角节点
            while let pp = p {
                stack.push(pp)
                p = p?.left
            }
            // 打印节点
            p = stack.top()
            print(p?.val)
            stack.pop()
            
            // check叶子节点的两种情况
            if let right = p?.right {
                p = right
            } else {
                // 找到父节点
                guard let parent = stack.top() else {
                    break
                }
                print(parent.val)
                stack.pop()
                p = parent.right
            }
        }
    }
    /// 非递归前序遍历
    func preorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        let stack = Stack<TreeNode>()
        var p: TreeNode? = root
        var result: [Int] = []
        while !stack.isEmpty || p != nil {
            // 一直找左子树，同时打印节点，直到左子树是空
            while let pp = p {
                result.append(pp.val)
                stack.push(pp)
                p = p?.left
            }
            
            //
            if let pp = stack.top() {
                if let right = pp.right {
                    stack.pop()
                    p = right
                } else {
                    stack.pop() // 把pp弹出
                    let parent = stack.pop() // 把pp的父节点弹出
                    p = parent?.right
                }
            }
        }
        return result
    }
    
    func postorder(_ root: TreeNode?) -> [Int] {
        // 一直往左子树访问，直到为空
        // 看下有没有右子树，如果有，则需要先访问右子树；如果没有则需要先访问当前节点，然后再找父节点的右子树
        return []
    }
    
    // MARK: - 求树深度
    /// 求树的深度（递归实现）
    /// - Parameter root:
    class func maxDepth(root: TreeNode?) -> Int {
        // 递归实现
        // maxDepth(root) = max(maxDepth(root.left), maxDepth(root.right))
        guard let root = root else { return -1 }
        return max(maxDepth(root: root.left), maxDepth(root: root.right)) + 1
    }
    
    /// 非递归实现求解树的深度
    /// 核心思想是将每一层的节点存放到一个数组或队列q中，每次循环都取出已有节点的所有孩子节点，然后将孩子节点序列赋值给q
    /// 知道q中没有数据
    /// 初始时，将根节点放到q中
    ///
    /// - Parameter root:
    /// - Returns:
    class func maxDepath1(root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        var queue: [TreeNode] = []
        var count = 0
        queue.append(root)
        
        while !queue.isEmpty {
            count += 1
            var childNodes: [TreeNode] = []
            for node in queue {
                if let leftChild = node.left {
                    childNodes.append(leftChild)
                }
                
                if let rightChild = node.right {
                    childNodes.append(rightChild)
                }
            }
            queue = childNodes
        }
        return count
    }
    
    // MARK: - 二叉树搜索
    
    
    /// 递归实现二叉树搜索某值
    ///
    /// - Parameters:
    ///   - value:
    ///   - root:
    /// - Returns:
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
    
    /// 非递归实现二叉树搜索
    ///
    /// - Parameters:
    ///   - val:
    ///   - root:
    /// - Returns: 
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
    
    // MARK: - 插入删除二叉树节点
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
        //    midOrder(root: root)
        //    insert(val: 100, root: root)
        print(maxDepth(root: root))
//            midOrder(root: root)
        //    deleteNodeOptimize(val: 33, root: root)
        //    deleteNode(val: 13, root: root)
        
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
    
    // MARK: - 递归实现前序、中序遍历二叉树
    
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
    
    // MARK: - 递归、非递归按层遍历二叉树
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
        // 当队列不为空时，取出队列的所有节点，将这些节点值放到res中下标为level的位置，如果没有则创建一个空数组再加入
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

/// 根据二叉树的前序和中序遍历序列，重新构建出二叉树
/// 这个题细节比较多，确实不容易做
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    if preorder.isEmpty || inorder.isEmpty {
        return nil
    }
    // 根据前序和中序序列，我们是能找到根节点和左右子树的范围的
    // 那么递归实现一把
    // 递归核心工作就是，找出根节点的值和左右子树范围，同时新建根节点，将左右子树通过递归形式赋值
    // 递归终止条件：当只剩下一个元素时
    
    /// range1表示树在前序遍历数组中的范围，range2表示在中序遍历序列中的范围
    func action(_ preLeft: Int?, _ preRight: Int?, _ midLeft: Int?, _ midRight: Int?) -> TreeNode? {
        //
        guard let preLeft = preLeft, let preRight = preRight, let midLeft = midLeft, let midRight = midRight else {
            return nil
        }
        
        if preLeft == preRight && midLeft == midRight {
            return TreeNode(preorder[preLeft])
        }
        
        let val = preorder[preLeft]
        let root = TreeNode(val)
        
        var p = midLeft
        var count = 0
        while inorder[p] != val {
            p += 1
            count += 1
        }
        let newLeftPreLeft = preLeft + 1
        let newLeftPreRight = preLeft + count
        let newLeftMidLeft = midLeft
        let newLeftMidRight = p - 1
        
        let newRightPreLeft = preLeft + count + 1
        let newRightPreRight = preRight
        let newRightMidLeft = p + 1
        let newRightMidRight = midRight
        //前序中的[preLeft + 1, preLeft + count]表示左子树，[preLeft+count+1, preRight]表示右子树
        //中序中的[p + 1, midRight]表示右子树, [midLeft, p - 1]表示左子树
        
        root.left = newLeftPreLeft > newLeftPreRight ? nil : action(newLeftPreLeft, newLeftPreRight, newLeftMidLeft, newLeftMidRight)
        root.right = newRightPreLeft > newRightPreRight ? nil : action(newRightPreLeft, newRightPreRight, newRightMidLeft, newRightMidRight)
        return root
    }
    
    return action(0, preorder.count - 1, 0, inorder.count - 1)
}

/// 给定一个序列，判断该序列是否为一棵二叉搜索树的后序遍历列表
func verifyPostorder(_ postorder: [Int]) -> Bool {
    // 根据二叉搜索树中序遍历是排好序的数组这一个特征，我们假定输入的序列是某个二叉搜索树的后序遍历序列，那么排好序的序列就是中序序列
    // 问题转化为检查这两个序列是否正确
    // 具体做法就是对这两个序列做拆分，看最终能否成功拆分
    
    // 核心递归工作：输入中序、后序两个序列，以及这两个序列对应的一对开始结束位置
    // 从后序序列中取出最后一个元素，在中序序列中寻找该值，如果找不到直接返回false；如果找到，则中序序列中的该值会将序列分为左子树和右子树两部分。对应到后序序列中，也能确定左右子树在后序序列中的起始位置
    // 继续进行递归
    // 终止条件：1. 当pstart > pend, instart > inend，返回true 2. pstart == pend, instart = inend，则比较两个的值，若相等则true，否则false
    // check，一个元素时
    if postorder.isEmpty { return false }
    let inorder = postorder.sorted()
    func split(pStart: Int, pEnd: Int, inStart: Int, inEnd: Int) -> Bool {
        if pStart > pEnd, inStart > inEnd {
            return true
        }
        
        if pStart == pEnd, inStart == inEnd {
            return postorder[pStart] == inorder[inStart]
        }
        
        let rootValue = postorder[pEnd]
        var p = inStart
        while p <= inEnd, inorder[p] != rootValue {
            p += 1
        }
        
        if inorder[p] != rootValue { return false }
        
        let leftInStart = inStart
        let leftInEnd = p - 1
        let leftCount = leftInEnd - leftInStart + 1
        let leftPStart = pStart
        let leftPEnd = leftPStart + leftCount - 1
        
        let leftResult = split(pStart: leftPStart, pEnd: leftPEnd, inStart: leftInStart, inEnd: leftInEnd)
        
        let rightInStart = p + 1
        let rightInEnd = inEnd
        let rightCount = rightInEnd - rightInStart + 1
        let rightPStart = pEnd - rightCount
        let rightPEnd = pEnd - 1
        let rightResult = split(pStart: rightPStart, pEnd: rightPEnd, inStart: rightInStart, inEnd: rightInEnd)
        return leftResult && rightResult
    }
    
    return split(pStart: 0, pEnd: postorder.count - 1, inStart: 0, inEnd: inorder.count - 1)
}

class BinaryTree {
    /// 用于多叉树的节点结构
     public class Node {
         public var val: Int
         public var children: [Node]
         public init(_ val: Int) {
             self.val = val
             self.children = []
         }
     }
    /// https://leetcode-cn.com/problems/binary-tree-preorder-traversal/
    func preorderTraversal(_ root: TreeNode?) -> [Int] {
        // 递归实现前序遍历
        // 递归结束条件，当遍历到空节点是返回
        var result: [Int] = []
        func preorder_r(_ node: TreeNode?) {
            guard let node = node else {
                return
            }
            result.append(node.val)
            preorder_r(node.left)
            preorder_r(node.right)
        }
        preorder_r(root)
        return result
    }
    
    /// https://leetcode-cn.com/problems/n-ary-tree-preorder-traversal/
    func preorder(_ root: Node?) -> [Int] {
        // n叉树的前序遍历
        // 递归实现，先将当前根节点的值放入结果集，再从左到右，前序遍历每个子树，递归每一步都在做该事情
        // 递归结束条件：到叶子节点时，即节点为nil时
        var result: [Int] = []
        func preorder_r(_ node: Node?) {
            guard let node = node else {
                return
            }
            result.append(node.val)
            for index in 0..<node.children.count {
                preorder_r(node.children[index])
            }
        }
        preorder_r(root)
        return result
    }
    
    /// https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/
    func levelOrder(_ root: TreeNode?) -> [Int] {
        // 定义一个levelNodes，同一时间只用于存放一层树种的节点
        // 每次循环都是遍历levelNodes中的节点，放入结果集中，同时更新levelNodes
        // 直到levelNodes为空
        guard let root = root else {
            return []
        }
        var levelNodes = [root]
        var result: [Int] = []
        while !levelNodes.isEmpty {
            var tmpLevelNodes: [TreeNode] = []
            for index in 0..<levelNodes.count {
                let curNode = levelNodes[index]
                result.append(curNode.val)
                if let leftNode = curNode.left {
                    tmpLevelNodes.append(leftNode)
                }
                if let rightNode = curNode.right {
                    tmpLevelNodes.append(rightNode)
                }
            }
            levelNodes = tmpLevelNodes
        }
        return result
    }
    
    /// https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-iii-lcof/
    func levelOrder1(_ root: TreeNode?) -> [[Int]] {
        // 按照之字，按层打印二叉树
        // 总体按层遍历思想不变，只是添加一个标记变量，表示下一层按照顺序or逆序往leveNodes中添加
        guard let root = root else {
            return []
        }
        var levelNodes = [root]
        var result: [[Int]] = []
        var isReversedOrder = true //
        while !levelNodes.isEmpty {
            // 为了满足之字行打印，有一个可以提高性能的方法
            // 使用栈结构，来存储下一层节点，每一次打印循环中，模拟栈的pop操作
            var tmpLevelNodes: [TreeNode] = [] // 下一行要存储的节点
            var tmpResult: [Int] = []
            
            for index in stride(from: levelNodes.count - 1, to: -1, by: -1) {
                let curNode = levelNodes[index]
                // 当前节点放入结果集
                tmpResult.append(curNode.val)
                // 下一层节点按照规定顺序进行存放
                if isReversedOrder {
                    if let ln = curNode.left { tmpLevelNodes.append(ln) }
                    if let rn = curNode.right { tmpLevelNodes.append(rn) }
                } else {
                    if let rn = curNode.right { tmpLevelNodes.append(rn) }
                    if let ln = curNode.left { tmpLevelNodes.append(ln) }
                }
            }
            isReversedOrder = !isReversedOrder
            result.append(tmpResult)
            levelNodes = tmpLevelNodes
        }
        return result
    }
    
    /// https://leetcode-cn.com/problems/find-bottom-left-tree-value/
    func findBottomLeftValue(_ root: TreeNode?) -> Int {
            // 可以递归实现,也可以非递归，通过按层遍历来实现
            // 先用递归实现下
            // 找树的最底层最左侧的节点，可以分解为：寻找根节点左子树中的最底左节点，右子树中的最底左节点，然后决断出两个节点哪个更合适。至于哪个更合适就看两个点的深度谁更大
            // 递归停止条件：叶子节点

            // 返回值第一个为value，第二个为height
            func findBottomLeftValue_r(_ node: TreeNode?, _ height: Int) -> (Int, Int)? {
                guard let node = node else {
                    return nil
                }
                let left = findBottomLeftValue_r(node.left, height+1)
                let right = findBottomLeftValue_r(node.right, height+1)
                
                if let left = left, let right = right {
                    return left.1 >= right.1 ? left : right
                } else if let left = left {
                    return left
                } else if let right = right {
                    return right
                } else {
                    return (node.val, height)
                }
            }
            if let x = findBottomLeftValue_r(root, 0) {
                return x.0
            } else {
                return -1
            }
        }
    /// https://leetcode.cn/problems/maximum-depth-of-binary-tree/
    func maxDepth(_ root: TreeNode?) -> Int {
        // 可以用递归实现
        // 最大深度问题可以分解为，root的左右子树最大深度更大的值+1；
        // root的子树的最大深度同样可以拆分成类似子问题
        // 递归结束条件，当到达叶子节点时，由于叶子节点没有子节点，所有最大深度就为1，直接返回即可
        guard let root = root else {
            return 0
        }
        if root.left == nil && root.right == nil {
            return 1
        }
        
        return max(maxDepth(root.left), maxDepth(root.right)) + 1
    }
    
    /// https://leetcode.cn/problems/maximum-depth-of-n-ary-tree/
    func maxDepth1(_ root: Node?) -> Int {
        // 类似上面问题的递归思路
        guard let root = root else {
            return 0
        }
        
        if root.children.isEmpty {
            return 1
        }
        
        var maxDepth = 0
        for child in root.children {
            let depth = maxDepth1(child)
            if depth > maxDepth {
                maxDepth = depth
            }
        }
        return maxDepth + 1
    }
    
    /// https://leetcode.cn/problems/ping-heng-er-cha-shu-lcof/
    func isBalanced(_ root: TreeNode?) -> Bool {
        // 尝试一下递归思路能不能解决
        // 如果root的左子树和右子树之间的深度（最大深度）之差小于等于1，则说明是平衡二叉树
        // 如果root的左子树是平衡二叉树，右子树也是平衡二叉树，则root也是平衡二叉树
        // 如果root的其中一个子树不是平衡二叉树，则root也不是平衡二叉树
        // 经过分析，可以用递归
        // 每次递归做这样的事情：如果左右子树
        
        enum Status {
            case balanced(Int) ///< 表示平衡的
            case notBalanced   ///< 不平衡
        }
        
        func isBalanced_r(_ node: TreeNode?) -> Status {
            // 递归的判断node是不是平衡的
            // 核心递归的工作：
            // 递归结束条件，当遇到叶子节点时，就是平衡的，而且深度是1
            guard let node = node else {
                return .balanced(0)
            }
            
            if node.left == nil && node.right == nil {
                return .balanced(1)
            }
            
            let leftTreeStatus = isBalanced_r(node.left)
            let rightTreeStatus = isBalanced_r(node.right)
            
            switch (leftTreeStatus, rightTreeStatus) {
            case (.balanced(let leftDepth), .balanced(let rightDepth)):
                if abs(leftDepth - rightDepth) <= 1 {
                    return .balanced(max(leftDepth, rightDepth) + 1)
                } else {
                    return .notBalanced
                }
            default:
                return .notBalanced
            }
        }
        
        let status = isBalanced_r(root)
        switch status {
        case .balanced:
            return true
        case .notBalanced:
            return false
        }
    }
    
    /// https://leetcode.cn/problems/balanced-binary-tree/
    func isBalanced1(_ root: TreeNode?) -> Bool {
        // 通过递归的求解树的高度，过程中判断一下高度是否满足平衡二叉树的条件，得到结果
        // 求解树的高度，可以转化为子问题，max(左子树的高度，右子树的高度)+1
        // 递归结束条件：当node==nil时，高度为0
        var isBalanced = true
        
        func depth(_ node: TreeNode?) -> Int {
            guard let node = node else {
                return 0
            }
            
            if !isBalanced { return 0 }
            let leftDepth = depth(node.left)
            let rightDepth = depth(node.right)
            
            if abs(leftDepth - rightDepth) > 1 {
                isBalanced = false
            }
            
            return max(leftDepth, rightDepth) + 1
        }
        
        depth(root)
        return isBalanced
    }
    
    /// https://leetcode.cn/problems/merge-two-binary-trees/
    func mergeTrees(_ root1: TreeNode?, _ root2: TreeNode?) -> TreeNode? {
        // 递归思路
        // 递归核心工作：两个节点的左子树进行合并，两个节点的右子树进行合并；完事后，两个根节点进行合并
        // 递归结束条件：若两个节点都为空，则返回空；若其中一个为空，则返回另一个
        
        func mergeTrees(_ node1: TreeNode?, _ node2: TreeNode?) -> TreeNode? {
            if node1 == nil, node2 == nil {
                return nil
            } else if node1 == nil {
                return node2
            } else if node2 == nil {
                return node1
            }
            
            let leftMergedTree = mergeTrees(node1?.left, node2?.left)
            let rightMergedTree = mergeTrees(node1?.right, node2?.right)
            
            let newTreeNode = TreeNode(node1!.val + node2!.val)
            newTreeNode.left = leftMergedTree
            newTreeNode.right = rightMergedTree
            
            return newTreeNode
        }
        
        return mergeTrees(root1, root2)
    }
    
    /// https://leetcode.cn/problems/symmetric-tree/
    func isSymmetric(_ root: TreeNode?) -> Bool {
        // 对称二叉树
        // 核心思想：该问题难点在于，将一棵树是否对称的问题，转为两棵树是否对称
        // 如果root的左右子树是对称的，那总体就是对称的
        // 那如何判断两棵树a、b是否对称呢
        // 这就可以递归解决了：如果a的左子树与b的右子树对称，且a右子树与b的左子树对称，且a和b的根节点值相等
        // 递归结束条件：a和b都为空，则返回true；a或b为空，则返回false
        func isSymmetric_r(_ node1: TreeNode?, _ node2: TreeNode?) -> Bool {
            if node1 == nil, node2 == nil {
                return true
            } else if node1 == nil || node2 == nil {
                return false
            }
            
            let isLeftTreeSymmetric = isSymmetric_r(node1?.left, node2?.right)
            let isRightTreeSymmetric = isSymmetric_r(node1?.right, node2?.left)
            if isLeftTreeSymmetric && isRightTreeSymmetric && node1!.val == node2!.val {
                return true
            }
            return false
        }
        
        guard let root = root else {
            return true
        }
        return isSymmetric_r(root.left, root.right)
    }
    
    /// https://leetcode.cn/problems/validate-binary-search-tree/
    func isValidBST(_ root: TreeNode?) -> Bool {
        // 递归思想
        // 该问题核心点在于，如果只是左右子树是BST的话，没办法推导出整棵树是BST
        // 左右子树必须是BST，同时当前根节点的值要大于左子树的最大值，同时小于右子树的最小值餐才可以
        // 具体的实现代码如下：
        // 记录左右子树递归过程中（两个变量），左子树的最大值和右子树的最小值
        // 递归结束的条件：当递归到叶子节点时，认为是有效的BST，同时更新
        /// 该方法做两件事情，判断node是否为BST，同时更新min和max，min和max分别表示node所表示的树中最小最大值
        typealias TreeInfo = (isBST: Bool, max:Int, min: Int)
        func isValidBST_r(_ node: TreeNode?) -> TreeInfo {
            guard let node = node else {
                return (true, Int.min, Int.max)
            }
            if node.left == nil && node.right == nil {
                return (true, node.val, node.val)
            }
            
            let leftInfo = isValidBST_r(node.left)
            // 此处只用到左子树中的最大值，即max
            if !leftInfo.isBST || node.val <= leftInfo.max {
                return (false, Int.max, Int.min)
            }
            
            let rightInfo = isValidBST_r(node.right)
            // 此处只用到右子树中的最小值，即min
            if !rightInfo.isBST || node.val >= rightInfo.min {
                return (false, Int.max, Int.min)
            }
            return (true, max(rightInfo.max, node.val), min(leftInfo.min, node.val))
        }
        return isValidBST_r(root).isBST
    }
    /// https://leetcode.cn/problems/er-cha-sou-suo-shu-de-di-kda-jie-dian-lcof/
    func kthLargest(_ root: TreeNode?, _ k: Int) -> Int {
        // 按照中序遍历，得到一个排好序的数组，直接取值
        var count = 0 // 记录元素个数
        var array: [Int] = []
        func inorder(_ node: TreeNode?) {
            guard let node = node else {
                return
            }
            inorder(node.left)
            array.append(node.val)
            count += 1
            inorder(node.right)
        }
        
        inorder(root)
        if count == 0 { return -1 }
        return array[count-k]
    }
    /// https://leetcode.cn/problems/convert-bst-to-greater-tree/
    func convertBST(_ root: TreeNode?) -> TreeNode? {
        // 中序遍历树，得到sum
        // 有个变量记录pre值，默认为0
        // 然后再中序遍历一遍进行赋值，node.val = sum - pre
        guard let root = root else {
            return root
        }

        var sum = 0
        var pre = 0
        
        func inorder_sum(_ node: TreeNode?) {
            guard let node = node else {
                return
            }
            inorder_sum(node.left)
            sum += node.val
            inorder_sum(node.right)
        }
        
        inorder_sum(root)
        
        func inorder_assignment(_ node: TreeNode?) {
            guard let node = node else {
                return
            }
            inorder_assignment(node.left)
            node.val = sum - pre
            pre += node.val
            inorder_assignment(node.right)
        }
        inorder_assignment(root)
        return root
    }
    
    /// https://leetcode.cn/problems/binary-search-tree-to-greater-sum-tree/
    func bstToGst(_ root: TreeNode?) -> TreeNode? {
        // 和上题目一样，本次使用更高效的方式
        // bst中序遍历后比如是这样[1,2,3,4,5]
        // Gst也就是结果树对应的中序遍历是[15, 14, 12, 9, 5]
        // 其实可以通过右子树->根节点->左子树的反向中序遍历顺序来遍历，一边遍历一遍来更新节点值
        // 比如更新到第一个时，将值更新为bst[4]，更新到第二个就更新为bst[4]+bst[3]
        
        var sum = 0
        func reverseInOrder(_ node: TreeNode?) {
            guard let node = node else {
                return
            }
            reverseInOrder(node.right)
            sum += node.val
            node.val = sum
            reverseInOrder(node.left)
        }
        reverseInOrder(root)
        return root
    }
    
    /// https://leetcode.cn/problems/P5rCT8/
    func inorderSuccessor(_ root: TreeNode?, _ p: TreeNode?) -> TreeNode? {
        // 递归实现
        // 添加一个全局变量，控制读取p下一个节点
        var isComming = false
        var finished = false
        var targetNode: TreeNode?
        func findSuccessorInorder(_ node: TreeNode?) {
            if node == nil {
                return
            }
            
            findSuccessorInorder(node?.left)
            if finished { return } // finished写在这一行很关键
            
            if isComming {
                targetNode = node
                finished = true
                return
            }
            
            if node === p {
                isComming = true
            }
            
            findSuccessorInorder(node?.right)
        }
        findSuccessorInorder(root)
        return targetNode
    }
}
