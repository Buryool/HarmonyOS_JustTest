import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import IndexItem from '../common/builders/IndexItem'
import TabBuilder from '../common/builders/TabBuilder'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0

  tabSelectedColor: ResourceStr = $r('app.color.blue')
  tabUnselectedColor: Color = Color.Black



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
          ListItem() {
            IndexItem("NormalTest页", () => router.pushUrl({ url: "pages/NormalTestPage" }))
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