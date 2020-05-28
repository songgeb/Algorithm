//
//  Other.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/5/18.
//  Copyright © 2020 Songgeb. All rights reserved.
//


class Other {
    /// ip字符串转为Int
    /// ip的每一部分都可以用32位的二进制数表示，因为ip最大不超过255
    /// 基本思路时，拆分ip的每一部分出来，转为Int类型，左移相应的位数
    /// 每一部分的二进制做或运算
    func ipToInt(_ ipStr: String) -> Int? {
        let nums = ipStr.split(separator: ".").compactMap({ Int.init($0) })
        if nums.count == 0 { return nil }
        var result: Int = 0
        for (index, num) in nums.enumerated() {
            result |= num << ((3 - index) * 8)
        }
        return result
    }
    
    /// 给一个整数，解析成ip
    /// 和ipToInt相反
    /// 通过&，分出整型中每一部分ip地址
    ///
    /// - Parameter num: <#num description#>
    /// - Returns: <#return value description#>
    func intToIPStr(_ num: Int) -> String? {
        var ipStr: [String] = []
        for index in 0...3 {
            let offset = (3 - index) * 8
            let ipSegment = (num & (255 << offset)) >> offset
            ipStr.append("\(ipSegment)")
        }
        if ipStr.count == 0 { return nil }
        return ipStr.joined(separator: ".")
    }
    // leetcode-443
    func compress(_ chars: inout [Character]) -> Int {
        if chars.count == 1 { return 1 }
        // 一个cur下标表示当前字符
        // 一个counter，计数用
        // 一个pre下标，记录上一个字符
        // 还一个i，表示替换位置
        // 开始cur = i = 1，pre = 0
//        var pre, cur, i, counter: Int
//        pre = 0
//        cur = 1
//        i = 0
//        counter = 1
//
//        while cur <= chars.count {
//            if cur < chars.count, chars[cur] == chars[pre] {
//                counter += 1
//            } else {
//                chars[i] = chars[pre]
//                if counter > 1 {
//                    // 替
//                    i += 1
//                    let counterStr = "\(counter)"
//                    for j in counterStr {
//                        chars[i] = j
//                        i += 1
//                    }
//                } else {
//                    i += 1
//                }
//                counter = 1
//            }
//            cur += 1
//            pre += 1
//        }
//        return i
        
        //更优雅的实现（主要是针对上面代码比较繁琐的情况进行优化，参考了其他人Swift的实现）
        // 通过for循环遍历每个字符，循环中，仅当当前元素和下个元素不同时才做处理
        // 具体处理是：替换元素，
        // 1. 先替换字符元素，需要一个write变量，标记要替换的位置
        // 2. 再替换数字，需要一个变量start，来记录当前压缩字符段的开始位置，通过i - start + 1来求得重复字符个数len，当个数大于1，才替换数字，否则仅第1不的元素替换就够了
        // 对于i走到头的情况要特殊考虑，要做的工作也是上面的1和2
        
        var write = 0
        var start = 0
        for i in chars.indices {
            if i == chars.count - 1 || chars[i] != chars[i+1] {
                chars[write] = chars[i]
                write += 1
                let len = i - start + 1
                if len > 1 {
                    for c in String(len) {
                        chars[write] = c
                        write += 1
                    }
                }
                start = i + 1
            }
        }
        return write
    }
    /// leetcode-https://leetcode-cn.com/problems/contiguous-sequence-lcci/
    func maxSubArray(_ nums: [Int]) -> Int {
        if nums.count == 0 { return -1 }
        // 暴力办法
        // 两层for循环，遍历所有可能的组合，求出最大值
        // 时间复杂度是O(n2)
        // 分治法解决
        // 核心思想，从中间将数组分为两部分
        // 要求的总和最大的连续序列要么落在左边，要么右边，要么横跨在中间
        // 左边和右边继续递归实现，主要是中间如何求。假设中间元素下标是mid
        // 现在核心问题是，如何求横跨左右两边的总和最大的连续数列
        // 其实从mid往前加，mid+1往后加，两部分最大值加到一起就是横跨中间的最大值
        // 递推公式如上所述
        // 终止条件是：当区间缩小到只有1个时，返回自己
        // check: 空数组时，1个元素时
        func action(_ left: Int, _ right: Int) -> Int {
            if left == right {
                return nums[left]
            }
            
            let mid = left + (right - left) >> 1
            let leftSum = action(left, mid)
            let rightSum = action(mid + 1, right)
            // 计算中间最大
            // 一个maxSum记录最大和
            var maxlSum = nums[mid]
            var lSum = 0
            for i in stride(from: mid, to: left - 1, by: -1) {
                lSum += nums[i]
                maxlSum = max(maxlSum, lSum)
            }
            
            var maxrSum = nums[mid+1]
            var rSum = 0
            for i in (mid+1)...right {
                rSum += nums[i]
                maxrSum = max(maxrSum, rSum)
            }
            
            return max(max(leftSum, rightSum), maxlSum + maxrSum)
        }
        
        return action(0, nums.count - 1)
    }
    
    /// 递归实现0到100的加和
    /// 递推公式: f(n) = f(n-1) + n
    /// 终止条件: f(1) = 1
    func sum0100(_ n: Int) -> Int {
        
        if n == 1 { return 1 }
        return n + sum0100(n-1)
    }
    
    /// 矩阵中查找某个给定的元素
    /// 分治思想，
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        
        func action(_ i: Int, _ j: Int) -> Bool {
            if i < 0 || j < 0 { return false }
            if (i >= matrix.length || j >= matrix[i].length) { return false; }
            if target == matrix[i][j] {
                return true
            } else if target > matrix[i][j] {
                return action(i + 1, j)
            } else {
                return action(i, j - 1)
            }
        }
        // 从右上角的元素开始找，找的次数更少
        return action(0, matrix[0].count - 1)
    }
}
