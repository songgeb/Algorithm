//
//  File.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/7/29.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

/// 链表节点
class ListNode: Hashable {
    static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var val: Int
    var next: ListNode?
    
    init(_ val: Int) {
        self.val = val
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

/// 单向链表
class List {
    var head: ListNode?
    var tail: ListNode?
    
    func appendToTail(_ val: Int) {
        let tailNode = ListNode(val)
        if head == nil {
            head = tailNode
        } else {
            tail?.next = tailNode
        }
        tail = tailNode
    }
    
    func appendToHead(_ val: Int) {
        let headNode = ListNode(val)
        if head == nil {
            head = headNode
            tail = headNode
        } else {
            headNode.next = head
            head = headNode
        }
    }
    
    func print() {
        var current = head
        while current != nil {
            Swift.print(current?.val)
            current = current?.next
        }
    }
}

class LinkedList {
    
    func printList(_ node: ListNode?) {
        var current = node
        while current != nil {
            Swift.print(current?.val)
            current = current?.next
        }
    }
    
    func findMiddle(_ list: List) -> ListNode? {
        // 如果是空链表返回空
        if list.head == nil {
            return nil
        }
        
        // 两个指针，一快一慢，两指针从head开始，快指针q一次走两次，慢指针p一次走两次，直到快指针走不动了，那p指针就是中点
        // 如果节点有偶数个，没有正好的中点，那最终得出的p是左半部分最接近中点的节点
        var p = list.head
        var q = list.head
        while q?.next?.next != nil {
            p = p?.next
            q = q?.next?.next
        }
        return p
    }
    
    /// 链表实现回文字符串能检测(时间复杂度O(n))
    func palindrome(_ list: List) -> Bool {
        // 找到链表中点(前提必须知道链表长度)
        // 快慢指针，per和la
        // 使用快慢指针将后半部分链表翻转
        // 翻转后，前半部分和后半部分一次对比，如果相同则是回文
        guard let head = list.head else {
            return false
        }
        if head.next == nil {
            return true
        }
        
        // middle
        let middle = findMiddle(list)
        middle?.next = reverseList(middle?.next)
        
        // 从前往后，middle到结束，一个一个的比较
        var firstHalfCurrent: ListNode? = head
        var lastHalfCurrent = middle?.next
        
        // 关于链表的遍历
        while lastHalfCurrent != nil {
            if firstHalfCurrent?.val != lastHalfCurrent?.val {
                return false
            }
            firstHalfCurrent = firstHalfCurrent?.next
            lastHalfCurrent = lastHalfCurrent?.next
        }
        // 看网上的答案，此处循环虽然不会出错，但不够好
        // 问题在于，没有判断first是否为nil
        // 之所以不会出问题是因为，两个指针遍历的次数是相等的
        return true
    }
    
    // 链表原地翻转
    func reverseList(_ node: ListNode?) -> ListNode? {
        // 翻转的核心是操作指针
        // 一个指针不行，得两个移动的指针和一个临时指针
        // 两个指针一前一后pre和current，用临时指针记录下current.next，用于执行下一次循环
        // 将current的next指向pre，实现核心的翻转操作
        // pre指针前进到current位置，为下次循环做准备
        // current指针也要前进，前进到临时指针的位置
        // 但这样有个问题，算法最开始，pre指针应该指向谁呢？
        // 可以指向第一个节点，但这样有问题：在成功翻转后，第一个节点的next应该是nil才对，如果算法开始时，pre指针指向第一个的话，那上面的算法逻辑中，就得对这种情况特殊处理了。
        // 有一种比较好的方式是：最开始时，将pre指向nil，current指向第一个节点，这样的话，将第一个节点的next设置为nil的操作就自动包含在上面的逻辑中了。完美
        // 再考虑下，循环啥时候结束呢？应该是current为nil的时候
        
        if node == nil { return nil }
        var pre: ListNode? = nil
        var current = node
        
        while current != nil {
            let currentNext = current?.next
            current?.next = pre
            pre = current
            current = currentNext
        }
        return pre
    }
    /// 递归实现链表翻转
    func reverseList1(_ head: ListNode?) -> ListNode? {
        // 尝试看下递归能否实现
        // 一般情况下，一个节点如何进行翻转
        // 1. 当前节点为cur，先记录下cur.next来，然后cur.next = cur
        // 2. 对cur.next，做同样的事情
        // 看样子递归也可以实现，核心工作就是上面两条
        // 终止条件：当接收到的节点是空，则结束
        // check：1个节点，ok；没有节点，ok
        
        /// 将node和node.next进行翻转，并返回翻转后的开始节点
        func action(_ node: ListNode?, _ next: ListNode?) -> ListNode? {
            
            guard let next = next else {
                return node
            }
            
            let nnext = next.next
            next.next = node
            return action(next, nnext)
        }
        return action(nil, head)
    }
    
    func createLinkedList(_ values: [Int]) -> List {
        let list = List()
        values.forEach({
            list.appendToTail($0)
        })
        return list
    }
    
    /// 使用递归思想检测单链表中的回文
    func palindromeByRecursion(_ head: ListNode?) {
        // 递归一层一层递归结束后，会跑到尾结点，到尾结点后，递归会往上一层一层的反
        // 反的过程中，我们可以用一个递归外部的指针和递归内部的指针，进行一个个比较，恰好是回文的比较方式
        // check边界条件，空节点时ok，一个节点时ok，两个或多个节点
        // check奇数、偶数个节点情况，奇数偶数都ok
        var pre = head
        func printListRecursively(_ head: ListNode?) -> Bool {
            if head != nil {
                let result = printListRecursively(head?.next)
                if !result { return false }
                print("正在比较->pre:\(pre?.val), last:\(head?.val)")
                // 第一次执行时，是最后一个节点，随着递归结束，一层一层往上反
                if head?.val != pre?.val {
                    print("不相等，退出")
                    return false
                } else {
                    pre = pre?.next
                    print("相等，切换到下一个:\(pre?.val)")
                    return true
                }
            }
            return true
        }
        
        let result = printListRecursively(head)
        print("进行比较，是否是回文->\(result)")
        
    }
    
    /// 单向链表检测是否有环
    /// - Parameter head:
    func hasCircle(_ head: ListNode?) -> Bool {
        print(#function)
        // 两个指针，一快一慢，都从头结点开始，快的一次走两个节点，慢的一次走一个
        // 如果有环，因为快指针始终比慢指针快两个节点，所以当慢指针到达环的开始节点时，此时快指针应该在慢指针前面n个节点的位置，n是0或者2的倍数
        // 继续走下去，快指针就会把慢指针套圈了，n圈后，两个指针必定重合
        // 当然如果知道链表结束都没有重合，说明没有环
        if head == nil { return false }
        if head?.next?.next == nil { return false }
        var quickNode, slowNode: ListNode?
        quickNode = head
        slowNode = head
        while quickNode != nil {
            quickNode = quickNode?.next?.next
            slowNode = slowNode?.next
            print("快指针->\(quickNode?.val), 慢指针->\(slowNode?.val)")
            if quickNode?.val == slowNode?.val {
                return true
            }
        }
        return false
    }
    // 哈希表检测是否有环，同时返回环开始节点
    func circleStartNode(_ head: ListNode?) -> ListNode? {
        // 这是检测环的升级版，不但要检测环，还要知道环的起始节点
        // 用哈希表或字典来实现
        // 哈希表的key存储节点，value存储该节点被指向的个数
        // 遍历链表每个节点，每遍历一个节点，该节点对应的value就加1，value从0开始
        // 在加1前先判断value是否大于1，若大于1，则表示有两个节点指向了同一个节点，该节点便是环的起始节点
        var nodeReferenceCounts: [ListNode: Int] = [:]
        var currentNode = head
        while currentNode != nil {
            guard let node = currentNode else { return nil }
            if let count = nodeReferenceCounts[node] {
                if count == 1 { return node }
            } else {
                nodeReferenceCounts[node] = 1
            }
            currentNode = currentNode?.next
        }
        return nil
    }
    
    /// 快慢指针实现检测链表环，同时返回环的起点
    /// - Parameter head:
    /// - Returns:
    func circleStartNodeByPointer(_ head: ListNode?) -> ListNode? {
        // check
        if head == nil { return nil }
        // 空节点时--ok  1个节点时，ok
        // 2个节点且是环时，ok
        // 一快一慢指针，快的走两步，慢的走一步，当两个相寓了就说明有环
        var quickNode, slowNode: ListNode?
        quickNode = head
        slowNode = head
        
        var hasCircle = false
        while quickNode != nil {
            quickNode = quickNode?.next?.next
            slowNode = slowNode?.next
            if quickNode != nil, quickNode == slowNode { // 注意nil情况
                hasCircle = true
                break
            }
        }
        
        if !hasCircle { return nil }
        
        // 有了环后，将其中一个指针弄回到起始位置，两个指针一步一步走，相遇了就是环起点
        // 其内在的数学逻辑可以参考github
        slowNode = head
        while slowNode != quickNode {
            slowNode = slowNode?.next
            quickNode = quickNode?.next
        }
        
        return slowNode
    }
    
    /// 合并两个有序
    /// - Parameters:
    ///   - head1:
    ///   - head2:
    func mergeOrderedList(_ head1: ListNode?, _ head2: ListNode?) -> ListNode? {
        // 合并两个有序的链表
        // 新开辟一个链表，两个链表，给两个指针，分别指向当前链表已遍历的最小的值
        // 若两个指针有一个没遍历到结束，就执行while循环，选择最小值追加到新开辟的链表中
        // while结束后，可能有个链表还剩一部分，把这一部分追加到新链表中
        
        // check, head1或head2为空时，ok
        // 其中一个链表只有一个结点，ok
        // 其他情况，ok
        var p1, p2: ListNode?
        p1 = head1
        p2 = head2
        
        let list = List()
        while let p1value = p1?.val, let p2value = p2?.val {
            if p1value > p2value {
                list.appendToTail(p2value)
                p2 = p2?.next
            } else {
                list.appendToTail(p1value)
                p1 = p1?.next
            }
        }
        
        if p1 != nil {
            while let p1Value = p1?.val {
                list.appendToTail(p1Value)
                p1 = p1?.next
            }
        }
        
        if p2 != nil {
            while let p2Value = p2?.val {
                list.appendToTail(p2Value)
                p2 = p2?.next
            }
        }
        
        return list.head
    }
    /// 递归实现有序链表合并
    func mergeOrderedList1(_ head1: ListNode?, _ head2: ListNode?) -> ListNode? {
        // 递归核心工作：比较两个链表中当前节点，选出一个较小的节点A，让其他的节点继续递归，并把A.next赋值为递归的结果值
        // 终止条件：如果其中有一个是空了，则返回两一个节点
        
        func merge(_ node1: ListNode?, _ node2: ListNode?) -> ListNode? {
            guard let node1 = node1 else {
                return node2
            }
            guard let node2 = node2 else {
                return node1
            }
            if node1.val <= node2.val {
                node1.next = merge(node1.next, node2)
                return node1
            } else {
                node2.next = merge(node1, node2.next)
                return node2
            }
        }
        
        return merge(head1, head2)
    }
    
    /// 单链表删除倒数第n个结点
    /// - Parameter n:
    func deletePenultimateNthNode(_ n: Int, _ head: ListNode?) -> ListNode? {
        if head == nil { return nil }
        if n <= 0 { return nil }
        // 两个指针，一前一后，两个指针间隔n-1个结点
        // 前面指针在起点开始，大家一起走，后面的指针走到最后一个结点时，停止前进，此时前面的指针就是倒数第n个了
        
        //check，head为空时，ok
        //n是0的情况，ok
        //n是1的情况，ok
        var front, rear: ListNode?
        front = head
        rear = front
        
        var count = 1
        while count < n {
            rear = rear?.next
            count += 1
        }
        
        if rear == nil { return nil }
        
        while rear?.next != nil {
            front = front?.next
            rear = rear?.next
        }
        
        return front
    }
    
    func createCircleList() -> List {
        let list = List()
        list.appendToTail(1)
        list.appendToTail(2)
        // 没有环
//        return list
        // 2个节点，全是环
//        list.tail?.next = list.head
//        return list
        // 大于两个节点，全是环
//        list.appendToTail(3)
//        list.tail?.next = list.head
//        return list
        // 部分环
        // 1->2->3->4->5->6->7---->4
        list.appendToTail(3)
        let node = ListNode(4)
        list.tail?.next = node
        list.tail = node
        list.appendToTail(5)
        list.appendToTail(6)
        list.appendToTail(7)
        list.tail?.next = node
        return list
    }
    
    /// 检测回文数测试
    func palindromeTest() {
        let data = [1, 2, 1]
        print("初始链表->\(data)")
        let list = createLinkedList(data)
        palindromeByRecursion(list.head)
    }
    
    func testCircleDetetor() {
//        let list = createLinkedList(data)
        let list = createCircleList()
//        print(hasCircle(list.head))
//        print(circleStartNode(list.head)?.val)
        print(circleStartNodeByPointer(list.head)?.val)
    }
    
    func testDeletion() {
        let data = [1, 2, 1, 4, 5, 7, 3, 9]
        print("初始链表->\(data)")
        let list = createLinkedList(data)
        
        let deleteNode = deletePenultimateNthNode(8, list.head)
        print(deleteNode?.val)
    }
}

/// 从尾到头打印单向链表
/// 方法1: 先翻转过来，再打印。这样会破坏原链表结构 O(n)时间复杂度
/// 方法2: 不修改原链表结构。可以让每个节点入栈，然后再出栈打印，所以可以使用递归技巧实现，时间复杂度也是O(n)
func reversePrint(_ head: ListNode?) -> [Int] {
    // 下面使用方法2实现
    // 递归核心工作: 1. 继续递归下个节点 2. 打印当前节点值
    // check，空链表--ok，只有一个节点ok
    
    var result: [Int] = []
    
    func action(_ node: ListNode?) {
        guard let node = node else { return }
        action(node.next)
        result.append(node.val)
    }
    
    action(head)
    return result
}

