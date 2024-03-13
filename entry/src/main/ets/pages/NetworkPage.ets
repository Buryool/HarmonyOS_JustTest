import http from '@ohos.net.http'
import PreferenceUtil from '../common/utils/PreferencesUtil'

@Entry
@Component
struct NetworkPage {
  @State result: string = "尚未请求"
  httpRequest = http.createHttp()
  poems: Array<string> = new Array<string>()

  async aboutToAppear(){
    this.poems = await PreferenceUtil.getPreferenceValue("NetWorkPagePreference","poems",new Array<string>()) as unknown as Array<string>
  }

  build() {
    Column() {
      Column() {
        Button("发起网络请求").onClick((event: ClickEvent) => {
          this.httpRequest.request("https://api.apiopen.top/api/sentences",
            {
              method: http.RequestMethod.GET
            },
            (err, data) => {
              if (!err) {
                this.result = `${JSON.parse(`${data.result}`).result.from}: ${JSON.parse(`${data.result}`).result.name}`
                this.poems.push(this.result)
                console.log(this.poems.toString())
              }
            })
        })
      }
      .margin({ top: 30 })
      .height(50)
      .justifyContent(FlexAlign.Center)

      Column({ space: 10 }) {
        Text("本次请求结果：")
        Text(this.result)
      }

      List() {
        ListItem()
      }

    }
    .width('100%')
  }
}