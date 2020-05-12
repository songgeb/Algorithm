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
    
}
