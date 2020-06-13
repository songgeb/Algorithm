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
