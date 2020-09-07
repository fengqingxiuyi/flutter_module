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

## FAQ

### Must specify a repository for deployment

具体报错信息如下：
```
* What went wrong:
Execution failed for task ':flutter:uploadArchives'.
> Could not publish configuration 'archives'
   > Must specify a repository for deployment
```

我遇到这个问题，是因为打snapshot包时，其打包产物的名称中snapshot没有大写。但是必须是`SNAPSHOT`全大写，否则就会报错。

### The number of method references in a .dex file cannot exceed 64K

具体报错信息如下：
```
D8: Cannot fit requested classes in a single dex file (# methods: 68879 > 65536)
com.android.builder.dexing.DexArchiveMergerException: Error while merging dex archives: 
The number of method references in a .dex file cannot exceed 64K.
Learn how to resolve this issue at https://developer.android.com/tools/building/multidex.html
	at com.android.builder.dexing.D8DexArchiveMerger.getExceptionToRethrow(D8DexArchiveMerger.java:131)
	at com.android.builder.dexing.D8DexArchiveMerger.mergeDexArchives(D8DexArchiveMerger.java:118)
	at com.android.build.gradle.internal.transforms.DexMergerTransformCallable.call(DexMergerTransformCallable.java:102)
	at com.android.build.gradle.internal.tasks.DexMergingTaskRunnable.run(DexMergingTask.kt:444)
	at com.android.build.gradle.internal.tasks.Workers$ActionFacade.run(Workers.kt:335)
	at org.gradle.workers.internal.AdapterWorkAction.execute(AdapterWorkAction.java:50)
	at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:47)
	at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1$1.create(NoIsolationWorkerFactory.java:65)
	at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1$1.create(NoIsolationWorkerFactory.java:61)
	at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:98)
	at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.execute(NoIsolationWorkerFactory.java:61)
	at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
	at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor$CallableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:416)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor$CallableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:406)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor$1.execute(DefaultBuildOperationExecutor.java:165)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:250)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:158)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor.call(DefaultBuildOperationExecutor.java:102)
	at org.gradle.internal.operations.DelegatingBuildOperationExecutor.call(DelegatingBuildOperationExecutor.java:36)
	at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
	at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:56)
	at org.gradle.workers.internal.DefaultWorkerExecutor$3.call(DefaultWorkerExecutor.java:215)
	at org.gradle.workers.internal.DefaultWorkerExecutor$3.call(DefaultWorkerExecutor.java:210)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:215)
	at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
	at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:131)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
	at org.gradle.internal.concurrent.ManagedExecutorImpl$1.run(ManagedExecutorImpl.java:48)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at org.gradle.internal.concurrent.ThreadFactoryImpl$ManagedThreadRunnable.run(ThreadFactoryImpl.java:56)
	at java.lang.Thread.run(Thread.java:748)
Caused by: com.android.tools.r8.CompilationFailedException: Compilation failed to complete
	at com.android.tools.r8.utils.t.a(:55)
	at com.android.tools.r8.D8.run(:11)
	at com.android.builder.dexing.D8DexArchiveMerger.mergeDexArchives(D8DexArchiveMerger.java:116)
	... 34 more
Caused by: com.android.tools.r8.utils.AbortException: Error: null, Cannot fit requested classes in a single dex file (# methods: 68879 > 65536)
	at com.android.tools.r8.utils.Reporter.a(:21)
	at com.android.tools.r8.utils.Reporter.a(:7)
	at com.android.tools.r8.dex.VirtualFile.a(:33)
	at com.android.tools.r8.dex.VirtualFile$h.a(:5)
	at com.android.tools.r8.dex.ApplicationWriter.a(:13)
	at com.android.tools.r8.dex.ApplicationWriter.write(:35)
	at com.android.tools.r8.D8.d(:44)
	at com.android.tools.r8.D8.b(:1)
	at com.android.tools.r8.utils.t.a(:23)
	... 36 more


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:mergeDexDebug'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.Workers$ActionFacade
   > com.android.builder.dexing.DexArchiveMergerException: Error while merging dex archives: 
     The number of method references in a .dex file cannot exceed 64K.
     Learn how to resolve this issue at https://developer.android.com/tools/building/multidex.html
```

全局搜索`build.gradle`文件中的minSdkVersion，将其改为`21`即可，有以下几个目录：

```
1. flutter_module/.android/app/build.gradle
2. flutter_module/.android/Flutter/build.gradle
```