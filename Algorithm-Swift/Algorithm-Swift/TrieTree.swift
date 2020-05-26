//
//  TrieTree.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/5/26.
//  Copyright © 2020 Songgeb. All rights reserved.
//

class TrieTreeNode {
    
    let data: Character
    var isEndingChar = false
    /// data字符只可能是小写a-z的字符，且数组下标是根据ascii值-a的ascii得到
    var children: [TrieTreeNode?]
    
    init (data: Character) {
        self.data = data
        children = [TrieTreeNode?].init(repeating: nil, count: 26)
    }
}

/// Trie树，字符串前缀树
class TrieTree {
    let root: TrieTreeNode
    
    init() {
        root = TrieTreeNode(data: "/")
    }
    
    func insert(_ str: String) {
        if str.count == 0 { return }
        // check: 字符串为空时，已存在的单词，不存在的单词
        // 从根节点开始，只要没有到叶子节点，或者单词没有结束，就继续迭代
        // 声明一个变量用于跟踪节点
        // 还要有个下标变量，用于获取相应位置的字符
        // 迭代中，取出每一个字符，看树种有没有匹配相对应的元素
        // 若匹配，则p和index继续前进，继续迭代；反之则跳出迭代
        // 迭代结束后，若index并没有超过单词数，说明要创建一个链，连接到p位置
        
//        var p = root
//        var index = 0
//        while index < str.count {
//            let c = str[index]
//            guard let cAsciiValue = c.asciiValue, let aAsciiValue = Character("a").asciiValue else {
//                return
//            }
//            if let treeNode = p.children[Int(cAsciiValue - aAsciiValue)], treeNode.data == c {
//                p = treeNode
//                index += 1
//            } else {
//                break
//            }
//        }
//
//        if index >= str.count {
//            // 说明已经存在该单词
//            print("路径上已经已经存在该单词! -> \(str)")
//            if !p.isEndingChar {
//                p.isEndingChar = true
//            }
//            return
//        }
//
//        for i in index..<str.count {
//            let c = str[i]
//            let node = TrieTreeNode(data: c)
//            guard let cAsciiValue = c.asciiValue, let aAsciiValue = Character("a").asciiValue else {
//                return
//            }
//            p.children[Int(cAsciiValue - aAsciiValue)] = node
//            p = node
//
//            if i == str.count - 1 {
//                p.isEndingChar = true
//            }
//        }
        
        // 还有一个更简单的实现
        // 一个p指针
        // 遍历整个待搜索的字符串
        // 对于每一个字符，迭代中要做的事情都是，看下p相应的孩子是不是空，如果是空，那就新建一个节点，否则就继续往下走，p指针也要走
        // 走到最后一个时，标记一下字符串结束
        var p: TrieTreeNode? = root
        for i in 0..<str.count {
            let c = str[i]
            guard let cAsciiValue = c.asciiValue, let aAsciiValue = Character("a").asciiValue else {
                fatalError()
            }
            
            let index = Int(cAsciiValue - aAsciiValue)
            if p?.children[index] == nil {
                let newNode = TrieTreeNode(data: c)
                p?.children[index] = newNode
            }
            p = p?.children[index]
        }
        p?.isEndingChar = true
    }
    
    func search(_ str: String) -> Bool {
        // 一个p指针，从根节点开始
        // 遍历待搜索的字符串
        // 从p的孩子中，取出相应位置的子节点对应的字符，与字符串中字符比较
        // 若子节点不存在，则直接返回false
        // 若字节存在且相等，则继续迭代，p也要进行更新
        // 迭代结束后，看下最终的p是否是结束标识，若是结束位置，则返回true，否则false
        var p: TrieTreeNode? = root
        for i in 0..<str.count {
            let c = str[i]
            
            guard let cAsciiValue = c.asciiValue, let aAsciiValue = Character("a").asciiValue else {
                fatalError()
            }
            let index = Int(cAsciiValue - aAsciiValue)
            if p?.children[index] == nil {
                return false
            }
            p = p?.children[index]
        }
        
        if p?.isEndingChar ?? false {
            return true
        }
        
        return false
    }
    
    func startsWith(_ str: String) -> Bool {
        if str.count == 0 { return false }
        
        var p: TrieTreeNode? = root
        for i in 0..<str.count {
            let c = str[i]
            
            guard let cAsciiValue = c.asciiValue, let aAsciiValue = Character("a").asciiValue else {
                fatalError()
            }
            let index = Int(cAsciiValue - aAsciiValue)
            if p?.children[index] == nil {
                return false
            }
            p = p?.children[index]
        }
        
        return true
    }
}

class TrieTreeNodeTest {
    
    static func test() {
        let tree = TrieTree()
        print("插入apple")
        tree.insert("apple");
//        print("搜索apple->\(tree.search("apple"))")   // 返回 true
        print("搜索app->\(tree.search("app"))")     // 返回 false
        
        let b1 = tree.startsWith("app"); // 返回 true
        print("app是前缀吗->\(b1)")
        
        print("插入app")
        tree.insert("app");
        
        let b2 = tree.search("app");
        print("搜索app->\(b2)")
    }
}
