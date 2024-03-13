import notification from '@ohos.notification';
import notificationManager from '@ohos.notificationManager';
import image from '@ohos.multimedia.image';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';

/**
 * 目前为止只有图片型通知在真实手机上无法显示，其他的基本都可以正常显示，但是真实手机和模拟机的显示效果还是有一定区别
 */
@Entry
@Component
struct NotificationTestPage {
  notificationId: number = 0
  pixelPicture: PixelMap
  wantAgent: WantAgent

  // 将公用的方法提取出来
  private publish(req: notificationManager.NotificationRequest) {
    notificationManager.publish(req)
      .then(() => {
        console.log("发送通知成功")
      })
      .catch(err => {
        console.log("发送通知失败：" + err)
      })
  }

  // 异步方式处理通知意图
  getWantAgentObj_async(wantInfo: wantAgent.WantAgentInfo) {
    // 创建WantAgent
    wantAgent.getWantAgent(wantInfo)
      .then(wantAgent => {
        this.wantAgent = wantAgent
      })
  }

  // 同步方式处理通知意图
  async getWantAgentObj_sync(wantInfo: wantAgent.WantAgentInfo) {
    let result: WantAgent
    result = await wantAgent.getWantAgent(wantInfo)
    return result
  }

  async aboutToAppear() {
    // 获取资源管理器
    let resourceManager = getContext(this).resourceManager
    // 读取图片
    let picture = await resourceManager.getMediaContent($r("app.media.watchGT4")) // TODO 这里试了一下自己的微信头像发现不能显示，不知道是为什么
    // 创建PixelMap
    image.createImageSource(picture.buffer).createPixelMap()
      .then(pixel => {
        this.pixelPicture = pixel
        console.log("创建pixelMap成功")
      })
      .catch(err => {
        console.log(err)
      })

    // 设置wantAgent
    // 通过WantAgentInfo的operationType设置动作类型。
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          deviceId: '',
          bundleName: 'com.example.justtest',
          abilityName: 'EntryAbility',
          action: '',
          entities: [],
          uri: '',
          parameters: {}
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    }

    // 异步方式
    // this.getWantAgentObj_async(wantAgentInfo)
    // 同步方式（按自己这种处理来看同步方式的方法耦合性更低）
    this.wantAgent = await this.getWantAgentObj_sync(wantAgentInfo)
  }

  publishTNotification_normal() {
    let notificationRequest_normal: notificationManager.NotificationRequest = {
      id: this.notificationId++,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: "普通文本型通知",
          text: "通知内容通知内容通知内容通知内容通知内容通知内容通知内容通知内容"
        }
      },
      deliveryTime: new Date().getTime(),
      showDeliveryTime: true,
      groupName: "JustTest",
      slotType: notification.SlotType.SOCIAL_COMMUNICATION,
      wantAgent: this.wantAgent
    }

    this.publish(notificationRequest_normal)
  }

  publishTNotification_long() {
    let notificationRequest_normal: notificationManager.NotificationRequest = {
      id: this.notificationId++,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
        longText: {
          title: "长文本型通知",
          text: "通知内容详情",
          longText: "长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本长文本",
          briefText: "没啥用",
          expandedTitle: "通知展开时的标题"
        }
      },
      deliveryTime: new Date().getTime(),
      showDeliveryTime: true,
      groupName: "JustTest",
      slotType: notification.SlotType.SOCIAL_COMMUNICATION
    }

    this.publish(notificationRequest_normal)
  }

  publishTNotification_multiline() {
    let notificationRequest_normal: notificationManager.NotificationRequest = {
      id: this.notificationId++,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE,
        multiLine: {
          title: "多行型通知",
          text: "通知内容详情",
          longTitle: "展开时的标题",
          briefText: "没啥用",
          lines: [
            "第1行",
            "第2行",
            "第3行",
            "第4行"
          ]
        }
      },
      deliveryTime: new Date().getTime(),
      showDeliveryTime: true,
      groupName: "JustTest",
      slotType: notification.SlotType.SOCIAL_COMMUNICATION
    }

    this.publish(notificationRequest_normal)
  }

  publishTNotification_picture() {
    let notificationRequest_normal: notificationManager.NotificationRequest = {
      id: this.notificationId++,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE,
        picture: {
          title: "图片型通知",
          text: "通知内容详情",
          additionalText: "附加内容",
          briefText: "通知概要和总结",
          expandedTitle: "展开时的标题",

          picture: this.pixelPicture
        }
      },
      deliveryTime: new Date().getTime(),
      showDeliveryTime: true,
      groupName: "JustTest",
      slotType: notification.SlotType.SOCIAL_COMMUNICATION
    }

    this.publish(notificationRequest_normal)
  }

  build() {
    Row() {
      Column({ space: 10 }) {
        Button("普通文本型")
          .onClick(() => {
            this.publishTNotification_normal()
          })

        Button("长文本型")
          .onClick(() => {
            this.publishTNotification_long()
          })
        Button("多行文本型")
          .onClick(() => {
            this.publishTNotification_multiline()
          })

        Button("图片型")
          .onClick(() => {
            this.publishTNotification_picture()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}