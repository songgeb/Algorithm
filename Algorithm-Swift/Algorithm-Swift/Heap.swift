//
//  Heap.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/12/3.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

class Heap {
  /// 堆最大容量
  private let capacity: Int
  private(set) var data: [Int]
  /// 当前已存储的数据数量
  private var count: Int
  private let big: Bool
  var top: Int? {
    if count == 0 { return nil }
    return data[1]
  }
  ///
  /// - Parameter capacity:
  /// - Parameter big: 默认大顶堆，false表示小顶堆
  init(capacity: Int, big: Bool = true) {
    self.capacity = capacity
    self.data = Array<Int>.init(repeating: 0, count: 1)
    self.count = 0
    self.big = big
  }
  
  /// 堆中插入元素
  /// - Parameter value:
  func insert(_ value: Int) {
    if count == capacity { return }
    // 先插入数组中
    // 自下而上进行堆化
    data.append(value)
    count += 1
    heapfyFromBottom(count)
  }
  
  /// 删除堆顶元素
  @discardableResult
  func delete() -> Int? {
    if count == 0 { return nil }
    // 数组中删除该元素
    // 将最后一个元素放到堆顶位置，进行自上而下的堆化
    let first = data[1]
    data[1] = data[count]
    count -= 1
    data.removeLast()
    if count == 0 {
      return first
    }
    
    heapfyFromTop()
    return first
  }
  
  /// 自上而下堆化
  private func heapfyFromTop() {
    if count == 0 { return }
    // 假设大顶堆
    var cIndex = 1
    // 自上而下和自下而上堆化一个重要的不同点在于：自上而下时，既要看当前节点，又要看左子节点和右子节点
    // 1. 当前值c和左子节点l，和右子节点r，找出最大值index = max(c, l, r)
    // 2. if cIndex != index, swap(cIndex, index), update cIndex, repeat 1
    // 3. else break
    
    while true {
      var toSwapIndex = cIndex
      let l = cIndex << 1
      let r = l + 1
      if big {
        if l <= count, data[l] > data[cIndex] {
          toSwapIndex = l
        }
        
        if r <= count, data[r] > data[toSwapIndex] {
          toSwapIndex = r
        }
      } else {
        if l <= count, data[l] < data[cIndex] {
          toSwapIndex = l
        }
        
        if r <= count, data[r] < data[toSwapIndex] {
          toSwapIndex = r
        }
      }
      
      if toSwapIndex != cIndex {
        data.swapAt(toSwapIndex, cIndex)
        cIndex = toSwapIndex
      } else {
        break
      }
    }
  }
  
  /// 自下而上堆化
  /// - Parameter index:
  private func heapfyFromBottom(_ index: Int) {
    // 假设大顶堆
    //1. 当前值c与父节点p比较
    //2. 若c > p, 则交换c和p，更新c。回到步骤1
    //3. 若c < p, 则结束
    if index > count { return }
    var cursor = index
    while true {
      let c = data[cursor]
      let pIndex = cursor >> 1
      if pIndex <= 0 { break }
      let p = data[pIndex]
      if (big && c > p) || (!big && c < p) {
        data.swapAt(cursor, pIndex)
        cursor = pIndex
      } else {
        break
      }
    }
  }
}

/// 找到top k大数据
/// - Parameter nums:
/// - Parameter k:
func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
  if nums.count < k { return -1 }
  // 维护一个大小为K的小顶堆
  // 遍历数组，填充满堆
  // 继续遍历数组，当数组元素c大于堆顶元素top，则删除堆顶元素，插入c
  // 知道遍历结束
  
  let heap = Heap(capacity: k, big: false)
  for index in 0..<k {
    heap.insert(nums[index])
  }
  print(heap.data)
  for index in k..<nums.count {
    let c = nums[index]
    if c > heap.top! {
      let d = heap.delete()
      print("删除\(d!)")
      print(heap.data)
      print("插入\(c)")
      heap.insert(c)
      print(heap.data)
    }
  }
  
  return heap.top!
}

func testKth() {
  let array = [3,2,3,1,2,4,5,5,6,7,7,8,2,3,1,1,1,10,11,5,6,2,4,7,8,5,6]
//  let array = [3,2,1,5,6,4]
  let x = findKthLargest(array, 2)
  print(x)
}
