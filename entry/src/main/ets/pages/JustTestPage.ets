@Entry
@Component
struct TestCustomComponentAsArguments {
  @Builder title(){
    Text("title")
  }
  @Builder message(){
    Text("message message message message message message ")
  }
  build() {
    Row() {
      Column() {
        Template({message: this.message})
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct Template {
  @BuilderParam title?: () => void = undefined
  @BuilderParam message: () => void = undefined

  build() {
    Column() {
      if (this.title) {
        this.title()
        Divider()
      }
      this.message()
    }
    .width('80%')
    .border({width: 1})
    .borderRadius(10)
  }
}