//
//  RecursionTree.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/12/2.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

// 递归树

class RecursionTree {
  
  /// 容器中有1个细胞，细胞生命周期是3小时，1小时分裂一次，求解n小时后有多少细胞
  /// 1个分裂成两个，但这两个细胞的生命周期不同
  /// https://time.geekbang.org/column/article/69388?utm_term=zeus67XQQ&utm_source=wechat&utm_medium=infoq&utm_campaign=129-onsell&utm_content=textlink0125   思考题
  /// https://xiaozhuanlan.com/topic/6091358742 头条面试题
  static func split(_ hour: Int) -> Int {
    if hour == 0 { return 1 }
    if hour == 1 { return 2 }
    if hour == 2 { return 4 }
    if hour == 3 { return 7 }
    
    return 2 * split(hour - 1) - split(hour - 4)
  }
  
  /// 测试细胞分裂
  static func testSplit() {
    print(split(4))
  }
}
