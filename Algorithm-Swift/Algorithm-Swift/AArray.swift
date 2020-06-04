//
//  AArray.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/6/3.
//  Copyright © 2020 Songgeb. All rights reserved.
//

/// 字符串中空格替换成%20(原地进行)
/// 时间复杂度是O(n)
func replaceSpace(_ s: String) -> String {
    if s.isEmpty { return "" }
    // check
    // 空串-ok
    // 只包含空格-ok
    // 不包含空格-ok
    
    // 扫描一遍字符串，统计有多少空格spaceCount
    // 计算好要被移动的字符将会所处的位置，
    
    var spaceCount = 0
    for c in s {
        if c == " " { spaceCount += 1 }
    }
    
    if spaceCount == 0 {
        return s
    }
    
    var newCharacters = [Character].init(repeating: "#", count: s.count + spaceCount * 2)
    for (index, c) in s.enumerated() {
        newCharacters[index] = c
    }
    // 两个指针，一个在后，表示要被覆盖的指针replacePointer
    // 一个在前，表示字符串内容，contentPointer
    // 初始情况contentPointer从后向前找到第一个不是c字符的位置，replacePointer则在最末尾
    // 然后一边替换，一边两个指针往前进，知道contentPointer小于0，说明结束了
    
    var contentPointer, replacePointer: Int
    replacePointer = newCharacters.count - 1
    contentPointer = newCharacters.count - 1
    
    while newCharacters[contentPointer] == "#" {
        contentPointer -= 1
    }
    
    while contentPointer >= 0 {
        if newCharacters[contentPointer] == " " {
            newCharacters[replacePointer] = "0"
            newCharacters[replacePointer - 1] = "2"
            newCharacters[replacePointer - 2] = "%"
            replacePointer -= 3
        } else {
            newCharacters[replacePointer] = newCharacters[contentPointer]
            replacePointer -= 1
        }
        contentPointer -= 1
    }
    
    return String(newCharacters)
}

/// 两个有序数组A和B，将B何如到A中，保证仍然有序
func merge(_ A: inout [Int], _ m: Int, _ B: [Int], _ n: Int) {
    // 三个指针
    // a指向数组A最后一个有内容的元素，b指向数组B最有一个元素，r指向数组A最后的位置
    // 比较a和b对应的元素，选择大的放到r的位置，大的指针前进，同时r也前进，知道r<0，说明结束
    // check，若A是空数组，应直接拷贝B到A中
    // 若B是空数组，则什么都不做；若两个都是空什么都不做
    if B.isEmpty {
        return
    }
    
    if A.isEmpty {
        for value in B {
            A.append(value)
        }
        return
    }
    
    var a, b, r: Int
    a = m - 1
    b = n - 1
    r = m + n - 1
    while r >= 0, a >= 0, b >= 0 {
        if A[a] > B[b] {
            A[r] = A[a]
            a -= 1
        } else {
            A[r] = B[b]
            b -= 1
        }
        r -= 1
    }
    
    if r >= 0 {
        var leftArray = a >= 0 ? A : B
        var left = a >= 0 ? a : b
        while r >= 0 {
            A[r] = leftArray[left]
            left -= 1
            r -= 1
        }
    }
}
