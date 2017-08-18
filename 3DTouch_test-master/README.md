# 3DTouch_test
study 3DTouch


----
###效果图
![image](https://github.com/tt3tt3tt/3DTouch_test/raw/master/gif/3d-1.gif)

![image](https://github.com/tt3tt3tt/3DTouch_test/raw/master/gif/3d.gif)

----
###简单介绍
####1. 在`AppDelegate`的`didFinishLaunchingWithOptions`中注册
```swift
let itemIcon1 = UIApplicationShortcutIcon.init(templateImageName: "AIcon")
let item1 = UIApplicationShortcutItem.init(type: "type1", localizedTitle: "title1", localizedSubtitle: "subTitle1", icon: itemIcon1, userInfo: nil)

let itemIcon2 = UIApplicationShortcutIcon.init(templateImageName: "rightIcon")
let item2 = UIApplicationShortcutItem.init(type: "type2", localizedTitle: "title2", localizedSubtitle: "subTitle2", icon: itemIcon2, userInfo: nil)

let itemIcon3 = UIApplicationShortcutIcon.init(type: .Add)
let item3 = UIApplicationShortcutItem.init(type: "type3", localizedTitle: "title3", localizedSubtitle: "subTitle3", icon: itemIcon3, userInfo: nil)

let itemIcon4 = UIApplicationShortcutIcon.init(type: .Alarm)
let item4 = UIApplicationShortcutItem.init(type: "type4", localizedTitle: "title4", localizedSubtitle: "subTitle4", icon: itemIcon4, userInfo: nil)

UIApplication.sharedApplication().shortcutItems = [item1, item2, item3, item4]
```
**效果如图**
![image](https://github.com/tt3tt3tt/3DTouch_test/raw/master/gif/10.png)

- 可以自定义图标
- 最多注册4个
- 也可以在infoPlist里注册

####2. Item对应的响应事件
```swift
func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
switch shortcutItem.type {
case "":
balabala~~~
default:
balabala~~~
}
}
```
####3. 给对应view注册3Dtouch事件
`registerForPreviewingWithDelegate(self, sourceView: view)`

####4.实现`UIViewControllerPreviewingDelegate`代理
返回弹出的控制器, 通过`preferredContentSize`设置弹出的大小
```swift
func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
return viewControler
}
```
弹出的控制器后继续重按得回调
```swift 
func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {

}
```
弹出的控制器后往上滑弹出的选项( 重写previewActionItems )
```swift
override func previewActionItems() -> [UIPreviewActionItem] {
let item1 = UIPreviewAction.init(title: "item1", style: .Destructive) { (_, _) in  ~~blabla~~ }

let item2 = UIPreviewAction.init(title: "item2", style: .Default) { (_, _) in  ~~blabla~~ }

let item3 = UIPreviewAction.init(title: "item3", style: .Selected) { (_, _) in  ~~blabla~~ }

return [item1, item2, item3]
}
```
效果图

![image](https://github.com/tt3tt3tt/3DTouch_test/raw/master/gif/215.png)


####5. 获取重按力度
```swift 
override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
let touch = touches.first ?? UITouch()
print("\(touch.force)")
}
```
效果图

![image](https://github.com/tt3tt3tt/3DTouch_test/raw/master/gif/143.png)