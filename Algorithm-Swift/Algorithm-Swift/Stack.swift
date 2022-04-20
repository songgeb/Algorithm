//
//  Stack.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/5/11.
//  Copyright © 2020 Songgeb. All rights reserved.
//

class Stack<Element> {
    // 数组实现一个栈结构
    // 提供几个方法
    // push入栈数据、出栈pop、top、isEmpty
    private var datas: [Element]
    
    init () {
        datas = []
    }
    
    var isEmpty: Bool {
        return datas.isEmpty
    }
    
    @discardableResult
    func pop() -> Element? {
        guard datas.last != nil else { return nil }
        return datas.removeLast()
    }
    
    func push(_ val: Element) {
        datas.append(val)
    }
    
    func top() -> Element? {
        return datas.last
    }
}

class Solution {
    
    /// 输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如，序列 {1,2,3,4,5} 是某栈的压栈序列，序列 {4,5,3,2,1} 是该压栈序列对应的一个弹出序列，但 {4,3,5,1,2} 就不可能是该压栈序列的弹出序列。
    /// - Parameters:
    ///   - pushed:
    ///   - popped:
    /// - Returns:
    func validateStackSequences(_ pushed: [Int], _ popped: [Int]) -> Bool {
        if pushed.count != popped.count { return false }
        // 用一个辅助栈来模拟出栈入栈的情况
        // 有个指针p用在poped数组中，开始指向第一个元素
        // 1. 遍历pushed数组，push每个元素
        // 2. 每次push完了，check下p对应的值，若栈顶内容和p相等，则进行一次pop，p指针前进，继续执行2，直到栈顶内容和p对应值不相等，或者栈已空
        // 3. 1、2两步即为模拟的全过程，全过程结束后，检查若栈仍不空，说明两个序列有问题
        var p = 0
        let stack = Stack<Int>()
        for value in pushed {
            stack.push(value)
            while p < popped.count, !stack.isEmpty,
                  let popedValue = stack.top(), popped[p] == popedValue {
                stack.pop()
                p += 1
            }
        }

        return stack.isEmpty
    }
    
    func validateStackSequences1(_ pushed: [Int], _ popped: [Int]) -> Bool {
        // 搞一个辅助栈stack
        // 对于每一个poped元素
        // 若top和poped元素不相等，则从pushed中追加元素到stack中，若一直到pushed结束，说明顺序不对，返回false；若找到了相等元素，则应该pop
        // 对于下个元素还是做这样操作，整个循环结束了，说明ok
        // 特殊情况，两个序列大小不等，或者有等于0的，直接返回false
        if pushed.isEmpty || popped.isEmpty || pushed.count != popped.count { return false }
        var pushedStart = 0
        let stack = Stack<Int>()
        for poppedValue in popped {
            if let top = stack.top(), top == poppedValue {
                stack.pop()
            } else {
                // 那就从pushed中添加，直到top==poppedValue
                for i in pushedStart..<pushed.count {
                    stack.push(pushed[i])
                    if let top = stack.top(), top == poppedValue {
                        stack.pop()
                        pushedStart  = i + 1
                        break
                    }
                }
            }
        }
        return stack.isEmpty
    }
}

/// https://leetcode-cn.com/problems/implement-stack-using-queues/
class MyStack {
    let dataQueue = CircularQueue(length: 1000)
    let tmpQueue = CircularQueue(length: 100)
    init() {
    }
    
    func push(_ x: Int) {
        dataQueue.enqueue(x)
    }
    
    func pop() -> Int {
        // 让所有数据出队列，保留最后一个
        defer {
            while let tmpV = tmpQueue.dequeue() {
                dataQueue.enqueue(tmpV)
            }
        }
        while let v = dataQueue.dequeue() {
            if dataQueue.isEmpty() {
                return v
            } else {
                tmpQueue.enqueue(v)
            }
        }
        return -1
    }
    
    func top() -> Int {
        defer {
            while let tmpV = tmpQueue.dequeue() {
                dataQueue.enqueue(tmpV)
            }
        }
        while let v = dataQueue.dequeue() {
            tmpQueue.enqueue(v)
            if dataQueue.isEmpty() {
                return v
            }
        }
        return -1
    }
    
    func empty() -> Bool {
        return dataQueue.isEmpty()
    }
}

class SortedStack {
    let dataStack = Stack<Int>()
    let tmpStack = Stack<Int>()
    init() {

    }
    
    func push(_ val: Int) {
        if let v = dataStack.top(), val > v {
            // 移动到tmpStack中的比val小的值，移动到临时栈中
            while let tmpV = dataStack.top(), val > tmpV {
                dataStack.pop()
                tmpStack.push(tmpV)
            }
            // 将val放到dataStack合适位置
            dataStack.push(val)
            // 临时栈中比val小的值移回到dataStack中
            while let tmpV = tmpStack.pop() {
                dataStack.push(tmpV)
            }
        } else {
            dataStack.push(val)
        }
    }
    
    func pop() {
        dataStack.pop()
    }
    
    func peek() -> Int {
        if let v = dataStack.top() {
            return v
        } else {
            return -1
        }
    }
    
    func isEmpty() -> Bool {
        return dataStack.isEmpty
    }
}

/// https://leetcode-cn.com/problems/min-stack/
class MinStack {
    let dataStack = Stack<Int>()
    let minDataStack = Stack<Int>()
    init() {

    }
    
    func push(_ val: Int) {
        dataStack.push(val)
        if let min = minDataStack.top(), min < val {
            minDataStack.push(min)
        } else {
            minDataStack.push(val)
        }
    }
    
    func pop() {
        dataStack.pop()
        minDataStack.pop()
    }
    
    func top() -> Int {
        if let v = dataStack.top() {
            return v
        }
        return -1
    }
    
    func getMin() -> Int {
        if let min = minDataStack.top() {
            return min
        }
        return -1
    }
}

/// https://leetcode-cn.com/problems/three-in-one-lcci/
class TripleInOne {
    
    struct StackItemInfo {
        /// 栈空间大小
        let size: Int
        /// 栈当前存储元素个数
        var count: Int
        /// 栈顶元素下标
        var topIndex: Int
        
        var isEmpty: Bool {
            return count == 0
        }
        
        var isFull: Bool {
            return count == size
        }
    }
    
    private var dataArray: [Int]
    private var stackInfoArray: [StackItemInfo]
    private let stackNum = 3
    
    init(_ stackSize: Int) {
        dataArray = Array<Int>(repeating: -1, count: stackSize * stackNum)
        stackInfoArray = [StackItemInfo]()
        for index in 0..<stackNum {
            let stackInfo = StackItemInfo(size: stackSize, count: 0, topIndex: index * stackSize - 1)
            stackInfoArray.append(stackInfo)
        }
    }
    
    func push(_ stackNum: Int, _ value: Int) {
        if !(0..<self.stackNum).contains(stackNum) { return }
        var stackInfo = stackInfoArray[stackNum]
        if !stackInfo.isFull {
            dataArray[stackInfo.topIndex+1] = value
            
            stackInfo.topIndex += 1
            stackInfo.count += 1
            stackInfoArray[stackNum] = stackInfo
        }
    }
    
    func pop(_ stackNum: Int) -> Int {
        if !(0..<self.stackNum).contains(stackNum) { return -1 }
        var stackInfo = stackInfoArray[stackNum]
        if !stackInfo.isEmpty {
            let topIndex = stackInfo.topIndex
            stackInfo.topIndex = topIndex - 1
            stackInfo.count -= 1
            stackInfoArray[stackNum] = stackInfo
            return dataArray[topIndex]
        }
        return -1
    }
    
    func peek(_ stackNum: Int) -> Int {
        if !(0..<self.stackNum).contains(stackNum) { return -1 }
        let stackInfo = stackInfoArray[stackNum]
        if !stackInfo.isEmpty {
            return dataArray[stackInfo.topIndex]
        }
        return -1
    }
    
    func isEmpty(_ stackNum: Int) -> Bool {
        if !(0..<self.stackNum).contains(stackNum) { return false }
        let stackInfo = stackInfoArray[stackNum]
        return stackInfo.isEmpty
    }
}

/// https://leetcode-cn.com/problems/calculator-lcci/
func calculate(_ s: String) -> Int {
    // 两个栈来实现，数据栈和操作符栈
    // 最终数据栈中只剩下一个数，就是结果
    // 大致流程是这样
    // 扫描字符串，若遇到数字字符，则尝试放入数据栈中：
    // 放入栈之前，判断操作符栈顶，若是*或/，则先计算一波（取出一个数据栈中的数据和操作符，进行计算，并放回数据栈中）
    // 若操作符栈顶元素不是*和/，则不能计算（因为不知道后面是否有高优先级的操作符）
    // 若遇到操作符字符，则直接入操作符栈
    // 扫描结束后，就可能要计算很多波了：操作符栈中取出一个+数据栈中取出两个数，计算完后，将结果放回数据栈中；持续上面操作，直到计算结束，最后数据栈中的结果就是
    
    let dataStack = Stack<Int>()
    let operatorStack = Stack<Character>()
    
    func isOperator(_ c: Character) -> Bool {
        return c == "*" || c == "/" || c == "+" || c == "-"
    }
    
    func isHighOperator(_ c: Character) -> Bool {
        return c == "*" || c == "/"
    }
    
    func isDigit(_ c: Character) -> Bool {
        return c >= "0" && c <= "9"
    }
    
    func isPriorityHigher(_ c1: Character, _ c2: Character) -> Bool {
        return (c1 == "*" || c1 == "/") && (c2 == "+" || c2 == "-")
    }
    // 扫描整个字符串
    var index = s.startIndex
    let endIndex = s.endIndex
    while index < endIndex {
        let c = s[index]
        if c == " " {
            index = s.index(after: index)
        } else if isDigit(c)  {
            var validNumStr = ""
            while index < endIndex, isDigit(s[index]) {
                validNumStr.append(s[index])
                index = s.index(after: index)
            }
            // number
            guard let num = Int(validNumStr) else {
                fatalError()
            }
            dataStack.push(num)
        } else if isOperator(c) {
            if operatorStack.isEmpty || isPriorityHigher(c, operatorStack.top()!) {
                operatorStack.push(c)
            } else {
                while let optr = operatorStack.top(),
                      !isPriorityHigher(c, optr),
                      let data1 = dataStack.pop(), let data2 = dataStack.pop() {
                    operatorStack.pop()
                    if optr == "+" {
                        dataStack.push(data2 + data1)
                    } else if optr == "-" {
                        dataStack.push(data2 - data1)
                    } else if optr == "*" {
                        dataStack.push(data2 * data1)
                    } else if optr == "/" {
                        dataStack.push(data2 / data1)
                    }
                }
                operatorStack.push(c)
            }
            index = s.index(after: index)
        }
    }
    
    while let optr = operatorStack.top(),
          let data1 = dataStack.pop(), let data2 = dataStack.pop() {
        operatorStack.pop()
        if optr == "+" {
            dataStack.push(data2 + data1)
        } else if optr == "-" {
            dataStack.push(data2 - data1)
        } else if optr == "*" {
            dataStack.push(data2 * data1)
        } else if optr == "/" {
            dataStack.push(data2 / data1)
        }
    }
    
    return dataStack.pop() ?? -1
}

func removeDuplicates(_ s: String) -> String {
    // 用一个栈放数据
    // 遍历每个字符，每次要放入栈中之前，先判断栈顶元素是否与当前元素相等
    // 若相等，则出栈；若不相等，则入栈；重复执行
    let stack = Stack<Character>()
    for char in s {
        if let topChar = stack.top(), topChar == char {
            stack.pop()
        } else {
            stack.push(char)
        }
    }
    
    var str = ""
    while let char = stack.pop() {
        str = String(char) + str
    }
    return str
}

func isValid(_ s: String) -> Bool {
    // 遍历每个字符
    // 如果栈为空，则加入到栈中
    // 如果不为空，并且是)]}其中之一时，则必须满足下面条件，才有可能是合理的
    // 1. 取出栈顶元素，和当前元素匹配，必须是成对的，不是则返回false
    // 结束遍历后，判断栈是否为空，不为空则返回false
    let stack = Stack<Character>()
    func isPair(left: Character, right: Character) -> Bool {
        switch (left, right) {
        case ("(", ")"), ("[", "]"), ("{", "}"):
            return true
        default:
            return false
        }
    }
    for char in s {
        if char == "(" || char == "[" || char == "{" {
            stack.push(char)
        } else {
            if let topChar = stack.top() {
                if isPair(left: topChar, right: char) {
                    stack.pop()
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    return stack.isEmpty
}

func validateStackSequences(_ pushed: [Int], _ popped: [Int]) -> Bool {
    if pushed.isEmpty || popped.isEmpty { return true }
    let stack1 = Stack<Int>()
    var index = -1
    for poppedValue in popped {
        if let tooped = stack1.top(), tooped == poppedValue {
            stack1.pop()
        } else {
            repeat {
                index += 1
                if index < pushed.count {
                    stack1.push(pushed[index])
                }
            } while index < pushed.count && pushed[index] != poppedValue
           
            if let tooped = stack1.top(), tooped == poppedValue {
                stack1.pop()
            } else {
                return false
            }
        }
    }
    return true
}

/// https://leetcode-cn.com/problems/daily-temperatures/submissions/
func dailyTemperatures(_ temperatures: [Int]) -> [Int] {
    // 单调栈实现方式
    // 使用一个栈来计算
    // 遍历每一个温度，对于每一个温度，都要做如下的事情：
    // 1. 当前正遍历的温度cur与栈顶温度top比较。若cur > top，则产生一个结果值，下标为top温度对应的下标，值为cur的下标减去top对应的下标，同时让top出栈
    // 若cur <= top，则暂时还不能产生结果，将下标入栈
    // 2. 若栈顶没有元素，则直接将下标入栈
    // 重复执行1和2的过程，在1和2过程中下标入栈时，则结束重复过程，遍历下一个温度
    var result = Array(repeating: 0, count:temperatures.count)
    let stack = Stack<Int>()
    for (index, temp) in temperatures.enumerated() {
        while let topTempIndex = stack.top(), temp > temperatures[topTempIndex] {
            result[topTempIndex] = index - topTempIndex
            stack.pop()
        }
        stack.push(index)
    }
    return result
}

/// https://leetcode-cn.com/problems/trapping-rain-water/
func trap(_ height: [Int]) -> Int {
    // 暴力解法
    // 计算每个柱子之上可以积多少水，然后进行求和
    // 每个柱子之上可以积的水应该这么计算：
    // y = (min(leftMaxHeight - rightMaxHeight) - height)
    // leftMaxHeight和rightMaxHeight的计算，则是向左向右一直寻找，找maxheight
    var sum = 0
    let count = height.count
    for (index, curHeight) in height.enumerated() {
        var leftMaxHeight = 0
        for leftIndex in stride(from: index - 1, to: -1, by: -1) {
            if height[leftIndex] > leftMaxHeight {
                leftMaxHeight = height[leftIndex]
            }
        }
        
        var rightMaxHeight = 0
        for rightIndex in stride(from: index + 1, to: count, by: 1) {
            if height[rightIndex] > rightMaxHeight {
                rightMaxHeight = height[rightIndex]
            }
        }
        
        let result = min(leftMaxHeight, rightMaxHeight) - curHeight
        if result > 0 {
            sum += result
        }
    }
    return sum
}

func trap1(_ height: [Int]) -> Int {
    // 在暴力解法基础上做简单的性能优化
    // 核心算法逻辑仍是暴力解法。只是，提前计算好每个元素的leftMaxHeight和rightMaxHeight，提前存好，用时直接取
    // 本质是空间换时间
    // 计算leftMaxHeight和rightMaxHeight有点小技巧，通过该技巧可以将时间复杂度降到O(n)
    // 以leftMaxHeight的计算为例
    // 定义一个leftMaxHeights表示每个元素位置左侧最大的高度
    // 每个元素的取值可以又前一个元素计算得出y = max(leftMaxHeights[preIndex], height[preIndex])
    let count = height.count
    var leftMaxHeights = Array(repeating: 0, count: count)
    var rightMaxHeights = Array(repeating: 0, count: count)
    for index in 1..<count {
        let preIndex = index - 1
        leftMaxHeights[index] = max(leftMaxHeights[preIndex], height[preIndex])
    }
    // 计算rightMaxHeights时逻辑类似，可以从右到做遍历
    for index in stride(from: count - 2, to: -1, by: -1) {
        let afterIndex = index + 1
        rightMaxHeights[index] = max(rightMaxHeights[afterIndex], height[afterIndex])
    }
    var sum = 0
    for (index, curHeight) in height.enumerated() {
        let leftMaxHeight = leftMaxHeights[index]
        let rightMaxHeight = rightMaxHeights[index]
        
        let result = min(leftMaxHeight, rightMaxHeight) - curHeight
        if result > 0 {
            sum += result
        }
    }
    return sum
}

