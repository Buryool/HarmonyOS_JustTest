@CustomDialog
export default struct dialog {
  controller: CustomDialogController
  private info: string = "默认显示内容"

  build() {
    Text(this.info)
      .fontSize(20)
  }
}