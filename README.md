# flutter_module

A new Flutter module.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

## Maven

### 创建Maven仓库

1. 进入该页面：<http://nexus.skio.cn/#admin/repository/repositories>
2. 点击`Create Repository`按钮
3. 选择`maven2(hosted)`
4. 填写仓库名称
5. 选择`Version policy`：Release或Snapshot

### 获取仓库地址

1. 以flutter仓库为例，先进入该页面：<http://nexus.skio.cn/#admin/repository/repositories:flutter>
2. 复制下面的URL: `http://nexus.skio.cn/repository/flutter/`

### FAQ

打snapshot包，其打包产物的名称中snapshot必须是`SNAPSHOT`全大写，否则会报错：
```
* What went wrong:
Execution failed for task ':flutter:uploadArchives'.
> Could not publish configuration 'archives'
   > Must specify a repository for deployment
```
