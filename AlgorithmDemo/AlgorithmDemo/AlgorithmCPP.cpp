//
//  main.cpp
//  C++
//
//  Created by Johnson on 2020/9/1.
//  Copyright © 2020 Johnson. All rights reserved.
//
#include "CBridging.h"
#include <iostream>
#include <vector>
#include <string>

using namespace std;
std::vector<std::vector<std::string>> res;

/* 是否可以在 board[row][col] 放置皇后？ */
bool isValid(std::vector<std::string>& board, int row, int col) {
    int n = (int)board.size();
    // 检查列是否有皇后互相冲突
    for (int i = 0; i < n; i++) {
        if (board[i][col] == 'Q')
            return false;
    }
    // 检查右上方是否有皇后互相冲突
    for (int i = row - 1, j = col + 1;
         i >= 0 && j < n; i--, j++) {
        if (board[i][j] == 'Q')
            return false;
    }
    // 检查左上方是否有皇后互相冲突
    for (int i = row - 1, j = col - 1;
         i >= 0 && j >= 0; i--, j--) {
        if (board[i][j] == 'Q')
            return false;
    }
    return true;
}

// 路径：board 中小于 row 的那些行都已经成功放置了皇后
// 选择列表：第 row 行的所有列都是放置皇后的选择
// 结束条件：row 超过 board 的最后一行
void backtrack(std::vector<std::string>& board, int row) {
    // 触发结束条件
    if (row == board.size()) {
        res.push_back(board);
        return;
    }
    
    int n = (int)board[row].size();
    for (int col = 0; col < n; col++) {
        // 排除不合法选择
        if (!isValid(board, row, col))
            continue;
        // 做选择
        board[row][col] = 'Q';
        // 进入下一行决策
        backtrack(board, row + 1);
        // 撤销选择
        board[row][col] = '_';
    }
}


/* 输入棋盘边长 n，返回所有合法的放置 */
std::vector<std::vector<std::string>> CPP_solveNQueues(int n) {
    // '.' 表示空，'Q' 表示皇后，初始化空棋盘。
    std::vector<std::string> board(n, std::string(n, '_'));
    backtrack(board, 0);    
    return res;
}



void performSolveNQueues(int n) {
    // insert code here...
    std::cout << "Hello, solveNQueues!\n";
    
    
    CPP_solveNQueues(5);
    
    for (int i = 0; i < res.size(); i++) {
        for(int j = 0; j < res[i].size(); j++) {
            std::cout << res[i][i];
        }
         std::cout << "\n";
    }
}

void printHellowAlgorithmCPP(void) {
    printf("hellow world,I am is AlgorithmCPP language\n");
}
