//
//  File.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/7/29.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

class ListNode {
  var val: Int
  var next: ListNode?
  
  init(_ val: Int) {
    self.val = val
  }
}

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
    // 如果两个指针遍历的次数不等，如果
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
  
  func palindromeTest() {
    let list = List()
    
    list.appendToTail(-1)
    list.appendToTail(2)
    list.appendToTail(1)
    
//    for index in 0...1 {
//      list.appendToTail(index)
//    }
//    for index in stride(from: 5, to: 0, by: -1) {
//      list.appendToTail(index)
//    }
    
    list.print()
    
//    print("中点是\(findMiddle(list)?.val)")
    
    print(palindrome(list))
  }
}
