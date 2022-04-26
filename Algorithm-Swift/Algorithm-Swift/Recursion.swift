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
    
    func reverseList(_ head: ListNode?) -> ListNode? {
        // 分解为子问题，使用递归实现
        // 要实现整个链表（n个节点）的反转，则可以分解为：假定后n-1个节点已经反转好的情况下，进行后n-1与第一个节点进行反转
        // 子问题：若要反转从第二个节点开始的n-1个节点，则同样将问题分解为如上的逻辑
        // 则算法逻辑如下：
        // reverseList(head.next); head.next.next = head; head.next = nil
        // 递归结束条件：当要反转最后节点时
        if head?.next == nil {
            head?.next = nil
            return head
        }
        let newHead = reverseList(head?.next)
        head?.next?.next = head
        head?.next = nil
        return newHead
    }
    
    /// https://leetcode-cn.com/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/
    func reversePrint(_ head: ListNode?) -> [Int] {
        // 子问题：反向打印整个链表分解为：先反向打印后n-1个链表节点，再打印当前节点
        // 递归停止条件：反向打印最后一个节点的后一个节点时，不需要打印了，直接返回
        var result: [Int] = []
        func reverseAppendValue(_ head: ListNode?) {
            guard let node = head else {
                return
            }
            reverseAppendValue(node.next)
            result.append(node.val)
        }
        reverseAppendValue(head)
        return result
    }
    
    /// https://leetcode-cn.com/problems/qing-wa-tiao-tai-jie-wen-ti-lcof/
    func numWays(_ n: Int) -> Int {
        // 子问题和完整问题是否类似：是的。爬n个台阶和爬n-1个台阶是一样的
        // 子问题转到完整问题：爬n个台阶的方式，和爬n-1个台阶有什么关系
        // 这里要注意：爬n个台阶的方式与爬前n-1个台阶的关系，看上去貌似这两种方式相等，但并不是
        // 其实爬n个台阶的方式，应该是等于爬前n-1个台阶的方式加上爬前n-2个台阶方式之和
        var mem = Array(repeating: 0, count: n + 1)
        func numWays_r(_ n: Int) -> Int {
            if n == 1 { return 1 }
            if n == 2 { return 2 }
            if mem[n] != 0 { return mem[n] }
            let result = numWays_r(n-1) + numWays_r(n-2)
            mem[n] = result
            return result
        }
        return numWays_r(n)
    }
    
    /// https://leetcode-cn.com/problems/three-steps-problem-lcci/
    func waysToStep(_ n: Int) -> Int {
        var mem = Array(repeating: 0, count: n + 1)
        func numWays_r(_ n: Int) -> Int {
            if n == 1 { return 1 }
            if n == 2 { return 2 }
            if n == 3 { return 4 }
            if mem[n] != 0 { return mem[n] }
            let result = numWays_r(n-1) + numWays_r(n-2) + numWays_r(n-3)
            mem[n] = result
            return result
        }
        return numWays_r(n)
    }
    
    /// https://leetcode-cn.com/problems/he-bing-liang-ge-pai-xu-de-lian-biao-lcof/
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        // 拆分子问题：合并连个链表可以拆分成，合并除了l1、l2之后的剩余的链表部分后，再合并l1、l2和剩余部分
        // 递归停止条件是，两个链表中，其中有一个为空时，则返回另一个
        if l1 == nil {
            return l2
        }
        if l2 == nil {
            return l1
        }
        if let node1 = l1, let node2 = l2 {
            if node1.val < node2.val {
                let head = mergeTwoLists(l1?.next, l2)
                l1?.next = head
                return l1
            } else {
                let head = mergeTwoLists(l1, l2?.next)
                l2?.next = head
                return l2
            }
        }
        return nil
    }
    /// https://leetcode-cn.com/problems/powx-n/
    func myPow(_ x: Double, _ n: Int) -> Double {
        // 暴力解法
        if x == 0 { return 0 }
        if n == 0 { return 1 }
        var result: Double = 1
        for _ in 0..<abs(n) {
            result *= x
        }
        if n < 0 {
            return 1.0 / result
        }
        return result
    }
    
    func myPow1(_ x: Double, _ n: Int) -> Double {
        // 递归解法
        // 拆分为子问题：
        // n > 0 时，f(n) = f(n-1) * f(1)
        // n < 0 时，f(n) = f(n+1) * f(-1)
        if x == 0 { return 0 }
        if n == 0 { return x }
        if n > 0 {
            return myPow1(x, n-1) * x
        } else {
            return myPow1(x, n+1) * (1/x)
        }
    }
    
    func myPow2(_ x: Double, _ n: Int) -> Double {
            // 上面的递归解法会超时，我们通过二分的思路进行优化
            // 拆分为子问题：
            // 偶数时，f(n) = f(n/2) * f(n/2)
            // 奇数时，f(n) = f(n/2) * f(n/2) * f(1)
            if x == 0 { return 0 }
            if n == 0 { return 1 }
            if n == 1 { return x }
            if n == -1 { return 1/x }
            if n % 2 == 0 {
                return myPow2(x, n/2) * myPow2(x, n/2)
            } else {
                return myPow2(x, n/2) * myPow2(x, n/2) * (n > 0 ? x : 1/x)
            }
    }
    func myPow3(_ x: Double, _ n: Int) -> Double {
            // 上面的递归解法仍然会超时，计算量并没有变少，只是压栈次数变少了。我们加入备忘录避免重复计算
            // 拆分为子问题：
            // 偶数时，f(n) = f(n/2) * f(n/2)
            // 奇数时，f(n) = f(n/2) * f(n/2) * f(1)
        func myPow_r(_ x: Double, _ n: Int) -> Double {
            if x == 0 { return 0 }
            if n == 0 { return 1 }
            var halfPowValue = myPow3(x, n/2)
            if n % 2 == 0 {
                return halfPowValue * halfPowValue
            } else {
                return halfPowValue * halfPowValue * (n > 0 ? x : 1/x)
            }
        }
        return myPow_r(x, n)
    }
    
    /// https://leetcode-cn.com/problems/recursive-mulitply-lcci/
    func multiply(_ A: Int, _ B: Int) -> Int {
        // 类似上题目的思路
        // A * B可以转化为A个B相加
        // 如果A很大的话，则可以使用二分的思想
        //
        func multiply_r(_ A: Int, _ B: Int) -> Int {
            if A == 1 {
                return B
            }
            let halfAB = multiply(A/2, B)
            if A % 2 == 0 {
                return halfAB + halfAB
            } else {
                return halfAB + halfAB + B
            }
        }
        var a = 0, b = 0
        if A > B {
            a = A
            b = B
        } else {
            a = B
            b = A
        }
        return multiply_r(a, b)
    }
}
