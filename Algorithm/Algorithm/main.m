//
//  main.m
//  Algorithm
//
//  Created by songgeb on 2018/12/15.
//  Copyright © 2018年 songgeb. All rights reserved.
//

#import <Foundation/Foundation.h>

void foo(int value, int a[4][4]);
void findInMatrix(int);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        srand((unsigned) time(NULL));
        int toFindValue = rand() % 20;
        findInMatrix(toFindValue);
    }
    return 0;
}

void findInMatrix(int value) {
    int rows = 4;
    int columns = 4;
    int a[rows][columns];
    
    int xx = 1;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < columns; j++) {
            a[i][j] = xx ++;
        }
    }
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < columns; j++) {
            printf("%d", a[i][j]);
            printf(" ");
        }
        printf("\n");
    }
    
    //algorithm begins
    //1. 定义两个整型变量，记录当前可查找的行和列的数量；findRows, findColumns, 初始值为二维数组总行数和总列数
    //2. 定位到矩阵右上角的值, 即a[0][findColumns-1]
    //3. 是否是查找值？如果是，则结束；如果不是，进行下一步
    //4. 如果大于查找值，则该列无需再查找，findColumns = findColumns - 1。
    //5. findColumns值等于0，说明，已无可查询的数据，程序结束，未找到数据。如果大于0，则重复2步骤
    //6. 如果小于查找值，则该行无需再查找，findRows = findRows - 1。
    //7. findRows值等于0，说明，已无可查询的数据，程序结束，未找到数据。如果大于0，则重复2步骤
    printf("要查找的值是-->%d\n", value);
    foo(value, a);
}

void foo(int value, int a[4][4]) {
    int findRows = 4;
    int findColumns = 4;
    
    Boolean success = false;
    while (findRows != 0 && findColumns != 0) {
        int rightTopValue = a[4 - findRows][findColumns - 1];
        printf("当前值-->%d\n", rightTopValue);
        if (value == rightTopValue) {
            printf("已找到，位置是第%d行, 第%d列\n", 4 - findRows + 1, findColumns);
            success = true;
            break;
        }
        
        if (rightTopValue > value) {
            findColumns -= 1;
            printf("最右列没有用!\n");
        }
        
        if (rightTopValue < value) {
            findRows -= 1;
            printf("最上行没有用!\n");
        }
    }
    if (!success) {
        printf("没找到啊!\n");
    }
}
