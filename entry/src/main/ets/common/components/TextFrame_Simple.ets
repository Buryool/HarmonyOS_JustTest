@Component
export default struct TextFrame_Simple {
  @BuilderParam title?: () => void = undefined
  @BuilderParam message: () => void = undefined

  build() {
    Column({space: 10}) {
      if (this.title){
        Blank()
        this.title()
        Divider()
          .width("90%")
      }
      this.message()
      Blank()
    }
    .width('85%')
    .border({width: 1})
    .borderRadius(10)
  }
}