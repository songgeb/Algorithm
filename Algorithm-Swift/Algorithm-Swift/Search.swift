//
//  Find.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/8/27.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

// MARK: - 二分查找

/// 非递归二分查找
func bbsearch(_ array: inout [Int], targetValue: Int) -> Int? {
  var low = 0
  var high = array.count - 1
  
  while low <= high {
    let mid = low + ((high - low) >> 1)
    let midValue = array[mid]
    if midValue == targetValue {
      return mid
    } else if midValue > targetValue {
      high = mid - 1
    } else {
      low = mid + 1
    }
  }
  
  return nil
}

/// 递归二分查找
func brsearch(_ array: inout [Int], targetValue: Int, low: Int, high: Int) -> Int? {
  //停止条件
  if low > high { return nil }
  let mid = low + ((high - low) >> 1)
  let midValue = array[mid]
  let result: Int?
  if targetValue == midValue {
    return mid
  } else if targetValue < midValue {
    result = brsearch(&array, targetValue: targetValue, low: low, high: mid - 1)
  } else {
    result = brsearch(&array, targetValue: targetValue, low: mid + 1, high: high)
  }
  return result
}

/// 二分查找，查找第一个、最后一个值等于给定值的元素--自己拙劣的实现
func bsearchFirst(_ arr: inout [Int], targetValue: Int, low: Int, high: Int, isFirst: Bool) -> Int? {
  // 1. 先按照通常二分查找的路子找到给定值元素，若找不到则返回nil
  // 2. 若找到后，则继续以找到的位置-1为high，low不变，继续二分查找的找，若找不到，则说明是第一个等于给定值的
  // 3. 若找到了，则从2开始执行
  
  var left = low
  var right = high
  var targetIndex: Int?
  
  // 1
  while left <= right {
    let middle = left + (right - left) / 2
    let middleValue = arr[middle]
    if middleValue == targetValue {
      targetIndex = middle
      break
    } else if middleValue < targetValue {
      left = middle + 1
    } else {
      right = middle - 1
    }
  }
  
  if targetIndex == nil { return nil }
  // 2
  var firstTargetIndex: Int? = targetIndex
  var findNewFirstTarget = false
  repeat {
    if isFirst {
      right = firstTargetIndex! - 1
    } else {
      left = firstTargetIndex! + 1
    }
    
    findNewFirstTarget = false
    while left <= right {
      let middle = left + (right - left) / 2
      let middleValue = arr[middle]
      if middleValue == targetValue {
        firstTargetIndex = middle
        findNewFirstTarget = true
        break
      } else if middleValue < targetValue {
        left = middle + 1
      } else {
        right = middle - 1
      }
    }
    
  } while findNewFirstTarget
  
  return firstTargetIndex
}


/// 寻找第一个等于给定值的下标
/// - Parameter arr: <#arr description#>
/// - Parameter targetValue: <#targetValue description#>
/// - Parameter low: <#low description#>
/// - Parameter high: <#high description#>
func bsearch_optimize1(_ arr: inout [Int], targetValue: Int, low: Int, high: Int) -> Int? {
  //1. 查找第一个等于给定值的下标
  // - 当mid的value值大于或小于给定值时，按照原有逻辑
  // - 当mid的value值等于给定值时，若mid值是第一个或者mid-1小于给定值，那么说明mid已经是第一个等于给定值的下标了
  // - 否则，继续在mid的左边寻找，所以让left = mid - 1
  
  var left = low
  var right = high
  while left <= right {
    let mid = left + ((right - left) >> 1)
    let midValue = arr[mid]
    if midValue < targetValue {
      left = mid + 1
    } else if midValue > targetValue {
      right = mid - 1
    } else {
      if mid == 0 || arr[mid - 1] < targetValue { return mid }
      right = mid - 1
    }
  }
  
  return nil
}

/// 查找最后一个小于等于目标值的下标
/// - Parameter arr: <#arr description#>
/// - Parameter targetValue: <#targetValue description#>
/// - Parameter low: <#low description#>
/// - Parameter high: <#high description#>
func bsearch_optimize2(_ arr: inout [Int], targetValue: Int, low: Int, high: Int) -> Int? {
  // 1. 查找最后一个小于等于目标值的下标
  // 当mid的value值大于目标值时，原有逻辑
  // 当mid的value值小于等于目标值时，那要看mid是不是最后一个，如果是最后一个或者mid+1的value值大于目标值，那就找到了
  //否则，right = mid + 1
  
  var left = low
  var right = high
  while left <= right {
    let mid = left + ((right - left) >> 1)
    let midValue = arr[mid]
    if midValue > targetValue {
      right = mid - 1
    } else {
      if mid == high || arr[mid + 1] > targetValue { return mid }
      left = mid + 1
    }
  }
  
  return nil
}
/// 二分查找旋转有序数组中某个给定值
func bsearch_rotatearray(_ arr: inout [Int], targetValue: Int, low: Int, high: Int) -> Int? {
  // 先通过二分查找，找到分界点，即最小值，然后再分别在两个有序数组中继续用二分查找
  // 此处假定没有重复数
  guard let minIndex = bsearch_findmin(&arr, low: low, high: high) else {
    return nil
  }
  
  if let leftIndex = brsearch(&arr, targetValue: targetValue, low: 0, high: minIndex - 1) {
    return leftIndex
  } else if let rightIndex = brsearch(&arr, targetValue: targetValue, low: minIndex, high: high) {
    return rightIndex
  } else {
    return nil
  }
}

func bsearch_findmin(_ arr: inout [Int], low: Int, high: Int) -> Int? {
  if arr.count == 0 { return nil }
  // 用二分查找循环有序数组中的最小值
  // 循环有序数组是这样的  [4, 5, 6, 1, 2, 3]，可能存在重复值，比如[1, 1, 1, 1, 0, 1]
  // 使用二分查找可以将时间复杂度降到logn
  
  // 算法
  // 既然是二分法，我们尝试用中间值midValue与其他值比，那么与哪个值比较呢？
  // 先来比较一下左边界值leadingValue
  // 如果midValue < leadingValue，那midValue可能是最小值，但不可能是在mid右边的范围，应该去左边的范围去找，right = mid
  // 如果midValue > leadingValue，那midValue肯定不是最小值，但在mid右边的范围，left = mid + 1
  // 如果midValue == leadingValue，既可能在左边也可能在右边，也可能是midValue本身，此时去掉leading即可，即left = leading + 1
  var left = low
  var right = high
  while left < right {
    let mid = left + (right - left) >> 1
    let midValue = arr[mid]
    let trailingValue = arr[right]
    if midValue < trailingValue {
      right = mid
    } else if midValue > trailingValue {
      left = mid + 1
    } else {
      right -= 1
    }
  }
  return left
}

/// 在循环有序数组中查找某个元素，用二分查找
func findValue(_ nums: [Int], _ targetValue: Int) -> Int? {
    if nums.count <= 1 { return nil }
    //思路1
    // 遍历数组，找到循环临界点，将数组分为两个有序数组
    // 记住这两个有序数组的最小值
    // 根据这两个最小值判定，放到这两个数组中其中一个中去寻找
    // 时间复杂度O(n)
//    var firstMinIndex: Int?
//    var secondMinIndex: Int?
//
//    firstMinIndex = 0
//    for (index, value) in nums.enumerated() {
//        if index != 0 {
//            if nums[index] < nums[index - 1] {
//                secondMinIndex = index
//                break
//            }
//        }
//    }
//
//    guard let smIndex = secondMinIndex,
//          let fmIndex = firstMinIndex
//    else {
//        return nil
//    }
//    // 分成两个数组来处理
    func binarySearch(_ low: Int, _ high: Int, _ targetValue: Int) -> Int? {
        var low = low
        var high = high
        while low <= high {
            let middle = low + (high - low) >> 1
            let middleValue = nums[middle]
            if targetValue == middleValue {
                return middle
            } else if targetValue > middleValue {
                low = middle + 1
            } else {
                high = middle - 1
            }
        }
        return nil
    }
//
//    if targetValue >= nums[fmIndex] {
//        return binarySearch(fmIndex, smIndex - 1)
//    } else {
//        return binarySearch(smIndex, nums.count - 1)
//    }
    
    // 思路2
    // 1. 取middle值，如果nums[0] <= nums[middle]，说明[0, middle]有序，[middle+1, end]循环
    // 如果nums[0] > nums[middle]，说明[middle+1, end]有序，[0, middle]循环
    // 总之经过上面操作后，肯定会得出两个子数组的情况
    // 2. 如果目标值在有序数组中，直接用二分查找找下去
    // 3. 如果目标值在循环数组中，则继续按照1、2、3的顺序继续操作
    // 中间可能会有找不到的情况
    
    // 先用递归实现
    // 递归表达式，就是上面的1、2、3个逻辑
    // 终止条件是，start > end
//    func goon(_ start: Int, _ end: Int) -> Int? {
//        if start > end { return nil }
//
//        let middle = start + (end - start) >> 1
//        if nums[start] <= nums[middle] {
//            // [start middle]有序
//            if targetValue >= nums[start], targetValue <= nums[middle] {
//                return binarySearch(start, middle, targetValue)
//            } else {
//                // [middle + 1, end]循环
//                return goon(middle + 1, end)
//            }
//        } else {
//            // [middle + 1, end]有序
//            if targetValue >= nums[middle + 1], targetValue <= nums[end] {
//                return binarySearch(middle + 1, end, targetValue)
//            } else {
//                // [start, middle]循环
//                return goon(start, middle)
//            }
//        }
//    }
//    return goon(0, nums.count - 1)
    
    // 思路2，非递归实现一把
    // 感觉do while结构更合适
    var start = 0, end = nums.count - 1
    repeat {
        let middle = start + (end - start) >> 1
        if nums[start] <= nums[middle] {
            // [start, middle]有序
            if targetValue >= nums[start], targetValue <= nums[middle] {
                return binarySearch(start, middle, targetValue)
            } else {
                // 去[middle + 1, end]中找
                start = middle + 1
            }
        } else {
            // [start, middle]是循环，[middle+1, end]有序
            if targetValue >= nums[middle + 1], targetValue <= nums[end] {
                return binarySearch(middle + 1, end, targetValue)
            } else {
                end = middle
            }
        }
    } while start <= end
    return nil
}

/// 用二分查找法计算一个正整数的平方根，精确到小数点后6位
///
/// - Parameter n:
func sqrt(_ n: Int) -> Double {
    // 二分查找大约值
    // 使用介值定理可知，对于y = x^2这个连续的函数，如果找到x=m1, x=m2使得m1^2小于n，m2^2大于n，那一定存在一个值m使得m^2等于n
    if n < 1 { return -1 }
    var low: Double = 1
    var high: Double = Double(n)
    
    while low <= high {
        let middle = low + (high - low) / 2
        print("low->\(low), high->\(high)")
        let square = middle * middle
        let xx = abs(square - Double(n))
        print("square->\(square)   abs->\(xx)")
        if xx <= 1e-12 {
            return middle
        } else if square - Double(n) > 1e-12 {
            high = middle - 1e-6
        } else {
            // Double(n) - square > 1e-6
            low = middle + 1e-6
        }
        print("after----------")
        print("low->\(low), high->\(high)")
    }
    return -1
}

class Search {
  static func testBinarySearch() {
    var array = [1, 3, 4, 5, 8, 8, 8, 8, 8, 18]
    // 0 7 3 4567
    // 4 7 5
    // 6 7 6
    // 7 7 7
    // 8 7 x
//    let index = bbsearch(&array, targetValue: 45)
//    let index = brsearch(&array, targetValue: 456, low: 0, high: 7)
//    let index = bsearchFirst(&array, targetValue: 8, low: 0, high: array.count - 1, isFirst: true)
//    let index = bsearch_optimize2(&array, targetValue: 8, low: 0, high: 9)
    var ax = [3,4,5,1,2]
    let index = bsearch_rotatearray(&ax, targetValue: 2, low: 0, high: 4)
    print(index)
  }
}
