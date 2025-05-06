# README

## 介绍
这是一个业务流程自动化系统

## 核心模块
* 公司管理：维护企业基础信息

* 账户系统：管理企业账户信息

* 支付管理：配置多种支付方式

* 地址管理：存储地址信息

* 邮箱系统：管理主邮箱和子邮箱关系

* 计划执行：配置和执行自动化业务流程

## 依赖
如果要运行playwright,需要运行
```
npm install playwright
./node_modules/.bin/playwright install
```

## 快速启动

```
bundle install
rails db:create
rails db:migrate
rails s
```
