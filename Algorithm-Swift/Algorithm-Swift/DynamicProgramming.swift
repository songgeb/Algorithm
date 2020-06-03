//
//  DynamicProgramming.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/6/1.
//  Copyright © 2020 Songgeb. All rights reserved.
//

import Foundation

class DynamicProgramming {
    
    static let array = [2, 2, 4, 6, 3]
    static let capacity = 9
    static var max = 0
    
    /// 动态规划解决背包问题
    /// 所谓动态规划，就是依靠上一步的结果，制定下一步的策略，将当前一步的所有情况标记出来，通过技巧规避掉重复项
    /// 联想到二维数组，去重的01背包问题
    /// 想象一个二维数组，行数表示物品数量，列数表示重量，列数最大不超过背包总重量
    /// 假设物品重量是[2,2]，a[0][0] = 1，表示第一个物品不放入背包时重量为0，a[0][2]=1表示第一个物品放入了背包，重量是2
    
    static var states: [[Bool]] = [[Bool]].init(repeating: [Bool].init(repeating: false, count: 10), count: 5)
    static func zhuang3() {
        // 先对第一个物品做特殊处理
        // 不装
        states[0][0] = true
        // 装
        if array[0] > capacity {
            states[0][array[0]] = true
        }
        
        // 从第二个物品到结束
        for i in 1..<array.count {
            for j in 0...capacity {
                // 只用关前面已装或未装的
                if states[i - 1][j] {
                    // 当前i物品，不装的状态
                    states[i][j] = true
                    // 当前i物品，装的状态
                    if j + array[i] <= capacity {
                        states[i][j + array[i]] = true
                    }
                }
            }
        }
        
        //按行输出结果集
        for i in 0..<array.count {
            for j in 0...capacity {
                print(states[i][j], terminator: " ")
            }
            print("")
        }
    }
    
    /// 使用一位数组实现动态规划实现01背包
    static var states4: [Bool] = [Bool].init(repeating: false, count: Package.capacity + 1)
    static func zhuang4() {
        states4[0] = true
        if array[0] <= capacity {
            states4[array[0]] = true
        }
        
        for i in 1..<array.count {
            for j in stride(from: capacity - array[i], to: -1, by: -1) {
                if states4[j] {
                    
                    states4[j + array[i]] = true
                }
            }
        }
        
        for i in 1..<array.count {
            for j in 0...capacity - array[i] {
                if states4[j] { states4[j + array[i]] = true }
            }
        }
        
        print(states4)
    }
}
// MARK: - 找零钱

/// 找零钱问题，1元、3元、5元的硬币若干枚，支付9元使用的最少的硬币数是多少
/// 本算法尝试使用回溯算法，找出所有可能的组合情况，然后从中选择硬币数最小的
func check_backtracking() {
    let icons = [1, 3, 5]
    var selectedIcons: [Int] = []
    var minIcons = Int.max
    /// i表示选择第几个硬币，从0开始
    func action(_ i: Int, currentMoney: Int) {
        if currentMoney > 9 {
            return
        }
        if currentMoney == 9 {
            print(selectedIcons)
            minIcons = min(minIcons, selectedIcons.count)
            return
        }
        /// 选择一枚1元的硬币
        selectedIcons.append(1)
        action(i + 1, currentMoney: currentMoney + 1)
        selectedIcons.removeLast()
        
        selectedIcons.append(3)
        action(i + 1, currentMoney: currentMoney + 3)
        selectedIcons.removeLast()
        
        selectedIcons.append(5)
        action(i + 1, currentMoney: currentMoney + 5)
        selectedIcons.removeLast()
        
    }
    
    action(0, currentMoney: 0)
    print(minIcons)
}

/// 给定任意可选硬币和任意钱数，给出一个所有可能的找零组合
func checkn_backtracking(coins: [Int], total: Int) {
    
    var result :[Int] = []
    func action(currentMoney: Int) {
        if currentMoney == 0 {
            print("出现一个结果->\(result)")
            return
        }
        
        if currentMoney < 0 {
            return
        }
        
        for coin in coins {
            result.append(coin)
            action(currentMoney: currentMoney - coin)
            result.removeLast()
        }
    }
    
    action(currentMoney: total)
}
/// 动态规划实现给定任意可选硬币和任意钱数，给出需要的最少找零硬币数
func check_dp(coins: [Int], total: Int) -> Int {
    // 一个dptable，长度是total+1
    // i从1开始，每个位置的值表示要找i数值的零钱，需要最少多少个硬币
    // 这个值通过遍历coins所有硬币，通过取得最小的dptable[i - coin]来得到
    
    let placeholder = Int.max - total
    var dptable = [Int].init(repeating: placeholder, count: total + 1)
    dptable[0] = 0
    for i in 1...total {
        for coin in coins {
            if i - coin >= 0 {
                let numCoin = dptable[i-coin] + 1
                if numCoin  < dptable[i] {
                    dptable[i] = numCoin
                }
            }
        }
    }
    
    return dptable[total] == placeholder ? -1 : dptable[total]
}

func yanghui() {
    let array = [[5], [7,8], [2,3,4], [4,9,6,1], [2,7,9,4,5]]
    
    var states = [[Int]].init(repeating: [0, 0, 0, 0, 0], count: 5)
    states[0][0] = array[0][0]
    
    // 构造状态转移表
    for i in 1..<array.count {
        for j in 0..<array[i].count {
            if j == 0 {
                states[i][j] = states[i-1][j] + array[i][j]
            } else if j == array[i].count - 1 {
                states[i][j] = states[i-1][array[i-1].count - 1] + array[i][j]
            } else {
                let topLeft = states[i-1][j-1]
                let topRight = states[i-1][j]
                states[i][j] = min(topLeft, topRight) + array[i][j]
            }
        }
    }
    
    //取出最后一排节点中最短路径长度
    var minValue = Int.max
    for i in 0..<states[states.count - 1].count {
        minValue = min(states[states.count - 1][i], minValue)
    }
    print(minValue)
}

/// 回溯方法求出数组中所有递增子序列
func increasingSubSequence(_ array: [Int]) {
    
    var result: [Int] = []
    /// 从i起，所有递增子序列
    func action(_ i: Int) {
        if i == array.count {
            print(result)
            return
        }
        
        //选择
        if result.isEmpty || result.last! <= array[i] {
            result.append(array[i])
            action(i+1)
            result.removeLast()
        }
        
        // 不选择
        action(i+1)
    }
    
    for i in 0..<array.count {
        action(i)
    }
}

func lengthOfLIS(_ nums: [Int]) -> Int {
    guard nums.count > 0 else { return 0 }
    var dp = [Int](repeating: 1, count: nums.count)
    var result = 1
    for i in 1..<nums.count {
        var maxPre = 0
        for j in 0..<i {
            if nums[j] < nums[i] {
                maxPre = max(maxPre, dp[j])
            }
        }
        dp[i] = maxPre + 1
        result = max(result, dp[i])
    }
    return result
}
