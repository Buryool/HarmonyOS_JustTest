@Extend(Column) function setColumnStyle(height) {
  .height(height)
  .width('90%')
  .margin({ left: 16, right: 16 })
  .backgroundColor(Color.White)
  .borderRadius(8)
}

@Extend(Text) function setTextStyle() {
  .fontSize(10)
  .fontColor('#979797')
  .margin({ top: 10 })
}

@Extend(Text) function setTextStyle1() {
  .fontSize(14)
  .fontWeight(400)
  .padding(16)
}

import Prompt from '@system.prompt';
import router from '@ohos.router';
import { Constants } from '../../common/Constants';
import { AGCAuth, User } from '../../services/Auth';
import { formatDate } from '../../common/utils/CommonUtil';
import { UserLoginUtil } from '../../common/utils/UserLoginUtil';



@Entry
@Component
export struct MinePage {
  @StorageLink('user') currentUser: User = new User();
  @State currentSize:number = 0  // 当前上传大小
  @State totalSize:number = 0 //上传文件总大小

  async loginOut() {
    try {
      let isLogout = await AGCAuth.logout();
      if (isLogout) {
        router.replaceUrl({ url: Constants.PAGE_LOGIN });
      } else {
        Prompt.showToast({ message: '登出失败' })
      }
    }catch (err){
      console.log('logout error',JSON.stringify(err));
    }
  }


  uploadProgress(eventData){
    console.log('eventData->',JSON.stringify(eventData))
    this.currentSize = eventData.data.uploadSize;
    this.totalSize = eventData.data.totalSize;
  }


  // 定义自定义弹窗
  // dialogController: CustomDialogController = new CustomDialogController({
  //   builder: BindEmailDialog(),
  //   customStyle: true,
  //   autoCancel: true
  // })

  build() {

    Row() {
      Column({ space: 20 }) {

        Progress({ value: this.currentSize, total: this.totalSize, type: ProgressType.Linear })
          .color('#0094ff')
          .width('100%')

        // 用户昵称和头像部分
        Stack() {
          Column() {
            // 头像+昵称
            Column() {
              Image($r("app.media.wei_xin_tou_xiang"))
                .width(64)
                .aspectRatio(1)
                .borderRadius(32)
                .interpolation(ImageInterpolation.High) //减轻低清晰度图片在放大显示时出现的锯齿问题

              Text(this.currentUser.uid.toString())
                .fontSize(16)
                .fontWeight(400)
                .fontColor('#2B364B')
                .margin({ top: 12 })
            }
            .position({ x: 16, y: -32 })

          }
          .setColumnStyle(80)
        }
        .margin({ top: 88 })

        // 手机号码，上次登录时间部分
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('登录账号')
              .setTextStyle1()
            Text(this.currentUser.phone.length > 0 ? this.currentUser.phone.toString() : this.currentUser.email.toString())
              .setTextStyle1()
          }
          .height(44)

          Divider()
            .color('rgba(0,0,0,0.05)')
            .width('90%')

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('上次登录时间')
              .setTextStyle1()
            Text(formatDate(this.currentUser.lastLogin.toString()))
              .setTextStyle1()
          }
          .height(44)
        }
        .setColumnStyle(88)


        // 登出
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('登出')
              .setTextStyle1()
            Row() {
              Image($r('app.media.ic_right'))
                .width(16)
                .aspectRatio(1)
                .fillColor(Color.Gray)
            }
            .layoutWeight(1)
            .height(44)
            .justifyContent(FlexAlign.End)
          }
          .height(44)
        }
        .setColumnStyle(44)
        .onClick(() => {
          this.loginOut()
        })
      }
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 180,
      colors: [['#E9F2FF', 0.01], ['#fff', 100]]
    })
  }
}