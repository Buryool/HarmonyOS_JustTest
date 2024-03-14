@Preview
@CustomDialog
export default struct SetUserNameDialog {
  controller: CustomDialogController

  build() {
    Column({ space: 10 }) {
      Text("请输入新用户名")
        .fontSize(15)
      TextInput()
        .width(150)
        .onChange(value => {

        })
      Row({space: 20}){
        Button("确定")
          .onClick(() => {

          })
        Button("取消")
          .onClick(() => {
            this.controller.close()
          })
      }
    }
    .width(180)
    .padding(10)
  }
}