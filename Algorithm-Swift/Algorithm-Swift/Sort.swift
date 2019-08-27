//
//  Sort.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/8/8.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

// 排序


/// 冒泡
/// 拿从小到大排序来说，冒泡是，一次一次的将最大的沉底，或将最小的上浮，最终实现排序
/// 如何沉底呢？要有比较和交换的操作，相邻两个元素比较，大的交换到后面
/// 一共执行n次（每个元素都冒一次泡），每一次要进行比较的元素在变少，第一次是比较n个，第二次的话，最后一个元素已经排好了，只需要比较剩下的n-1个就行了，a[j]和a[j+1]进行比较，若a[j] > a[j+1]就交换
///
/// - Parameter array:
func bubbleSort(_ array: inout [Int]) {
  let length = array.count
  for i in stride(from: 0, to: length, by: 1) {
    var flag = false
    // 开启本次冒泡
    for j in stride(from: 1, to: length - i, by: 1) {
      // 沉底
      if array[j] < array[j-1] {
        let tmp = array[j-1]
        array[j-1] = array[j]
        array[j] = tmp
        flag = true
      }
    }
    // 本次冒泡没有任何交换，说明已经排好序了
    if !flag { break }
  }
}

/// 插入排序，核心思想是插入
/// 如何插入、往哪插入是关键。从前往后插入，插到合适的位置，插入的这些元素成为有序区
///
/// - Parameter array:
func insertionSort(_ array: inout [Int]) {
  if array.count <= 1 { return }
  let length = array.count
  for i in stride(from: 1, to: length, by: 1) {
    let insertValue = array[i]
    var insertIndex = i
    for j in stride(from: i - 1, to: -1, by: -1) {
      if insertValue < array[j] {
        array[j+1] = array[j]
        insertIndex = j
      } else {
        break
      }
    }
    
    array[insertIndex] = insertValue
  }
}

/// 选择排序
/// 选择啥呢？冒泡算法也是选择啊，每次选择最大的沉底也叫选择排序啊，为啥那个叫冒泡算法，这个就叫做选择排序呢？
func selectionSort(_ array: inout [Int]) {
  // 对于数组中每个元素，每次选择一个最小的，放到相应的位置
  let length = array.count
  for i in stride(from: 0, to: length, by: 1) {
    var minIndex = i
    
    for j in stride(from: i + 1, to: length, by: 1) {
      if array[j] < array[minIndex] {
        minIndex = j
      }
    }
    
    // 交换minIndex和i
    let tmp = array[minIndex]
    array[minIndex] = array[i]
    array[i] = tmp
  }
}

/// 归并排序
/// 分治思想，一个无序的数组，分成两半，对左右两半递归的分下去，最终子问题就变成了只剩下一个元素
/// 对每次递归分出来的两半数组进行合并排序
/// 合并排序，要借助新的数组，将排序的元素放到新数组中，拍好后，拷贝到原数组
func mergeSort(_ array: inout [Int], start: Int, end: Int) {
  if start >= end {
    return
  }
  // 将start...half 和 (half+1)...end 合并到start...end中
  func merge(_ array: inout [Int], start: Int, end: Int, half: Int) {
    let tmpLength = end - start + 1
    var tmpArray = Array(repeating: 0, count: tmpLength)
    
    var lIndex = start
    var rIndex = half + 1
    var cIndex = 0
    while lIndex <= half && rIndex <= end {
      let l = array[lIndex]
      let r = array[rIndex]
      if l < r {
        tmpArray[cIndex] = l
        lIndex += 1
      } else {
        tmpArray[cIndex] = r
        rIndex += 1
      }
      cIndex += 1
    }
    
    while lIndex <= half {
      tmpArray[cIndex] = array[lIndex]
      lIndex += 1
      cIndex += 1
    }
    
    while rIndex <= end {
      tmpArray[cIndex] = array[rIndex]
      rIndex += 1
      cIndex += 1
    }
    
    cIndex = 0
    for index in start...end {
      array[index] = tmpArray[cIndex]
      cIndex += 1
    }
  }
  
  let half = (end + start) / 2
  mergeSort(&array, start: start, end: half)
  mergeSort(&array, start: half + 1, end: end)
  merge(&array, start: start, end: end, half: half)
}

/// 快速排序
/// 为什么快？
func quickSort(_ array: inout [Int], start: Int, end: Int) {
  print("开始点->\(start), 结束点->\(end)")
  if start >= end {
    print("本次作废")
    return
  }
  print("分解前->\(array)")
  let point = partition2(&array, start: start, end: end)
  print("分解后的点是->\(point)")
  print("此时数组->\(array)")
  quickSort(&array, start: start, end: point - 1)
  quickSort(&array, start: point, end: end)
}


/// 最简单暴力的方法
///
func partition() {
  
}

/// 原地分区函数，将一个数组按照某个值pivot，分成小于pivot、等于pivot和大于pivot三个区域
/// 两个指针从前往后
func partition1(_ array: inout [Int], start: Int, end: Int) -> Int {
  if start < 0 || end < 0 || array.count < 2 { return -1 }
  if start >= end { return -1 }
  
  // 两个指针，i、j
  // 选择第一个元素作为pivot
  // <= i的元素是比pivot小或相等的
  // > i小于j的元素是比pivot大的，> j的元素是未知的
  // i从0开始，j从i的下一个开始
  // j往后移动，如果遇到
  return -1
}

/// 两个指针一前一后
func partition2(_ array: inout [Int], start: Int, end: Int) -> Int {
  if start < 0 || end < 0 { return -1 }
  if start > end { return -1 }
  if start == end { return start }
  //pivot可以选择第一个或者最后一个
  //i指向开始，j指向结尾
  // 从任意一头开始，比如从i这一头，如果元素小于piovt则前进， 大于等于pviot，则停止；注意不能超过j
  // 从j开始，如果元素大于等于pivot，则往左前进，小于pivot时则停止；注意j不能小于i
  // 此时如果i<j，则说明位置的元素大于等于pivot，j位置的元素小于pivot；对这两个元素进行交换
  // 最后要注意，到最后i会和j重合，如果先从左边开始扫描的，，此时i的位置是大于pivot的。所以此时如果选择数组第一个元素作为pivot的话，然后直接将位置的值和pivot交换的话，就不对了。
  // 所以，如果选择数组第一个元素作为pivot，那应该先从右向左扫描，这样最终的i、j位置的值就是小于pivot，此时再交换位置的值和pivot的值就牟问题了。或者，选择元素最后一个作为pivot的话，就可以先从左到右扫描了
  
  // 还有，pivot所在的位置除了最后的交换，其余不能被赋值或者说不能被挪动
  // 所以要求，从左往右扫描时，得用array[i] <= pivot的判断条件，否则pivot会被挪走
  let pivot = array[start]
  var i = start
  var j = end
  while i != j {
    
    while i < j && array[i] <= pivot {
      i += 1
    }
    
    while i < j && array[j] > pivot {
      j -= 1
    }
    
    if i < j {
      let tmp = array[i]
      array[i] = array[j]
      array[j] = tmp
    }
  }
  
  array[start] = array[j]
  array[j] = pivot
  return j
}

class Sort {
  static func testBubbleSort() {
    // 生成随机数组
    var array = (0...10).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    bubbleSort(&array)
    print(array)
  }
  
  static func testInsertionSort() {
    // 生成随机数组
    var array = (0...10).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    insertionSort(&array)
    print(array)
  }
  
  static func testSelectionSort() {
    // 生成随机数组
    var array = (0...0).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    selectionSort(&array)
    print(array)
  }
  
  static func testMergeSort() {
    var array = (0...10).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    mergeSort(&array, start: 0, end: array.count - 1)
    print(array)
  }
  
  static func testPartition() {
    var array = (0...10).map { (value) -> Int in
      value + 1
      return Int.random(in: 1...100)
    }
    array = [13, 63, 1, 21, 20, 2, 37, 46, 9, 13]
//    array = [3, 7, 8, 1, 4, 10, 2, 5, 6, 9]
    print("原数组->\(array)")
//    quickSort(&array, start: 0, end: array.count - 1)
    let result = partition2(&array, start: 0, end: array.count - 1)
    print(array)
    print(result)
  }
}
