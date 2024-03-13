@Builder
export default function TabBuilder(title: string, index: number, tabSelectedColor: ResourceStr | Color, tabUnselectedColor: ResourceStr | Color, image?: ResourceStr) {
  Column({
    space: 4
  }) {
    if (this.currentIndex === index) {
      Image(image).fillColor(this.tabSelectedColor).width(30)
    } else {
      Image(image).width(30)
    }
    Text(title).fontColor(this.currentIndex === index ? tabSelectedColor : tabUnselectedColor)
  }
}
