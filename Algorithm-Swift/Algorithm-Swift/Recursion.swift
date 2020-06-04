//
//  Recursion.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/5/12.
//  Copyright © 2020 Songgeb. All rights reserved.
//

class Recursion {
    
    func testStep(_ n: Int) -> Int {
        // n个台阶，可以走两步，也可以走一步，总共有多少中走法
        // f(n) = f(n-1) + f(n-2)
        if n == 1 { return 1 }
        if n == 2 { return 2 }
        return testStep(n - 1) + testStep(n - 2)
    }
    /// 非递归实现爬台阶问题
    func testStep1(_ n: Int) -> Int {
        if n <= 0 { return 0 }
        if n == 1 { return 1 }
        if n == 2 { return 2 }
        
        var result: Int = 0
        // f(3) = f(2) + f(1)
        // 初始pre = f(2)
        // prepre = f(1)
        var pre = 2
        var prepre = 1
        for _ in 3...n {
            result = pre + prepre
            prepre = pre
            pre = result
        }
        
        return result
    }
    
    /// 一个推荐注册活动，A推荐了B注册，A是B的最终推荐人，B又推荐了C注册，A是C的最终推荐人
    /// 现在设计算法求出任意一个人的最终推荐人
    /// 注意，数据库中存储了直接推荐人的关系表，所以给定一个uid，可以找到直接推荐人，对于最终推荐人来说，他没有最终tuijianren
    func findRootReferrerId1(_ uid: String) -> String? {
        /// 递归实现
        if let directReferrerId = getDirectReferrerId(uid) {
            // 若可以找到直接推荐人id，则递归继续
            return findRootReferrerId1(directReferrerId)
        } else {
            return uid
        }
    }
    
    func findRootReferrerId2(_ uid: String) -> String? {
        // check，当uid是最终推荐人时，ok
        // other情况，ok
        /// 非递归实现
        var m = uid
        while let directUid = getDirectReferrerId(m) {
            m = directUid
        }
        return m
    }
    
    func getDirectReferrerId(_ uid: String) -> String? {
        return ""
    }
    /// 斐波那契数列非递归求值
    /// f(n) = f(n - 1) + f(n - 2)
    /// f(0) = 0, f(1) = 1
    /// 输入n，返回数列的第n项
    func fib(_ n: Int) -> Int {
        var f0 = 0
        var f1 = 1
        if n == 0 { return f0 }
        if n == 1 { return f1 }
        
        for _ in 1..<n {
            let tmpf1 = f1
            f1 = (f0 + f1) % 1000000007
            f0 = tmpf1
        }
        return f1
    }
    
    /// 爬楼梯，有n阶楼梯要爬，每次可以爬1层，也可以爬2层
    /// 递归实现
    func climbStairs(_ n: Int) -> Int {
        var sum = 0
        /// i表示上了多少台阶了
        func action(_ i: Int) {
            
            if i == n {
                sum += 1
                return
            }
            
            if i > n {
                return
            }
            
            action(i + 1)
            action(i + 2)
        }
        action(0)
        return sum
    }
    
    /// 爬楼梯非递归实现
    /// 分析爬楼梯问题的前几位能够发现，本质就是斐波那契数列，只不过开始值不同罢了
    func climbStairs1(_ n: Int) -> Int {
        if n <= 0 { return 0 }
        if n == 1 { return 1 }
        if n == 2 { return 2 }
        
        var first = 1
        var second = 2
        for _ in 2..<n {
            let tmp = second
            second = first + second
            first = tmp
        }
        return second
    }
    
    func climbStairs2(_ n: Int) -> Int {
        if n <= 0 { return 0 }
        if n == 1 { return 1 }
        if n == 2 { return 2 }
        if n == 3 { return 4 }
        
        var first = 1
        var second = 2
        var third = 4
        for _ in 3..<n {
            
            let tmpSecond = second
            let tmpThird = third
            third = first + second + third
            second = tmpThird
            first = tmpSecond
        }
        return second
    }
    
}

class Solution1 {
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        var track = [Int]()
        var used = [Bool](repeating: false, count: nums.count)
        var res = [[Int]]()
        backtrack(nums.sorted(), track: &track, used: &used, res: &res)
        return res
    }
    
    func backtrack(_ nums: [Int], track: inout [Int], used: inout [Bool], res: inout [[Int]]) {
        if track.count == nums.count {
            let r = track
            res.append(r)
            return
        }
        for (index, num) in nums.enumerated() {
            if used[index] {
                continue
            }
            /*剪枝
             这里!used[index - 1]是提前剪枝
             也可以是used[index - 1],这是发现重复后再剪枝,提前剪枝效率更高
             */
            if index > 0 && num == nums[index - 1] && !used[index - 1] {
                continue
            }
            used[index] = true
            track.append(num)
            backtrack(nums, track: &track, used: &used, res: &res)
            track.removeLast()
            used[index] = false
        }
    }
    
    func permute(_ nums: [Int]) -> [[Int]] {
        if nums.count == 0 { return [] }
        var nums = nums
        var results: [[Int]] = []
        /// 固定begin位置元素，对后面的元素进行全排列
        func action(_ begin: Int) {
            if begin > nums.count - 1 {
                results.append(nums)
                return
            }
            for i in begin...nums.count-1 {
                nums.swapAt(i, begin)
                action(begin+1)
                nums.swapAt(i, begin)
            }
        }
        action(0)
        return results
    }
}
