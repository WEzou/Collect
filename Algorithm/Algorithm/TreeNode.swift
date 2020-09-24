//
//  TreeNode.swift
//  Algorithm
//
//  Created by oncezou on 2018/12/5.
//  Copyright © 2018年 oncezw. All rights reserved.
//

import Foundation
import UIKit

// MARK: 二叉树
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
    }
    
    convenience init(_ val: Int,_ left: TreeNode?, _ right: TreeNode?) {
        self.init(val)
        self.left = left
        self.right = right
    }
    
    /*  二叉查找树，它是一种特殊的二叉树
     *  它的特点就是左子树中节点的值都小于根节点的值，右子树中节点的值都大于根节点的值.
     */
    // MARK: 判断一颗二叉树是否为二叉查找树
    func isValidBST() -> Bool {
        return _helper(self, nil, nil)
    }
    
    private func _helper(_ node: TreeNode?, _ min: Int?, _ max: Int?) -> Bool {
        guard let node = node else {
            return true
        }
        // 所有右子节点都必须大于根节点
        if let min = min, node.val <= min {
            return false
        }
        // 所有左子节点都必须小于根节点
        if let max = max, node.val >= max {
            return false
        }
        
        return _helper(node.left, min, node.val) && _helper(node.right, node.val, max)
    }
    
    // MARK: 计算树的最大深度
    static func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        return max(maxDepth(root.left), maxDepth(root.right)) + 1
    }
    
    // MARK: 判断树中是否包含某个值
    func search(_ value: Int) -> TreeNode? {
        if value == self.val {
            return self
        }
        
        if let treeNode = self.left?.search(value) {
            return treeNode
        }
        
        if let treeNode = self.right?.search(value) {
            return treeNode
        }
        
        return nil
    }
    
    // MARK: 递归遍历
    /*
     * 前序 根左右
     */
    static func recursionPreorderTraversal(_ root: TreeNode?) {
        if (root != nil) {
            print("\(root!.val)")
            recursionPreorderTraversal(root!.left);
            recursionPreorderTraversal(root!.right);
        }
    }
    
    /*
     * 中序 左根右
     */
    static func recursionMidorderTraversal(_ root: TreeNode?) {
        if (root != nil) {
            recursionMidorderTraversal(root!.left);
            print("\(root!.val)")
            recursionMidorderTraversal(root!.right);
        }
    }
    /*
     * 后序 左右根
     */
    static func recursionPostorderTraversal(_ root: TreeNode?) {
        if (root != nil) {
            recursionPostorderTraversal(root!.left);
            recursionPostorderTraversal(root!.right);
            print("\(root!.val) ")
        }
    }
    
    // MARK: 用栈实现的遍历
    /*
     * 前序遍历
     */
    static func preorderTraversal(root: TreeNode?) -> [Int] {
        var res = [Int]()
        var stack = [TreeNode]()
        var node = root
        
        while !stack.isEmpty || node != nil {
            if node != nil {
                res.append(node!.val)
                stack.append(node!)
                node = node!.left
            } else {
                node = stack.removeLast().right
            }
        }
        
        return res
    }
    
    /*
     * 中序遍历
     */
    static func midorderTraversal(root: TreeNode?) -> [Int] {
        var res = [Int]()
        var stack = [TreeNode]()
        var node = root
        
        while !stack.isEmpty || node != nil {
            if node != nil {
                stack.append(node!)
                node = node!.left
            } else {
                let nodec = stack.removeLast()
                res.append(nodec.val)
                node = nodec.right
            }
        }
        
        return res
    }
    
    /*
     * 后序遍历 *********待补充***********
     */
    private static func postorderTraversal(root: TreeNode?) -> [Int] {
        let res = [Int]()
        var stack = [TreeNode]()
        var node = root
        
        while !stack.isEmpty || node != nil {
            if node != nil {
                stack.append((node!))
                node = node!.left
            } else {
          
            }
        }
        
        return res
    }
    
    // MARK: 按层级排序
    static func levelOrder(root: TreeNode?) -> [[Int]] {
        var res = [[Int]]()
        // 用数组来实现队列
        var queue = [TreeNode]()
        
        if let root = root {
            queue.append(root)
        }
        
        while queue.count > 0 {
            let size = queue.count
            var level = [Int]()
            
            for _ in 0 ..< size {
                let node = queue.removeFirst()
                
                level.append(node.val)
                if let left = node.left {
                    queue.append(left)
                }
                if let right = node.right {
                    queue.append(right)
                }
            }
            res.append(level)
        }
        
        return res
    }
    
    // MARK: 二叉树反转
    static func inverse(_ treeNode: TreeNode?) -> TreeNode? {
        guard  let root = treeNode else {
            return nil
        }
        let node = root.left
        root.left = inverse(root.right)
        root.right = inverse(node)
        return root
    }
}

