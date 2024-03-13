@Builder
export default function IndexItem(buttonInfo: string, buttonFunc: Function) {
  Column({
    space: 10
  }) {
    Button(buttonInfo)
      .button_normal()
      .onClick(() => {
        buttonFunc()
      })
    Divider()
  }
}

// @Extend拓展样式
@Extend(Button) function button_normal() {
  .width(150)
}