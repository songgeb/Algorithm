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
}
