//
//  Bit.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/6/4.
//  Copyright © 2020 Songgeb. All rights reserved.
//

/// 位运算相关算法
class Bit {
    /// 输入一个整数，求出这个整数二进制的表示中有几个1
    func hammingWeight(_ n: Int) -> Int {
        /// 思路1: 判断1的个数，可以从低位到高位挨个看是否每一位是1，关键在于将每一位与1进行“与(&)”运算，如果结果是1，则说明整数的二进制该位置是1，否则是0
        /// 所以每次与运算技术后，让原整数右移一位，直到原整数是0
        
//        var count = 0
//        var n = n
//
//        while n != 0 {
//            if n & 1 != 0 {
//                count += 1
//            }
//            n = n >> 1
//        }
//        return count
        
        /// 但思路1有问题，因为负数的二进制高位是1，如果继续右移高位还是1，这样有可能导致上面的while循环无法停止
        /// 思路2：我们让输入整数不动，先拿1与整数做与运算，再对1左移一位继续做与运算，重复进行也能计算出输入整数中1的个数
//        var count = 0
//        var flag = 1
//        while flag != 0 {
//            if flag & n != 0 {
//                count += 1
//            }
//            flag <<= 1
//        }
//        return count
        
        /// 思路3：还有一个比较讨巧的办法
        /// 核心是这个思路，一个二进制数，减去1，然后与自己做“与”运算，那从原二进制数最后一个1到最后一位就都是0了
        /// 11010减去1后是11001,两者做“与”运算后，11000
        /// 上面的操作相当于消灭了最后一位1
        /// 根据这个特点，我们对输入的整数一直做“减一+与运算”的操作，直到最终结果是0
        /// 这个算法相比思路2的有点在于，思路2要一直左移的位数要么是32、64等，而思路3则是循环次数减少
        var count = 0
        var flag = n
        while flag != 0 {
            flag = (flag - 1) & flag
            count += 1
        }
        return count
    }
    
    /// 一句话判断一个数是不是2的整数次方
    func judge2Power(_ n: Int) -> Bool {
        /// 因为每个2的整数次方的二进制中有且仅有1个1
        // 所以用全是1，和n进行“与”运算，如果结果还等于自己，说明仅有1个1
        // 使用“减1+与运算”的操作逻辑
        return (n - 1) & n == 0
    }
    
    /// 从n的二进制数到m的二进制数，需要修改多少位二进制
    func changeCount(_ n: Int, _ m: Int) -> Int {
        // n和m先做“异或”处理，这样结果中所有的1的个数就是需要修改的二进制个数
        let r = n ^ m
        
        // 计算二进制数中1的个数
        // 先让数与1做“与”运算，如果不等于0，则说明出现一个1
        // 然后让1一直左移下去
        
        var count = 0
        var flag = 1
        while flag != 0 {
            if flag & r != 0 {
                count += 1
            }
            flag <<= 1
        }
        return count
    }
    
    /// 这个问题的描述可以参考AString文件中
    // 该问题涉及到的位操作实际是：统计一个字符串（字符串字符只能是小写字母）不同字母数
    func maxFreq(_ s: String, _ maxLetters: Int, _ minSize: Int, _ maxSize: Int) -> Int {
        return 0
    }
    
    /// 通过位运算，判断s中是否有重复字母，s中只可能是小写英文字母
    /// 本算法返回不同字母个数
    func differentLetters(_ s: String) -> Int {
        // 我们用32位的二进制来存储26个英文字母，最低位表示a，最高位表示z
        // a的位置是1，说明s中包含字母a，比如0011，说明s中包含字母a和b
        // 如何构造这个二进制数呢
        // num表示这个二进制数，每读到一个字符，和字符a做减法得到差值distance，然后 1<<distance，再与num做或运算就是最终num了
        // 构造完二进制数后，再对每个字符做判断
        // 用num和待比较的字符对应的二进制数做与运算，如果不等于0，说明存在重复的，如果等于0说明是不同的字符
        
        // 注意在for循环中，应该先比较，再把当前字符加入到num中
        var differentLetterCount = 0
        var num = 0
        let a: Character = "a"
        for c in s {
            guard let cValue = c.asciiValue, let aValue = a.asciiValue else {
                return -1
            }
            
            let binaryC = 1 << Int(cValue - aValue)
            if binaryC & num == 0 {
                differentLetterCount += 1
            }
            
            num = binaryC | num
        }
        return differentLetterCount
    }
}
