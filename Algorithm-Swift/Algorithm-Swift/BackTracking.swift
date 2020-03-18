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
// 1. 想象一个8*8的棋盘，现在要往其中放8个棋子
// 2. 要保证最终的结果中，任何一个棋子横向、竖向、对角线方向都只有一个棋子
// 3. 一共有多少种不同的布棋方案

// 回溯思路解决问题
// 我们先实现一种最简单的布局
// 将第一个棋子放到第一排第一列，然后从第二排第一列开始，判断是否可以，不行就移动到下一列，直到最后一行
var result = [Int]()

/// 判断该坐标下数值是否和result中有冲突
/// - Parameters:
///   - row:
///   - column:
func isOk(row: Int, column: Int) -> Bool {
    //
    return true
}

func cal8Queens() {
    if result.count >= 8 { return }
    for row in 0...7 {
        for column in 0...7 {
            if isOk(row: row, column: column) {
                result[row] = column
                break
            }
        }
    }
}


// 01背包
