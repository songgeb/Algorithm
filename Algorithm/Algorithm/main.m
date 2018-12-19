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

//a1、a2两个数组，排好序的，a1有足够空间放下a2。先要求a2合并到a1中，仍然排好序
//假定按照升序排列
//o(n)复杂度
void reOrder() {
    int a1[10] = {8, 9, 10, 11, 13};
    int a2[5] = {1, 3, 11, 13, 17};
    //先遍历一遍a2，记录元素个数，算出合并后的总个数
    //三个下标，一个指向合并后的最后的位置copyPosition，一个指向原a1有内容的最后的位置a1End，一个指向原a2有内容的最后的位置a2End
    //1. 比较a2End和a1End
    //2. 若a2End >= a1End，则a2End复制到copyPosition，a2End前移，copyPosition前移，重复1步骤
    //3. 若a2End < a1End，则a1End复制到copyPosition，a1End前移，copyPosition前移，重复1步骤
    //4. 重复1、2、3步骤，直到a1End或a2End没办法再往前移
    //5. 最后，若a2还有剩余，则将剩余部分，一个个复制到a1中
    
    //省去计算元素个数代码，时间复杂度为o(n)
    int a1End = 4;
    int a2End = 4;
    int copyPosition = 9;
    
    while (a1End >= 0 && a2End >= 0) {
        if (a2[a2End] >= a1[a1End]) {
            a1[copyPosition] = a2[a2End--];
        } else {
            a1[copyPosition] = a1[a1End--];
        }
        copyPosition --;
    }
    
    while (a2End >= 0 && copyPosition >= 0) {
        a1[copyPosition--] = a2[a2End--];
    }
    
    printf("合并后结果-->");
    for (int i = 0; i < 10; i++) {
        printf("%d ", a1[i]);
    }
    printf("\n");
}

//MARK: - 链表
typedef struct ListNode {
    int value;
    struct ListNode *next;
} ListNode;

void printList(ListNode **pHead) {
    //打印链表
    ListNode *pNode = *pHead;
    while (pNode != NULL) {
        printf("%d ", pNode->value);
        pNode = pNode->next;
    }
    printf("\n");
}

void addToTail(ListNode **pHead, int value) {
    //如果pHead是空就结束
    //创建一个新的节点
    //若*pHead == NULL说明是空链表，要给*pHead赋值。结束
    //若不是空链表，则找到链表最后一个节点，将新节点接上
    if (pHead == NULL) { return; }
    ListNode *node = (ListNode *)malloc(sizeof(ListNode));
    node->value = value;
    node->next = NULL;
    
    if (*pHead == NULL) {
        *pHead = node;
    } else {
        ListNode *pNode = *pHead;
        while (pNode->next != NULL) {
            pNode = pNode->next;
        }
        pNode->next = node;
    }

    printList(pHead);
}

void deleteListNode(ListNode **pHead, int value) {
    //若空链表则返回
    //找到待删除节点的前一个节点，让它的next赋值为待删除节点的next
    if (pHead == NULL || *pHead == NULL)
        return;
    ListNode *pNode = *pHead;
    if (pNode->value == value) {
        //头结点
        *pHead = pNode->next;
    } else {
        //非头结点
        while(pNode->next != NULL) {
            if (pNode->next->value == value) {
                ListNode *toDeleteNode = pNode->next;
                pNode->next = toDeleteNode->next;
                free(toDeleteNode);
                break;
            }
            pNode = pNode->next;
        }
    }
    printList(pHead);
}

//从尾到头输出链表
//o(n)时间复杂度
void printListReversely(ListNode **pHead) {
    //使用尾插法构造一个新的链表，再正序输出
    //不破坏原链表
    if (pHead == NULL || *pHead == NULL)
        return;
    ListNode *pNode = *pHead;
    
    ListNode *newListHead = (ListNode *)malloc(sizeof(ListNode));
    newListHead->value = pNode->value;
    newListHead->next = NULL;
    
    pNode = pNode->next;
    while(pNode != NULL) {
        ListNode *newNode = (ListNode *)malloc(sizeof(ListNode));
        newNode->value = pNode->value;
        newNode->next = newListHead;
        
        newListHead = newNode;
        pNode = pNode->next;
    }
    
    printf("翻转后结果->");
    printList(&newListHead);
    
    printf("原链表->");
    printList(pHead);
}

//递归的反向输出链表
//o(n)
//当链表太大时，栈调用次数太多，影响性能
void printListReversely_Recursively(ListNode **pHead) {
    if (pHead == NULL || *pHead == NULL) {
        return;
    }
    printListReversely(&((*pHead)->next));
    printf("%d ", (*pHead)->value);
}

//递归反向打印链表的循环实现
//不会。。。。。。。
#warning 不知道咋写了
void printListReversely_Loop(ListNode **pHead) {
    if (pHead == NULL || *pHead == NULL) {
        return;
    }
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        //        srand((unsigned) time(NULL));
        //        int toFindValue = rand() % 20;
        //        findInMatrix(toFindValue);
        
//        replaceBlankPoorly();
//        replaceBlank();
//        reOrder();
        ListNode *list;
        addToTail(&list, 7);
        addToTail(&list, 8);
        addToTail(&list, 9);
        addToTail(&list, 10);
        
        printListReversely(&list);
        
//        deleteListNode(&list, 10);
//        deleteListNode(&list, 7);
//        deleteListNode(&list, 9);
    }
    return 0;
}
