//
//  BackTracking.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/2/22.
//  Copyright © 2020 Songgeb. All rights reserved.
//
/// 回溯算法
import Foundation


// MARK: - 回溯算法
// 回溯算法特点就是回溯
// 回溯思想一般用于解决求一个问题的多个解或从多个解中找最优解
// 回溯思想能求解的问题，可以用二叉树的结构画出来，从根到每个叶子节点分别构成了问题的多个解
// 以全排列举例
//                      null
//          1            2              3
//      2       3    1        3     1       2
//      3       2    3        1     2       1
// 对除叶子节点外的节点，要做的事情是一样的，
// 1. 从剩余的数字中选一个放到本次排列数组中，然后可选的就少了一个
// 2. 重复1的过程，直到没有可选的了

/// 回溯法求全排列组合
/// - Parameter n:
func allRank(array: [Int]) {
    // 给定一个无重复整数数组，输出所有的全排列
    // 我们尝试用递归实现全排列
    // 有一个数组path来记录当次遍历中全排列的数字
    // 还要解决在本次递归中，如何直到哪些数字是剩余的--可以用一个used数组，长度和原数组一样，每个值表示原数组中相同位置的值有没有被选择过
    
    var path = [Int]()
    var used = Array<Bool>.init(repeating: false, count: array.count)
    var counter = 0
    allRankRecursion(array: array, path: &path, used: &used, counter: &counter)
    print("总个数->\(counter)")
}

func allRankRecursion(array: [Int], path: inout [Int], used: inout [Bool], counter: inout Int) {
    if path.count >= array.count {
        print("出现一个结果-->\(path)")
        counter += 1
        return
    }
    //从数组中找一个你没有用过的数出来，追加到path中
    for (index, item) in array.enumerated() {
        if !used[index] {
            path.append(item)
            used[index] = true
            allRankRecursion(array: array, path: &path, used: &used, counter: &counter)
            used[index] = false
            path.removeLast()
        }
    }
}

// MARK: - 8皇后问题


// MARK: - 01背包
// 对于一组不同重量、不可分割的物品，我们需要选择一些装入背包，在满足背包最大重量限制的前提下，背包中物品总重量的最大值是多少呢？
// 同上面全排列问题
// 该问题也可以用回溯法穷举出所有的可能情况，从其中选择使得总重量最大的一个来

// [3, 5, 6, 2, 8, 9]
// 1. 刚开始有多种情况，先找一个，可选可不选，两种情况都得走一下
// 2. 随着前进，剩余的情况越来越少，等不能再往前走时，就要“回溯”了，回溯到前一个状态，选择另外一种可能
// 3. 继续从1开始

class Package {
    static let array = [2, 2, 4, 6, 3]
    static let capacity = 9
    static var method: [Int] = []
    static var max = 0
    static var maxMethod: [Int] = []
    
    static func zhuang(i: Int, cw: Int) {
        // 第i个物品，装或者不装，未装第i个物品时的重量
        if i < 0 { return }
        if i >= array.count {
            if max < cw {
                max = cw
                maxMethod = method
            }
            return
        }
        // 不装
        zhuang(i: i + 1, cw: cw)
        // 装
        if cw + array[i] <= capacity{
            method.append(array[i])
            zhuang(i: i + 1, cw: cw + array[i])
            method.removeLast()
        }
        
    }
    
    static var mem: [[Bool]] = [[Bool]].init(repeating: [Bool].init(repeating: false, count: 13), count: 6)
    /// 增加了备忘录的装法
    /// - Parameters:
    ///   - i:
    ///   - cw:
    static func zhuang2(i: Int, cw: Int) {
        if i >= array.count || cw >= capacity {
            if max < cw {
                max = cw
                maxMethod = method
            }
            return
        }
        
        if mem[i][cw] { return }
        // 不装
        zhuang2(i: i + 1, cw: cw)
        // 装
        if cw + array[i] <= capacity{
            method.append(array[i])
            zhuang2(i: i + 1, cw: cw + array[i])
            method.removeLast()
        }
    }
    
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
        states[0][array[0]] = true
        
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
    
    static func test() {
        zhuang3()
    }
}
