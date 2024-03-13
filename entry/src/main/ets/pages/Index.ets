import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import CustomDialogTest from '../common/components/CustomDialogTest'
import IndexItem from '../common/builders/IndexItem'
import TabBuilder from '../common/builders/TabBuilder'

@Entry
@Component
struct Index {
  // 用于测试全局数据
  @State appStorage: string = "0"
  inputInfo: string
  // 用于定位Tabs
  @State currentIndex: number = 0
  @State currentValue: number = 40
  tabSelectedColor: ResourceStr = $r('app.color.blue')
  tabUnselectedColor: Color = Color.Black
  // 用于测试DatePicker
  @State isLunar: boolean = false
  @State show: number = 0
  selectedDate: Date = new Date("2024-2-15")
  // 用于测试自定义弹窗
  customDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTest({
      info: "啦啦啦"
    })
  })


  // 获取UIAbilityContext
  context = getContext(this) as common.UIAbilityContext

  build() {
    // Tab容器
    Tabs({ barPosition: BarPosition.End }) {
      // Tab第一页
      TabContent() {
        // List容器
        List({ space: 10 }) {
          ListItem() {
            IndexItem("JustTest页", () => router.pushUrl({ url: "pages/JustTestPage" }))
          }
          // 退出App
          ListItem() {
            IndexItem("退出App", () => this.context.terminateSelf())
          }
          // 全局保存数据
          ListItem() {
            Column({ space: 10 }) {
              Row() {
                Button("保存全局数据")
                  .button_normal()
                  .margin({ right: 10 })
                  .onClick(() => {
                    AppStorage.SetOrCreate("TestAppStorage", this.inputInfo)
                  })
                TextInput({ placeholder: "请输入要保存的数据" })
                  .height(50)
                  .width(200)
                  .onChange(input => {
                    this.inputInfo = input
                  })
              }

              Row() {
                Button("获取保存的全局数据")
                  .button_normal()
                  .onClick(() => {
                    this.appStorage = AppStorage.Get("TestAppStorage")
                  })
                  .margin({ right: 10 })
                Row() {
                  Text(this.appStorage)
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
              }

              Divider()
            }
            .alignItems(HorizontalAlign.Start)
          }
          // Slider
          ListItem() {
            Column({ space: 10 }) {
              Slider({ value: 40, step: 10, style: SliderStyle.InSet })
                .showSteps(true)
                .showTips(true)
                .onChange(value => {
                  console.log(this.currentValue.toString())
                  this.currentValue = value
                })

              // 按引用传递
              ShowText({ info: this.currentValue.toString(), hint: "当前值:" })

              Divider()
            }
            .width('100%')
          }
          // DatePicker
          ListItem() {
            Column({ space: 10 }) {
              DatePicker({ selected: this.selectedDate })
                .lunar(this.isLunar)
                .onChange(value => {
                  this.selectedDate.setFullYear(value.year, value.month, value.day)
                })
              Row({ space: 10 }) {
                Button("切换 阳历/阴历")
                  .margin({ top: 10 })
                  .onClick(() => {
                    this.isLunar = !this.isLunar
                  })
                Button("获取时间")
                  .margin({ top: 10 })
                  .onClick(() => {
                    AlertDialog.show(
                      {
                        message: `当前选择的时间为：${this.selectedDate.getFullYear()}-${this.selectedDate.getMonth() + 1}-${this.selectedDate.getDate()}`,
                        alignment: DialogAlignment.Bottom,
                        offset: { dx: 0, dy: -20 },
                        gridCount: 3
                      }
                    )
                  })
              }

              Divider()
            }
          }
          // Navigation
          ListItem() {
            IndexItem("Navigation", () => router.pushUrl({ url: "pages/NavigationTestPage" }))
          }
          // 自定义弹窗
          ListItem() {
            IndexItem("自定义弹窗", () => this.customDialogController.open())
          }
          // offset
          ListItem() {
            Column({ space: 10 }) {
              Stack() {
                Text("")
                  .width("50%")
                  .height(100)
                  .backgroundColor(0xaaa2c)
                Text("测试offset")
                  .width(50)
                  .height(50)
                  .backgroundColor(0xaaa2)
                  .offset({ x: 20, y: 20 })
              }

              Divider()
            }
            .backgroundColor(0xbbb2cb)
          }
          // 网络请求
          ListItem() {
            IndexItem("网络请求", () => router.pushUrl({ url: "pages/NetworkPage" }))
          }
          // 通知
          ListItem() {
            IndexItem("测试通知", () => router.pushUrl({ url: "pages/NotificationTestPage" }))
          }
          // 测试状态管理
          ListItem() {
            IndexItem("状态管理", () => router.pushUrl({ url: "pages/StateManagementPage" }))
          }
        }
        .width("100%")
        .margin({ top: 20 })
        .alignListItem(ListItemAlign.Center)

      }
      .tabBar(TabBuilder("首页", 0, this.tabSelectedColor, this.tabUnselectedColor, $r("app.media.home")))
      .align(Alignment.Top)


      // Tab第二页
      TabContent() {
        Text("Tab第二页")
      }
      .tabBar(TabBuilder("第二页", 1, this.tabSelectedColor, this.tabUnselectedColor,))
    }
    .onChange(index => {
      this.currentIndex = index
    })
  }
}

// @Extend拓展样式
@Extend(Button) function button_normal() {
  .width(150)
}

@Builder
function ShowText($$: {
  info: string,
  hint?: string
}) {
  Row() {
    Text($$.hint)
    Text($$.info)
  }
  .justifyContent(FlexAlign.Center)
}