//
//  Queue.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/8/6.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

/// 顺序队列(假定数组长度固定，不允许动态变长度)
class ArrayQueue {
  private var items: [Int]
  private let length: Int
  
  /// 队首
  private var head: Int
  
  /// 入队时可以插入的下标，队尾
  private var tail: Int

  init(length: Int) {
    self.length = length
    self.items = [Int](repeating: 0, count: length)
    self.items.reserveCapacity(length)
    
    self.head = 0
    self.tail = 0
  }
  
  func enqueue(_ item: Int) -> Bool {
    if tail == length {
      print("队列已满无法插入!")
      return false
    }
    
    items[tail] = item
    print("'\(item)' 进入队列!")
    tail += 1
    return true
  }
  
  func dequeue() -> Int? {
    if head == tail {
      print("队列已空无法取值!")
      return nil
    }
    
    let item = items[head]
    print(" '\(item)' 出队列!")
    head += 1
    return item
  }
  
  func enqueueWithAutomaticFitting(_ item: Int) -> Bool {
    if tail == length {
      if head == 0 {
        print("队列已满无法插入!")
        return false
      }
      
      //
      print("队尾放不下了，数据前移，腾空间")
      for index in head..<length {
        items[index - head] = items[index]
      }
      
      tail = length - head
      head = 0
    }
    items[tail] = item
    
    print("'\(item)' 进入队列!")
    tail += 1
    return true
  }
  
  func printQueue() {
    for index in head..<tail {
      print(items[index])
    }
  }
}

/// 循环队列
class CircularQueue {
  private var items: [Int]
  private let length: Int
  
  /// 队首
  private var head: Int
  
  /// 入队时可以插入的下标，队尾
  private var tail: Int
  
  init(length: Int) {
    self.length = length
    self.items = [Int](repeating: 0, count: length)
    self.items.reserveCapacity(length)
    
    self.head = 0
    self.tail = 0
  }
  
  func enqueue(_ item: Int) -> Bool {
    if (tail + 1) % length == head {
      print("循环队列满了!")
      return false
    }
    
    print("位置\(tail) 入队 \(item)")
    items[tail] = item
    tail = (tail+1) % length
    return true
  }
  
  func dequeue() -> Int? {
    if head == tail {
      return nil
    }
    
    let item = items[head]
    print("位置\(head) 出队 \(item)")
    head = (head + 1) % length
    return item
  }
  
  func printQueue() {
    for index in 0..<length {
      print(items[index])
    }
  }
}

class QueueTest {
  static func testQueueBase() {
    
  }
  
  static func testEnqueue() {
    let arrayQueue = ArrayQueue(length: 10)
    for index in 0...10 {
      arrayQueue.enqueue(index)
    }
    
    for index in 0...3 {
      arrayQueue.dequeue()
    }
    
    for index in 0...7 {
      arrayQueue.enqueueWithAutomaticFitting(index)
    }
    
    arrayQueue.printQueue()
  }
  
  static func testCircularQueue() {
    let arrayQueue = CircularQueue(length: 10)
    for index in 0...10 {
      arrayQueue.enqueue(index)
    }
    
    for index in 0...3 {
      arrayQueue.dequeue()
    }
    
    arrayQueue.enqueue(3)
    
    arrayQueue.enqueue(4)
    arrayQueue.enqueue(4)
    arrayQueue.enqueue(4)
    arrayQueue.enqueue(4)
    
    arrayQueue.printQueue()
  }
}
