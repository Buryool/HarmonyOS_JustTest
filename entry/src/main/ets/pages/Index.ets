import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import IndexItem from '../common/builders/IndexItem'
import TabBuilder from '../common/builders/TabBuilder'
import { Constants } from '../common/Constants'
import { Log } from '../common/utils/Log'
import { UserLoginUtil } from '../common/utils/UserLoginUtil'
import { User } from '../services/Auth'
import { MinePage } from './Account/MinePage'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  tabSelectedColor: ResourceStr = $r('app.color.blue')
  tabUnselectedColor: Color = Color.Black

  // 获取UIAbilityContext
  context = getContext(this) as common.UIAbilityContext

  async aboutToAppear() {
    // 从磁盘获取到之前登录的用户，并将其读取进内存
    let user: User = await UserLoginUtil.getLoginUser(getContext(this));
    if (user.uid) {
      Log.log("成功从首选项中读取到之前用户的数据")
      UserLoginUtil.setLoginUserToMemory(user)
    } else {
      Log.log("首选项中并无已登录的用户信息")
      router.replaceUrl({ url: Constants.PAGE_LOGIN });
    }
  }

  build() {
    // Tab容器
    Tabs({ barPosition: BarPosition.End }) {
      // Tab第一页
      TabContent() {
        Column({ space: 10 }){
          Text("首页")
          .fontSize(25)
          // List容器
          List({ space: 10 }) {
            ListItem() {
              IndexItem("JustTest页", () => router.pushUrl({ url: Constants.PAGE_JUST_TEST}))
            }

            ListItem() {
              IndexItem("NormalTest页", () => router.pushUrl({ url: Constants.PAGE_NORMAL_TEST}))
            }


          }
          .width("100%")
          .margin({ top: 20 })
          .alignListItem(ListItemAlign.Center)
        }
      }
      .tabBar(TabBuilder("首页", 0, this.tabSelectedColor, this.tabUnselectedColor, $r("app.media.home")))
      .align(Alignment.Top)


      // Tab第二页
      TabContent() {
        MinePage()
      }
      .tabBar(TabBuilder("我的", 1, this.tabSelectedColor, this.tabUnselectedColor, $r("app.media.user")))
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