//
//  Pattern.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2022/3/10.
//  Copyright © 2022 Songgeb. All rights reserved.
//
/// 找规律题
import Foundation


func setZeroes(_ matrix: inout [[Int]]) {
    if matrix.isEmpty { return }
    let rowNum = matrix.count
    let colNum = matrix[0].count
    var zeroValueIndice: [(Int, Int)] = []
    for row in 0..<rowNum {
        for col in 0..<colNum {
            if matrix[row][col] == 0 {
                zeroValueIndice.append((row,col))
            }
        }
    }
    
    for (row, col) in zeroValueIndice {
        // 固定row，遍历col
        for index in 0..<colNum {
            if matrix[row][index] != 0 {
                matrix[row][index] = 0
            }
        }
        
        // 固定col，遍历row
        for index in 0..<rowNum {
            if matrix[index][col] != 0 {
                matrix[index][col] = 0
            }
        }
    }
}
/// https://leetcode-cn.com/problems/one-away-lcci/
/// 一次编辑
func oneEditAway(_ first: String, _ second: String) -> Bool {
    // 两种情况
    // ("", "a"), ("abc", "ac"), ("a", "b")
    // 两个串长度相等和两个串长度差1，其余任何情况都无意义
    if (first == second) { return true}
    let firstStrLength = first.count
    let secondStrLength = second.count
    if abs(firstStrLength - secondStrLength) > 1 { return false }
    // 长度相等的话，还有两种情况，完全相等和是否只有一个字母不同；
    // 从前往后遍历字符串，如果同一个位置两个串的不同的情况超过1次，就返回false
    var diffCount = 0
    let longerChars = firstStrLength > secondStrLength ? Array(first) : Array(second)
    let shorterChars = firstStrLength > secondStrLength ? Array(second) : Array(first)
    if (firstStrLength == secondStrLength) {
        for index in 0..<firstStrLength {
            if diffCount > 1 { return false }
            if longerChars[index] != shorterChars[index] {
                diffCount += 1
            }
        }
        return true
    } else {
        // 两个串长度相差为1时，两个指针，遍历两个串；如果当前两个指针对应的值第一次不相等，则让长的字符串指针继续前进，如果后续都相等，则返回true；否则返回false
        var longerStrIndex = 0
        var shorterStrIndex = 0
        while shorterStrIndex < shorterChars.count {
            if (diffCount > 1) { return false }
            if (longerChars[longerStrIndex] != shorterChars[shorterStrIndex]) {
                diffCount += 1
                if (diffCount == 1) {
                    // 模拟删除
                    longerStrIndex += 1
                    continue;
                }
            }
            longerStrIndex += 1
            shorterStrIndex += 1
        }
        return true
    }
}
/// https://leetcode-cn.com/problems/master-mind-lcci/
func masterMind(_ solution: String, _ guess: String) -> [Int] {
    // 分两部分找到结果
    // 先找出猜中的，再找出未猜中的
    // 要记录下已经被占用的数字的信息，使用一个used数组
    // 先找猜中的，遍历一遍字符串
    // 再找伪猜中，遍历guess一遍，对于每一个guess中字符，遍历solution中的字符，如果找到在solution中有一样的字符，则标记used，伪猜中+1，continue
    if solution.count != guess.count { return [] }
    if solution.isEmpty { return [] }
    var hitNum = 0
    var falseHitNum = 0
    var used = Array(repeating: false, count: solution.count)
    
    for (index, _) in solution.enumerated() {
        let sIndex = solution.index(solution.startIndex, offsetBy: index)
        let gIndex = guess.index(guess.startIndex, offsetBy: index)
        if (solution[sIndex] == guess[gIndex]) {
            used[index] = true
            hitNum += 1
        }
    }
    
    for (gIndex, gChar) in guess.enumerated() {
        let sIndex = solution.index(solution.startIndex, offsetBy: gIndex)
        if gChar == solution[sIndex] {
            continue
        }
        for (index, sChar) in solution.enumerated() {
            if !used[index] && sChar == gChar {
                falseHitNum += 1
                used[index] = true
                break
            }
        }
    }
    return [hitNum, falseHitNum]
}

// https://leetcode-cn.com/problems/rotate-image/
/// 旋转矩阵
func rotate(_ matrix: inout [[Int]]) {
    // 方法一：通过找规律发现  原矩阵中[i,j]，通过旋转后到达目的矩阵后应该是[j, n-i-1]
    // 借助上面的思路，再借助一个辅助数组，即可完成编码
    // 如何做到原地变换呢
    // 方法二：通过反转实现：先上下反转，再根据左上到右下的对角线来反转
    // 上下反转：外层循环按照行来进行，从i=0，< n/2，列j从0到n，swap(m[i][j], m[n-i-1][j])
    // 沿对角线反转：i=0, < n;列j=0,<i,swap(m[i][j], m[j][i])
    // 方法三：一圈一圈的交换数据问题，参考下个函数
    if (matrix.isEmpty) { return }
    func swap(_ m: inout [[Int]], _ s: (Int, Int), _ e: (Int, Int)) {
        let tmp = m[s.0][s.1]
        m[s.0][s.1] = m[e.0][e.1]
        m[e.0][e.1] = tmp
    }
    let rowNum = matrix.count
    let colNum = matrix[0].count
    for i in 0..<rowNum / 2 {
        for j in 0..<colNum {
            swap(&matrix, (i, j), (rowNum-i-1, j))
        }
    }
    
    for i in 0..<rowNum {
        for j in 0..<i {
            swap(&matrix, (i, j), (j, i))
        }
    }
}

func rotate1(_ matrix: inout [[Int]]) {
    // 一圈一圈的替换元素
    // 每一圈干一件事：选取四个元素进行交换；
    // 要做多少圈：n/2
    // 每一圈要替换多少次：[0,n-2]
    // 每一圈中如何进行替换：
    // 先确定起始的四个元素，这个很容易确认s1, s2, s3, s4
    // 根据其实元素，通过移动得出后面的所有元素
    if (matrix.isEmpty) { return }
    let rowNum = matrix.count
    let colNum = matrix[0].count
    let loopCount = rowNum / 2
    
    func swap(_ m: inout [[Int]], _ s1: (Int, Int), _ s2: (Int, Int), _ s3: (Int, Int), _ s4: (Int, Int)) {
        let tmp = m[s1.0][s1.1]
        m[s1.0][s1.1] = m[s4.0][s4.1]
        m[s4.0][s4.1] = m[s3.0][s3.1]
        m[s3.0][s3.1] = m[s2.0][s2.1]
        m[s2.0][s2.1] = tmp
    }
    
    var i = 0
    while i < loopCount {
        let s1 = (i , i)
        let s2 = (i, colNum - 1 - i)
        let s3 = (rowNum - 1 - i, colNum - 1 - i)
        let s4 = (rowNum - 1 - i, i)
        let newColNum = colNum - 2 * i
        for move in 0..<newColNum-1 {
            let p1 = (s1.0, s1.1 + move)
            let p2 = (s2.0 + move, s2.1)
            let p3 = (s3.0, s3.1 - move)
            let p4 = (s4.0 - move, s4.1)
            swap(&matrix, p1, p2, p3, p4)
        }
        
        i += 1
    }
}

// 井字游戏
// https://leetcode-cn.com/problems/tic-tac-toe-lcci/
func tictactoe(_ board: [String]) -> String {
    // 先将字符传数组，转为二维数组，即转为矩阵形式
    // 转为二维数组时，记录是否有空位置，用于后续判断
    // 先判断有赢家，如果没有赢家再判断是draw或者pending
    // 赢家判断逻辑：由于可见性质，只需要针对矩阵第一行和第一列的每一个元素，判断这些元素所在的行和列，有无构成赢家的棋局
    // 再判断对角线是否是赢家棋局
    // 为防止多余判断，用两个bool的数组用于记录第n行是否已经判断过了
    // 特殊情况，矩阵只有一个元素时---
    let errStr = ""
    if board.isEmpty { return errStr }
    if board.count != board[0].count { return errStr }
    
    var hasEmptyChar = false
    var matrix: [[Character]] = []
    for str in board {
        matrix.append(Array(str))
        if str.contains(" ") {
            hasEmptyChar = true
        }
    }
    
    let rowNum = board.count
    
    //第0-第rowNum-1行
    for row in 0..<rowNum {
        let target = matrix[row][0]
        if target == " " { continue }
        var rowWin = true
        for col in 0..<rowNum {
            if target != matrix[row][col] {
                rowWin = false
                break
            }
        }
        if rowWin {
            return String(target)
        }
    }
    
    // n列
    for col in 0..<rowNum {
        let target = matrix[0][col]
        var colWin = true
        if target == " " { continue }
        for row in 0..<rowNum {
            if target != matrix[row][col] {
                colWin = false
                break
            }
        }
        if colWin {
            return String(target)
        }
    }
    
    // 左上右下对角线
    let topleft = matrix[0][0]
    if topleft != " " {
        var topleftWin = true
        for index in 0..<rowNum {
            if matrix[index][index] != topleft {
                topleftWin = false
                break
            }
        }
        if topleftWin {
            return String(topleft)
        }
    }
    
    // 左下右上对角线
    let topbottom = matrix[rowNum-1][0]
    if topbottom != " " {
        var topbottomWin = true
        for col in 0..<rowNum {
            if matrix[rowNum-1-col][col] != topbottom {
                topbottomWin = false
                break
            }
        }
        if topbottomWin {
            return String(topbottom)
        }
    }
    
    if hasEmptyChar {
        return "Pending"
    } else {
        return "Draw"
    }
}

// 螺旋矩阵
// https://leetcode-cn.com/problems/spiral-matrix/
func spiralOrder1(_ matrix: [[Int]]) -> [Int] {
    // 从一个点开始
    // 按照右、下、左、上的优先级，遍历二维数组，直到发现已经遍历过为止
    // 所以，需要有一个辅助数组，用于标记是否遍历过
    // 注意边界问题
    // 一次大的循环表示遍历矩阵的一圈
    // 大循环的开始条件是，当前坐标(row、col)有效，且没有被遍历过
    if matrix.isEmpty { return [] }
    var row = 0
    var col = 0
    let rowNum = matrix.count
    let colNum = matrix[0].count
    var used = Array(repeating: Array(repeating: false, count: colNum), count: rowNum)
    var result: [Int] = []
    
    while row < rowNum, col < colNum, !used[row][col] {
        // 右
        while col < colNum, !used[row][col] {
            result.append(matrix[row][col])
            used[row][col] = true
            col += 1
        }
        // 下
        col -= 1
        row += 1
        while row < rowNum, !used[row][col] {
            result.append(matrix[row][col])
            used[row][col] = true
            row += 1
        }
        // 左
        row -= 1
        col -= 1
        while col >= 0, !used[row][col] {
            result.append(matrix[row][col])
            used[row][col] = true
            col -= 1
        }
        // 上
        col += 1
        row -= 1
        while row >= 0, !used[row][col] {
            result.append(matrix[row][col])
            used[row][col] = true
            row -= 1
        }
        row += 1
        
        col += 1
    }
    return result
}

// 搜索二维矩阵 II
// https://leetcode-cn.com/problems/search-a-2d-matrix-ii/
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    // 该题确实需要一点技巧
    // 找到右上角位置，比如(i, j)
    // 如果target > matrix[i][j]，则可以排除掉第i行中j列左侧的元素。所以让i+=1
    // 如果target < matrix[i][j]，则可以排除第j列中，从i之下的元素，让j-=1
    // 如果target == matrix[i][j]，就返回成功好了
    // 执行上面三个操作，直到i>=rowNum或j<0
    if (matrix.isEmpty) { return false }
    let rowNum = matrix.count
    let colNum = matrix[0].count
    var i = 0
    var j = colNum - 1
    while i < rowNum, j >= 0 {
        if target == matrix[i][j] {
            return true
        } else if target > matrix[i][j] {
            i += 1
        } else {
            j -= 1
        }
    }
    return false
}

// 跳跃游戏
// https://leetcode-cn.com/problems/jump-game/
func canJump(_ nums: [Int]) -> Bool {
    // 基于canJump1算法进一步优化得出当前算法
    // canJump1中有一个reached数组用于记录每个位置是否可达
    // 其实没必要记录每个位置是否可达，只要记录最远可达的位置maxReached，那该位置之前的地方都是可达的
    // 所以该算法的核心思想是，不断更新maxReached，如果maxReached>=nums.count-1，就说明可达了
    // maxReached默认是0，遍历nums中每一个元素(最后一个没有必要遍历)，计算出maxReached
    if nums.isEmpty { return false }
    if nums.count == 1 { return true }
    let count = nums.count
    var maxReached = 0
    var index = 0
    while index < count - 1 {
        if maxReached < index {
            index += 1
            break
        }
        maxReached = max(index + nums[index], maxReached)
        if maxReached >= count - 1 {
            return true
        }
        index += 1
    }
    return false
}

func canJump1(_ nums: [Int]) -> Bool {
    // 用一个辅助数组，标记每个nums中每个元素是否可达
    // 判断是否可跳跃的过程就是为辅助数组填数的过程
    // 边界情况，只有一个元素时。由于题目要求，开始在第一个元素，所以第一个元素一定可达
    // 从第一个元素开始，reached的内容
    if nums.isEmpty { return false }
    let count = nums.count
    var reached = Array(repeating: false, count: count)
    reached[0] = true
    for index in 0..<count {
        if !reached[index] {
            continue
        }
        var delta = 1
        while delta <= nums[index] {
            let targetIndex = index + delta
            if targetIndex == count - 1 {
                return true
            }
            if targetIndex < count {
                reached[targetIndex] = true
            } else {
                break
            }
            delta += 1
        }
    }
    return reached[count-1]
}

func canJump2(_ nums: [Int]) -> Bool {
    // 模拟跳跃的过程，穷举法，可能需要用到递归技巧
    if nums.isEmpty { return false }
    if nums.count == 1, nums.first == 0 {
        return true
    }
    
    let targetIndex = nums.count - 1
    
    func what(_ nextIndex: Int) -> Bool {
        if nextIndex == targetIndex {
            return true
        }
        // 跳过了，则失败
        if nextIndex > targetIndex {
            return false
        }
        var delta = 1
        while delta <= nums[nextIndex] {
            if what(nextIndex + delta) {
                return true
            }
            delta += 1
        }
        return false
    }
    
    return what(0)
}

// 跳水板
// https://leetcode-cn.com/problems/diving-board-lcci/
func divingBoard(_ shorter: Int, _ longer: Int, _ k: Int) -> [Int] {
    // 根据题目给出的实例，最小的水板长度是k*shorter，最长长度是k*longer
    // 可以归纳出每个水板的长度(k*shorter, (k-1)*shorter+longer, (k-2)*shorter+2*longer,....,k*longer)
    // 可见结果集一共有k+1个
    if k <= 0 { return [] }
    if shorter == longer { return [k*shorter] }
    var result: [Int] = []
    for i in 0...k {
        result.append(i*longer + (k-i)*shorter)
    }
    return result
}
