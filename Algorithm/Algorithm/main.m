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

//MARK: - 二维数组整数中查找某值
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
        if (value == rightTopValue) {
            success = true;
            break;
        } else if (rightTopValue > value) {
            findColumns -= 1;
        } else {
            findRows -= 1;
        }
    }
    if (!success) {
        printf("没找到啊!\n");
    }
}

//MARK: - 替换字符串中的空格为%20（假定数组有足够空间存放替换的字符）
//o(n)复杂度
void replaceBlank() {
    char str[100] = "";
    printf("替换前-->%s\n", str);
    //遍历一遍字符串，记录空格数
    //声明两个指针，一个在原字符串结尾处end，一个在替换后字符串结尾处copyPosition
    //end往前走，如果不是空格，则copy到copyPosition，copyPosition也往前进1；如果是空格，则copyPostion改为%20，继续迁移；直到end和copyPosition重合
    char *end = str;
    int blankCount = 0;
    while (*end != '\0') {
        if (*end == ' ') {
            blankCount ++;
        }
        end ++;
    }
    char *copyPosition = end + blankCount * 2;
    while (end < copyPosition) {
        if (*end == ' ') {
            *copyPosition = '0';
            *(copyPosition - 1) = '2';
            *(copyPosition - 2) = '%';
            copyPosition -= 3;
        } else {
            *copyPosition = *end;
            copyPosition --;
        }
        end --;
    }
    printf("替换后结果->%s\n", str);
}

//o(n^2)时间复杂度
void replaceBlankPoorly() {
//    char str[100] = "ni na me niubi za bu shangtian ne?";
    char str[100] = " 6";
    printf("替换前->%s\n", str);
    //开始遍历字符串，当遇到空格时，后面的字符向后移两个位置
    char *p = str;
    while (*p != '\0') {
        if (*p == ' ') {
            //先找到末尾
            char *end = p;
            while (*end != '\0') {
                end ++;
            }
            //复制数据
            char *copyPosition = end + 2;
            while (end != p) {
                *copyPosition = *end;
                copyPosition--;
                end--;
            }
            *p = '%';
            *(p+1) = '2';
            *(p+2) = '0';
        }
        p++;
    }
    printf("替换后结果是-->%s\n", str);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        //        srand((unsigned) time(NULL));
        //        int toFindValue = rand() % 20;
        //        findInMatrix(toFindValue);
        
//        replaceBlankPoorly();
        replaceBlank();
    }
    return 0;
}
