//
//  BinarySearch.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2022/4/29.
//  Copyright © 2022 Songgeb. All rights reserved.
//
/// 二分查找相关算法
import Foundation

class BinarySearch {
    
    /// https://leetcode-cn.com/problems/binary-search/
    func search(_ nums: [Int], _ target: Int) -> Int {
        // 标准二分查找算法--非递归实现
        // 左右各一个指针
        var left = 0
        var right = nums.count - 1
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            if nums[middleIndex] == target {
                return middleIndex
            } else if nums[middleIndex] > target {
                right = middleIndex - 1
            } else {
                left = middleIndex + 1
            }
        }
        return -1
    }
    
    /// 递归方式实现二分查找
    func searchRecursion(_ nums: [Int], _ target: Int) -> Int {
        // 递归核心工作：计算出middleIndex，比较是否与target相等；若相等则返回有效的index，若不相等则根据情况进行递归执行
        // 递归结束条件：left > right时
        
        func r(_ left: Int, _ right: Int) -> Int {
            if left > right { return -1 }
            let middleIndex = left + (right - left) >> 1
            if nums[middleIndex] == target {
                return middleIndex
            } else if nums[middleIndex] > target {
                return r(left, right - 1)
            } else {
                return r(left + 1, right)
            }
        }
        
        return r(0, nums.count - 1)
    }
    
    /// https://leetcode-cn.com/problems/guess-number-higher-or-lower/
    func guessNumber(_ n: Int) -> Int {
        // 猜数字游戏，二分的思想查找最快
        // 先猜[0, n]之间的一般，比如猜guessNum，如果guessNum == real，则返回real；若guessNum > real，则在[0, guessNum-1]之间继续找；否则在[guessNum+1, n]之间找
        var left = 0
        var right = n
        while left <= right {
            let guessNum = left + (right - left) >> 1
            
//            if 猜中 {
//                return 1
//            } else guessNum > real {
//                right = guessNum - 1
//            } else
        }
        return -1
    }
    
    /// https://leetcode-cn.com/problems/find-smallest-letter-greater-than-target/
    func nextGreatestLetter1(_ letters: [Character], _ target: Character) -> Character {
        // 这个字母比较挺有意思，是按照字母表循环起来进行比较的，比如[a,b]的数组中，target为z时，第一个比z大的元素是a
        // 可以理解为寻找大于target中的第一个值
        // 当然暴力破解也可以：挨个遍历，找到第一个i>target，并返回；如果找不到则返回数组中第一个元素。时间复杂度为O(n)
        // 本次还是尝试使用二分查找
        // 分两种情况，策略各不同
        // 1. 若target就在letters中，则使用二分肯定可以猜中，返回猜中的下一个元素即可
        // 2. 若target不在letters中，同样用二分查找，找到最后，会找到最接近target的值，比如nearest
        // 接2继续，若nearest > target，则就是该值；反之，则结果为找下一个元素
        
        #warning("该方法没有考虑重复数据的情况")
        let count = letters.count
        var left = 0
        var right = count - 1
        var middleIndex = 0
        while left <= right {
            middleIndex = left + (right - left) >> 1
            if letters[middleIndex] == target {
                let index = (middleIndex + 1) % count
                return letters[index]
            } else if letters[middleIndex] > target {
                right = middleIndex - 1
            } else {
                left = middleIndex + 1
            }
        }
        // target不在letters中
        if letters[middleIndex] > target {
            return letters[middleIndex]
        } else {
            return letters[(middleIndex + 1) % count]
        }
    }
    
    func nextGreatestLetter(_ letters: [Character], _ target: Character) -> Character {
        var left = 0
        var right = letters.count - 1
        var latestBiggerValue: Character? = nil // 最近的大于target的值
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            let middleValue = letters[middleIndex]
            if middleValue == target {
                left = middleIndex + 1
            } else if middleValue > target {
                right = middleIndex - 1
                latestBiggerValue = middleValue
            } else {
                left = middleIndex + 1
            }
        }
        
        if let v = latestBiggerValue {
            return v
        } else {
            // letters中的元素都小于target
            return letters.first!
        }
    }
    
    /// https://leetcode-cn.com/problems/search-insert-position/
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        // 情况1：二分查找，找到则返回下标
        // 情况2：找不到时，若nearestValue > target，则返回nearestIndex - 1；若nearestValue < target，则返回nearestIndex + 1
        var left = 0
        var right = nums.count - 1
        var nearestIndex = -1
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            nearestIndex = middleIndex
            let middleValue = nums[middleIndex]
            if middleValue == target {
                return middleIndex
            } else if middleValue > target {
                right = middleIndex - 1
            } else {
                left = middleIndex + 1
            }
        }
        
        if nums[nearestIndex] > target {
            let index = nearestIndex - 1
            return index < 0 ? 0 : index
        } else {
            return nearestIndex + 1
        }
    }
    
    /// https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array/
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        // 先用二分找到目标值，后面的事情比较关键
        // 后面是要找到目标值的左和右边界，还是要用二分，同时去左边和右边去找边界
        // 以寻找左边边界为例，每次二分时，if middleValue == target时，则将right变为middleIndex-1，继续在左半部分寻找；if middleValue < target，则在右半部分寻找。这个过程中要记录middleIndex。最后返回该值
        // 寻找右边界时是类似的，if middleValue == target，则将left = middleIndex+1，继续；if middleValue > target，则right = middlIndex-1。最终返回middleIndex
        // 寻找左边界和右边界的方法都结束后，进行最终边界的判断
        // if nums[leftBoundary] == target，则真正的leftBoundary可能是leftBoundary-1
        // else，leftBoundary就是左边界
        // if nums[rightBoundary] == target，则真正的rightBoundary可能是rightBoundary+1
        // else rightBoundary就是右边界
        // 所以总体算法是外层有一个二分查找，找到目标值后还是
        
        func findBoundary(_ left: Int, _ right: Int, _ isLeft: Bool) -> Int {
            var l = left
            var r = right
            var middleIndex = -1
            while l <= r {
                middleIndex = l + (r - l) >> 1
                let middleValue = nums[middleIndex]
                if isLeft {
                    if middleValue == target {
                        r = middleIndex - 1
                    } else {
                        l = middleIndex + 1
                    }
                } else {
                    if middleValue == target {
                        l = middleIndex + 1
                    } else {
                        r = middleIndex - 1
                    }
                }
            }
            return middleIndex
        }
        
        let count = nums.count
        var left = 0
        var right = count - 1
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            let middleValue = nums[middleIndex]
            if middleValue == target {
                var leftBoundary = findBoundary(left, middleIndex - 1, true)
                var rightBoundary = findBoundary(middleIndex+1, right, false)
                if leftBoundary < 0 {
                    leftBoundary = left //找不到边界，说明left与middleIndex-1之间镁元素了
                } else if nums[leftBoundary] != target {
                    leftBoundary = leftBoundary + 1 >= count ? leftBoundary : leftBoundary + 1
                }
                if rightBoundary < 0 {
                    rightBoundary = right
                } else if nums[rightBoundary] != target {
                    rightBoundary = rightBoundary - 1 < 0 ? rightBoundary : rightBoundary - 1
                }
                return [leftBoundary, rightBoundary]
            } else if middleValue > target {
                right = middleIndex - 1
            } else {
                left = middleIndex + 1
            }
        }
        return [-1, -1]
    }
    
    /// https://leetcode-cn.com/problems/sparse-array-search-lcci/
//    func findString(_ words: [String], _ s: String) -> Int {
//
//    }
    
    /// https://leetcode-cn.com/problems/peak-index-in-a-mountain-array/
    func peakIndexInMountainArray(_ arr: [Int]) -> Int {
        // 找山峰的关键在于：计算完middleValue后，看一下middleIndex的左右的元素
        let count = arr.count
        var left = 0
        var right = count - 1
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            let middleValue = arr[middleIndex]
            if middleIndex + 1 <= right {
                if arr[middleIndex+1] > middleValue {
                    left = middleIndex + 1
                } else {
                    right = middleIndex
                }
            } else if middleIndex - 1 >= left {
                if arr[middleIndex - 1] > middleValue {
                    right = middleIndex - 1
                } else {
                    left = middleIndex
                }
            } else {
                return middleIndex
            }
        }
        return -1
    }
    
    /// https://leetcode-cn.com/problems/find-peak-element/
    func findPeakElement(_ nums: [Int]) -> Int {
        let count = nums.count
        var left = 0
        var right = count - 1
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            let middleValue = nums[middleIndex]
            if middleIndex + 1 <= right {
                if nums[middleIndex+1] > middleValue {
                    left = middleIndex + 1
                } else {
                    right = middleIndex
                }
            } else if middleIndex - 1 >= left {
                if nums[middleIndex - 1] > middleValue {
                    right = middleIndex - 1
                } else {
                    left = middleIndex
                }
            } else {
                return middleIndex
            }
        }
        return -1
    }
    
    /// https://leetcode-cn.com/problems/valid-perfect-square/
    func isPerfectSquare(_ num: Int) -> Bool {
        // 简单粗暴的O(n)的复杂度下可以搞定
        // 此处用更快的二分思想
        var left = 1
        var right = num
        while left <= right {
            let middle = left + (right - left) >> 1
            let t = middle * middle
            if t == num {
                return true
            } else if t > num {
                right = middle - 1
            } else {
                left = middle + 1
            }
        }
        return false
    }
    
    /// https://leetcode-cn.com/problems/search-a-2d-matrix/
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        // 可以先在第n列中用二分进行搜索，如果搜到则直接返回true；
        // 如果没有搜到的话，会找该列中最接近target的值nearest
        // if target > nearest，则说明可能在下一行
        // if target < nearest，则说明可能在上一行
        // 需要一个可复用的子方法，实现在二维数组中进行二分搜索
        
        ///
        /// - Parameter rowIndex:
        /// - Returns: 找到返回true，找不到返回false
        func binarySearchOnRow(rowIndex: Int) -> Bool {
            return false
        }
        let rowNum = matrix.count
        let colNum = matrix[0].count
        var left = 0
        var right = rowNum - 1
        var latestMiddleRowIndex = -1
        while left <= right {
            let middleRowIndex = left + (right - left) >> 1
            let middleValue = matrix[middleRowIndex][colNum-1]
            latestMiddleRowIndex = middleRowIndex
            if middleValue == target {
                return true
            } else if middleValue > target {
                right = middleRowIndex - 1
            } else {
                left = middleRowIndex + 1
            }
        }
        
        // 程序运行到此处，说明在最后一列中没有找到target值
        // 我们可能需要继续在行中寻找
        if matrix[latestMiddleRowIndex][colNum-1] > target {
            latestMiddleRowIndex -= 1
        } else {
            latestMiddleRowIndex += 1
        }
        if latestMiddleRowIndex < 0 || latestMiddleRowIndex >= rowNum {
            return false
        }
        
        left = 0
        right = colNum - 1
        while left <= right {
            let middleColIndex = left + (right - left) >> 1
            let middleValue = matrix[latestMiddleRowIndex][middleColIndex]
            if middleValue == target {
                return true
            } else if middleValue > target {
                right = middleColIndex - 1
            } else {
                left = middleColIndex + 1
            }
        }
        return false
    }
    
    /// https://leetcode-cn.com/problems/search-in-rotated-sorted-array/
    func search1(_ nums: [Int], _ target: Int) -> Int {
        //旋转数组搜索
        // if middle >= leftValue，说明[left, middle]是递增的，此时如果target在这个区间，就更新right
        // 如果不在区间，就去另一个区间去寻找
        // if middle < left，则说明[middle right]是递增区间，如果target在递增区间则更新left；如果不在区间则去另一个区间寻找
        // 关键点在于第一个判断条件（middle >= leftValue）中的等号，这是一个边界情况，需要考虑到
        var left = 0
        var right =  nums.count - 1
        while left <= right {
            let middleIndex = left + (right - left) >> 1
            let middleValue = nums[middleIndex]
            if middleValue == target {
                return middleIndex
            } else if middleValue >= nums[left] {
                // [left, middle]是递增序列
                if target >= nums[left] && target < middleValue {
                    right = middleIndex - 1
                } else {
                    left = middleIndex + 1
                }
            } else {
                // [middle, right]是递增序列
                if target > middleValue && target <= nums[right] {
                    left = middleIndex + 1
                } else {
                    right = middleIndex - 1
                }
            }
        }
        return -1
    }
    
    /// https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/
    func findMin(_ nums: [Int]) -> Int {
        // 通过画图（使用[4,5,6,1,2,3]举例）可以看出来，该题二分的关键在于
        // 每次选择最小值所在的那一半
        // if middleValue > leftValue，则说明[left, middle]是递增的，最小值应该在右侧[middle+1, right]（其实该条件还有点问题）
        // if middleValue <= leftValue，则说明[middle, right]是递增的，最小值可能处在[left, middle]中
        // 再看一下特殊情况，比如三个元素、两个元素、1个元素时
        // 发现使用[5,1,3]举例时，当区间缩小到[5,1]时，第二个条件就是错的了
        // 可以尝试将条件1改为middleValue >= leftValue，同时条件2改成middleValue < leftValue
        // 发现改完后，对于[5,1,3]这个例子仍然有问题，就是当区间缩小为[1]时，最终无法正确返回结果
        // 原因是我们的二分退出条件是left <= right，只有left>right时才会退出，此时已经错过了正确结果
        // 所以还要加入退出条件，即left == right时
        // 下面再来看最前面提到的条件1存在的问题，就是对于完全升序的数组来说条件1是错的
        // 再加入一个条件，如果完全升序时，其实无需继续计算返回nums[left]即可
        // 再看下两个元素和1个元素的情况，都没问题
        var left = 0
        var right = nums.count - 1
        while left <= right {
            if left == right { return nums[left] }
            if nums[right] > nums[left] { return nums[left] }
            
            let middleIndex = left + (right - left) >> 1
            let middleValue = nums[middleIndex]
            if middleValue >= nums[left] {
                left = middleIndex + 1
            } else {
                right = middleIndex
            }
        }
        return -1
    }
}
