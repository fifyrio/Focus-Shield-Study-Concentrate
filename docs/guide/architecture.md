# 架构设计

Focus Shield 采用 MVVM (Model-View-ViewModel) 架构模式，实现了清晰的关注点分离和高度可测试的代码结构。

## 整体架构

### 应用层次结构
```
┌─────────────────────────────────────┐
│              Views                  │  ← UI 层
├─────────────────────────────────────┤
│            ViewModels               │  ← 业务逻辑层
├─────────────────────────────────────┤
│             Services                │  ← 服务层
├─────────────────────────────────────┤
│             Models                  │  ← 数据模型层
└─────────────────────────────────────┘
```

## 核心应用结构

应用使用基于 TabView 的导航，包含四个主要部分：

### 1. ShieldView - 专注盾牌
- **功能**: 主要的专注/阻止界面，管理应用阻止
- **职责**: 应用阻止状态管理、专注会话控制、计时器功能
- **ViewModel**: `ShieldViewModel`

### 2. DecksView - 学习卡片
- **功能**: 闪卡套牌管理和学习界面
- **职责**: 套牌集合管理、CRUD操作、进度跟踪
- **ViewModel**: `DecksViewModel`

### 3. StatsView - 统计分析
- **功能**: 用户统计和进度跟踪
- **职责**: 用户统计、成就系统、活动历史
- **ViewModel**: `StatsViewModel`

### 4. ProfileView - 个人中心
- **功能**: 用户资料和设置
- **职责**: 用户配置、应用设置、帮助信息

## 关键设计模式

### MVVM 架构
- **Model**: 定义数据结构和业务规则
- **View**: 纯UI组件，通过数据绑定与ViewModel交互
- **ViewModel**: 处理业务逻辑、数据持久化和状态管理

### 状态管理
- 使用 `@StateObject` 和 `@ObservableObject` 进行响应式数据绑定
- 通过 `@Published` 属性实现UI自动更新
- 数据持久化通过 UserDefaults 的 JSON 编码/解码

### 数据流
1. **Models** 定义数据结构和业务规则
2. **ViewModels** 处理业务逻辑、数据持久化和状态管理
3. **Views** 通过 `@StateObject` 和 `@ObservableObject` 绑定到ViewModels
4. **响应式更新** 通过 `@Published` 属性触发UI刷新

## 路由系统

### RouterPath 类
```swift
@MainActor
public class RouterPath: ObservableObject {
    @Published public var path: [RouterDestination] = []
    
    // 导航方法
    func navigate(to: RouterDestination)  // 推入新页面
    func pop()                           // 返回上一页
    func popToRoot()                     // 返回根页面
}
```

**设计特点:**
- 使用 `@MainActor` 确保线程安全
- `ObservableObject` + `@Published` 实现响应式 UI 更新
- 基于栈的导航管理

### 使用模式
1. **中心化路由**: 所有导航逻辑统一管理
2. **类型安全**: 编译时检查路由有效性
3. **参数传递**: 支持携带数据的路由跳转
4. **SwiftUI 集成**: 完美适配声明式 UI

## 关键特性

### 数据持久化
- 所有用户数据自动保存到 UserDefaults
- 使用 JSON 编码/解码保证数据完整性
- 支持复杂数据结构的序列化

### 实时更新
- ViewModels 中的更改立即反映在 UI 中
- 跨视图通信通过 NotificationCenter 实现
- 会话管理和闪卡进度跟踪

### 错误处理
- 适当的错误状态和用户反馈
- 业务逻辑与UI分离便于测试
- 防御性编程实践

## 测试考虑

### 可测试性
- ViewModels 可以独立进行单元测试
- 通过ViewModel初始化器提供模拟数据
- 业务逻辑与UI分离便于测试

### 测试策略
- 单元测试: ViewModels 和 Services
- 集成测试: 数据流和状态管理
- UI测试: 用户交互和导航流程 