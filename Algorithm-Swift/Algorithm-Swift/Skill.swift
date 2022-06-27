//
//  Skill.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2022/6/14.
//  Copyright © 2022 Songgeb. All rights reserved.
//

import Foundation

class Skill {
    // MARK: - 双指针
    /// https://leetcode.cn/problems/reverse-string/
    func reverseString(_ s: inout [Character]) {
        // 原地翻转，双指针进行交换
        var i = 0
        var j = s.count - 1
        while i < j {
            s.swapAt(i, j)
            i += 1
            j -= 1
        }
    }
    
    /// https://leetcode.cn/problems/move-zeroes/
    func moveZeroes(_ nums: inout [Int]) {
        // 参考快排的partition方法
        // 左侧为不为0的值，右侧为0
        // i 表示待交换的位置，j表示遍历指针
        let count = nums.count
        var i = 0
        var j = 0
        while j < count {
            if nums[j] != 0 {
                nums.swapAt(i, j)
                i += 1
            }
            j += 1
        }
    }
    
    /// https://leetcode.cn/problems/smallest-difference-lcci/
    func smallestDifference(_ a: [Int], _ b: [Int]) -> Int {
        // 两个数组排好序
        // 两个指针从头开始，初始最小绝对值为Int.max
        // if arr[i] < arr[j]，记录下绝对值后，让i+=1，才可能得到更小的绝对值
        // if arr[i] > arr[j]，则让j+=1
        // if arr[i] == arr[j] return 0
        var i = 0
        var j = 0
        var minValue = Int.max
        let newA = a.sorted()
        let newB = b.sorted()
        while i < newA.count, j < newB.count {
            let value = abs(newA[i]-newB[j])
            if value < minValue { minValue = value }
            if newA[i] < newB[j] {
                i += 1
            } else if newA[i] > newB[j] {
                j += 1
            } else {
                return minValue
            }
        }
        return minValue
    }
    
    /// https://leetcode.cn/problems/pairs-with-sum-lcci/
    func pairSums(_ nums: [Int], _ target: Int) -> [[Int]] {
        // 对nums先从小到大排序
        // 两个指针，一头一尾，i和j
        // if i + j > target，则j-=1；if i+j < target，则i+=1；if i+j == target，则进入结果集，并且i+=1且j-=1
        var result: [[Int]] = []
        let nums = nums.sorted()
        var i = 0
        var j = nums.count - 1
        while i < j {
            let v = nums[i] + nums[j]
            if v > target {
                j -= 1
            } else if v < target {
                i += 1
            } else {
                result.append([nums[i], nums[j]])
                i += 1
                j -= 1
            }
        }
        return result
    }
    
    /// https://leetcode.cn/problems/find-closest-lcci/
    func findClosest(_ words: [String], _ word1: String, _ word2: String) -> Int {
        // 快慢指针大概能解决
        // 从words起始点开始，两个指针i和j
        // if nums[i] == word1，则开始遍历j，直到找到word2
        // if nums[i] == word2，则开始遍历j，直到找到word1
        // else的话，i和j都向前走
        // 整个循环，保证i<length和j<length
        var minDistance = Int.max
        var i = 0
        var j = 0
        var secondWord = ""
        let count = words.count
        while i < count, j < count {
            if words[i] == word1 || words[i] == word2 {
                secondWord = words[i] == word1 ? word2 : word1
                while j < count, words[j] != secondWord { j += 1 }
                if j < count, j - i < minDistance {
                    minDistance = j - i
                }
                i += 1
                j = i
            } else {
                i += 1
                j += 1
            }
        }
        return minDistance
    }
    
    /// https://leetcode.cn/problems/3sum/
    func threeSum(_ nums: [Int]) -> [[Int]] {
        // 该题并不简单
        // 以-4 -1 -1 0 1 2为例
        // 我们固定一个值a，在后序的数组中寻找和为-a的数对
        // 注意要避免重复结果的情况
        func twoSum(_ nums: [Int], start: Int, end: Int, target: Int) -> [[Int]] {
            // if i + j > target, j -= 1
            // if i + j < target, i += 1
            // if i + j == target, add to result, i += 1, j -= 1
            var i = start
            var j = end
            var result: [[Int]] = []
            while i < j {
                // 避免重复数据
                if i - 1 >= start, nums[i-1] == nums[i] {
                    i += 1
                    continue
                }
                if j + 1 <= end, nums[j+1] == nums[j] {
                    j -= 1
                    continue
                }
                let v = nums[i] + nums[j]
                if v > target {
                    j -= 1
                } else if v < target {
                    i += 1
                } else {
                    result.append([nums[i], nums[j]])
                    i += 1
                    j -= 1
                }
            }
            return result
        }
        
        // 固定每一个元素为a，然后求解剩余的数据
        let nums = nums.sorted()
        let count = nums.count
        var result: [[Int]] = []
        for (index, num) in nums.enumerated() {
            if index - 1 >= 0, nums[index - 1] == nums[index] { continue }
            let subResults = twoSum(nums, start: index + 1, end: count - 1, target: -num)
            if !subResults.isEmpty {
                subResults.forEach {
                    var subResult = $0
                    subResult.append(num)
                    result.append(subResult)
                }
            }
        }
        return result
    }
    
    // MARK: - 滑动窗口
    
    /// https://leetcode.cn/problems/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof/
    func lengthOfLongestSubstring(_ s: String) -> Int {
        if s.isEmpty { return 0 }
        let chars = Array(s)
        var p = 0
        var q = 0
        var maxLength = q - p + 1
        let count = chars.count
        var set: Set<Character> = [ chars[0] ]
        q += 1
        while q < count {
            if set.contains(chars[q]) {
                // 让p前进，同时要从set删除元素，直到chars[p]==chars[q]停止
                while chars[p] != chars[q] {
                    set.remove(chars[p])
                    p += 1
                }
                p += 1 //该行执行之前chars[p]==chars[q]，比如acbbdc为例，此时p在第一个b的位置，q在第二个b的位置，需要让p前进到第二个p的位置，再继续后序的遍历
                q += 1
            } else {
                let length = q - p + 1
                if length > maxLength { maxLength = length }
                set.insert(chars[q])
                q += 1
            }
        }
        return maxLength
    }
    
    /// https://leetcode.cn/problems/find-all-anagrams-in-a-string/
    func findAnagrams(_ s: String, _ p: String) -> [Int] {
        let pCount = p.count
        if s.count < pCount { return [] }
        // 两个hashmap，一个表示p，一个表示滑动窗口的状态
        // p和q两个下标，表示滑动窗口，p和q同时前进，直到q到头
        var windowMap: [Character: Int] = [:]
        var pMap: [Character: Int] = [:]
        // 初始化map
        for c in p {
            if let count = pMap[c] {
                pMap[c] = count + 1
            } else {
                pMap[c] = 1
            }
        }
        
        let chars = Array(s)
        for i in 0..<pCount {
            if let count = windowMap[chars[i]] {
                windowMap[chars[i]] = count + 1
            } else {
                windowMap[chars[i]] = 1
            }
        }
        let sCount = chars.count
        // 初始化pq,p=0，q=p.count-1
        var p = 0
        var q = pCount - 1
        var result: [Int] = []
        while q < sCount {
            if windowMap == pMap {
                result.append(p)
            }
            // remove char in windowMap
            if let count = windowMap[chars[p]], count == 1 {
                windowMap.removeValue(forKey: chars[p])
            } else {
                windowMap[chars[p]] = windowMap[chars[p]]! - 1
            }
            p += 1
            // add char in windowMap
            q += 1
            if q < sCount {
                if let count = windowMap[chars[q]] {
                    windowMap[chars[q]] = count + 1
                } else {
                    windowMap[chars[q]] = 1
                }
            }
        }
        return result
    }
    
    /// https://leetcode.cn/problems/minimum-window-substring/
    func minWindow(_ s: String, _ t: String) -> String {
        // 两个指针i和j，一前一后
        // 将t存到哈希表tMap中，key为字符，value为数量
        // 外层循环是j<s.count，另一个哈希表windowMap存储当前滑动窗口的数据，i和j从0开始
        // 进入循环后要做的有两件事情：
        // 1. 判断windowMap和tMap是否符合条件
        // 2. 调整windowMap，未下一次条件判断做准备
        var tMap: [Character: Int] = [:]
        for c in t {
            if let count = tMap[c] {
                tMap[c] = count + 1
            } else {
                tMap[c] = 1
            }
        }
        
        var windowMap: [Character: Int] = [:]
        var i = 0
        var j = 0
        let count = s.count
        let chars = Array(s)
        if tMap[chars[0]] != nil {
            windowMap[chars[0]] = 1
        }
        var minI = -2
        var minJ = count
        while j < count {
            // 进行条件判断，windowMap中的元素及个数是否>=tMap
            var success = true
            for item in tMap {
                if let wCount = windowMap[item.key], item.value <= wCount {}
                else {
                    success = false
                    break
                }
            }
            if success {
                if j - i <= minJ - minI {
                    minJ = j
                    minI = i
                }
            }
            
            // 调整滑动窗口
            // 如果前面符合条件，则要缩小滑动窗口进行尝试
            // 如果没有符合条件，则要扩大窗口进行尝试
            if success {
                repeat {
                    if let count = windowMap[chars[i]] {
                        if count == 1 {
                            windowMap[chars[i]] = nil
                        } else {
                            windowMap[chars[i]] = count - 1
                        }
                    }
                    i += 1
                } while i < j && tMap[chars[i]] == nil
            } else {
                repeat {
                    j += 1
                    if j < count, tMap[chars[j]] != nil {
                        if let count = windowMap[chars[j]] {
                            windowMap[chars[j]] = count + 1
                        } else {
                            windowMap[chars[j]] = 1
                        }
                    }
                } while j < count && tMap[chars[j]] == nil
            }
        }
        if minI < 0 {
            return ""
        }
        return String(chars[minI...minJ])
    }
    
    // MARK: - 前缀后缀统计
    /// https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/
    func maxProfit(_ prices: [Int]) -> Int {
        // 搞一个后缀统计数组st，记录从后到前，除了自身元素外，的最大的元素值
        // 那maxProfit就是，遍历一遍prices过程中st[i]-price[i]的最大值
        let count = prices.count
        var st = Array(repeating: 0, count: count)
        for index in stride(from: count - 2, to: -1, by: -1) {
            st[index] = max(prices[index+1], st[index+1])
        }
        var maxProfit = 0 //不做任何交易的情况下，受益就是0
        for index in 0..<count {
            let v = st[index] - prices[index]
            if v > maxProfit {
                maxProfit = v
            }
        }
        return maxProfit
    }
    
    /// https://leetcode.cn/problems/product-of-array-except-self/
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        // 搞一个前缀乘积统计数组和一个后缀乘积统计数组，都不包含自身
        // 两个数组进行相乘，得结果
        let count = nums.count
        var prefix = Array(repeating: 1, count: count)
        var suffix = Array(repeating: 1, count: count)
        // prefix, i from 1 to count-1
        for i in 1..<count {
            // v = nums[i-1] * prefix[i-1]
            prefix[i] = nums[i-1] * prefix[i-1]
        }
        
        // suffix, i from count-2 to 0
        for i in stride(from: count-2, to: -1, by: -1) {
            // v = nums[i+1] * suffix[i+1]
            suffix[i] = nums[i+1] * suffix[i+1]
        }
        
        var result = Array(repeating: 1, count: count)
        // i from 0 to count-1
        for i in 0..<count {
            result[i] = prefix[i] * suffix[i]
        }
        return result
    }
    
    /// https://leetcode.cn/problems/reverse-bits-lcci/
    func reverseBits(_ num: Int) -> Int {
        // 一个前缀数组，一个后缀数组，各32长度，存储2进制
        // 如何得到这两个数组，需要有个游标从1开始，一直左移
        if num  == 0 { return 1 }
        var prefix = Array(repeating: 0, count: 32)
        var suffix = Array(repeating: 0, count: 32)
        
        var tmp = 1
        var index = 31
        // suffix
        while index >= 0 {
            if tmp & num == 0 {
                // cur bit is 0
                suffix[index] = 0
            } else {
                // cur bit is 1
                suffix[index] = (index == 31) ? 1 : (suffix[index + 1] + 1)
            }
            tmp = tmp << 1
            index -= 1
        }
        
        tmp = Int(pow(2.0, 31))
        index = 0
        while index < 32 {
            print(tmp & num == 0 ? 0 : 1)
            if tmp & num == 0 {
               prefix[index] = 0
            } else {
                prefix[index] = index == 0 ? 1 : (prefix[index-1] + 1)
            }
            tmp = tmp >> 1
            index += 1
        }
        
        // maxLength in position i is v = suffix[i+1] + prefix[i-1] + 1
        var maxLength = Int.min
        for i in 0..<32 {
            let pre = i == 0 ? 0 : prefix[i-1]
            let suf = i == 31 ? 0 : suffix[i+1]
            let v = pre + suf + 1
            if v > maxLength {
                maxLength = v
            }
        }
        return maxLength
    }
}
