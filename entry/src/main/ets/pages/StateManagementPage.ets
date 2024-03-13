class People {
  name: string
  age: number
  phone: Phone

  constructor(name: string, age: number, phone: Phone) {
    this.name = name
    this.age = age
    this.phone = phone
  }
}

class Phone {
  brand: string
  price: number

  constructor(brand: string, price: number) {
    this.brand = brand
    this.price = price
  }
}

@Entry
@Component
struct StateManagement {
  @State num_state: number = 0
  @State people: People = new People("whb", 22, new Phone("HUAWEI", 7150))
  @State numberArray: number[] = [1, 2, 3, 4]
  @State peopleArray: People[] = [new People("whb", 22, new Phone("HUAWEI", 7150)), new People("wyl", 21, new Phone("iPhone", 7000))]
  @Provide("num") num_provide: number = 1
  @Provide("object") people_provide: People = new People("whb", 22, new Phone("HUAWEI", 7150))
  @Provide("numArray") numberArray_provide: number[] = [1, 2, 3, 4]
  @Provide("peopleArray_provide") peopleArray_provide: People[] = [new People("whb", 22, new Phone("HUAWEI", 7150)), new People("wyl", 21, new Phone("iPhone", 7000))]
  @State @Watch("stateAction") stateArg: number = 0
  @State show: number = 0

  stateAction() {
    this.show++
  }

  build() {
    List() {
      // @State相关：
      ListItem() {
        Column() {
          titleBuilder("@State相关：")
          // 测试普通变量改变（UI刷新）
          RowBuilder({ text: `num: ${this.num_state}`, onClick: () => this.num_state++ })
          // 测试对象中的属性改变（UI刷新）
          RowBuilder({ text: `people.age: ${this.people.age}`, onClick: () => this.people.age++ })
          // 测试对象中的对象的属性发生改变（UI不刷新）
          RowBuilder({
            text: `people.phone.price: ${this.people.phone.price}`,
            onClick: () => this.people.phone.price++
          })
          // 测试数组中的值发生改变（UI刷新）
          RowBuilder({ text: `[1, 2, 3, 4][0]: ${this.numberArray[0]}`, onClick: () => this.numberArray[0]++ })
          // 测试数组中的对象的属性发生改变（UI不刷新）
          RowBuilder({
            text: `peopleArray[0].age: ${this.peopleArray[0].age}`,
            onClick: () => this.peopleArray[0].age++
          })
        }
        .width('100%')
        .padding(10)
      }

      // @Prop相关：
      ListItem() {
        Column() {
          titleBuilder("@Prop相关")
          Child_Prop({ num_prop: this.num_state })
        }
        .width("100%")
        .padding(10)

      }

      // @Link相关
      ListItem() {
        Column() {
          titleBuilder("@Link相关")
          Child_Link({
            num_link: $num_state,
            people_link: $people,
            numberArray_link: $numberArray,
            peopleArray_link: $peopleArray
          })
        }
        .width("100%")
        .padding(10)

      }

      // @Provide @Consume相关
      ListItem() {
        Column() {
          titleBuilder("@Provide @Consume相关")
          RowBuilder({ text: `num_provide: ${this.num_provide}`, onClick: () => this.num_provide++ })
          RowBuilder({ text: `people_provide: ${this.people_provide.age}`, onClick: () => this.people_provide.age++ })
          RowBuilder({
            text: `[1, 2, 3, 4][0]_provide: ${this.numberArray_provide[0]}`,
            onClick: () => this.numberArray_provide[0]++
          })
          RowBuilder({
            text: `peopleArray[0].age_provide: ${this.peopleArray_provide[0].age}`,
            onClick: () => this.peopleArray_provide[0].age++
          })

          Child_Provide_Consume()
        }
        .width("100%")
        .padding(10)
      }

      // @Watch相关
      ListItem() {
        Column() {
          titleBuilder("@Watch相关")
          Column({ space: 10 }) {
            Text(`show: ${this.show}`)
            Text(`stateArg: ${this.stateArg}`)
            Button("stateArg + 2")
              .onClick(() => {
                this.stateArg += 2
              })
          }
        }
        .width("100%")
        .padding(10)
      }

    }

  }
}

// 测试@Prop
@Component
struct Child_Prop {
  @Prop num_prop: number

  build() {
    Column() {
      RowBuilder({ text: `num_prop: ${this.num_prop}`, onClick: () => this.num_prop++ })
    }
    .width('100%')
  }
}

// 测试@Link
@Component
struct Child_Link {
  @Link num_link: number
  @Link people_link: People
  @Link numberArray_link: number[]
  @Link peopleArray_link: People[]

  build() {
    Column() {
      RowBuilder({ text: `num_link: ${this.num_link}`, onClick: () => this.num_link++ })
      RowBuilder({ text: `people_link: ${this.people_link.age}`, onClick: () => this.people_link.age++ })
      RowBuilder({ text: `[1, 2, 3, 4][0]: ${this.numberArray_link[0]}`, onClick: () => this.numberArray_link[0]++ })
      // 数组中对象的属性变化无法触发UI刷新
      RowBuilder({
        text: `peopleArray[0].age: ${this.peopleArray_link[0].age}`,
        onClick: () => this.peopleArray_link[0].age++
      })
    }
    .width('100%')
  }
}

// 测试@Provide @Consume
@Component
struct Child_Provide_Consume {
  @Consume("num") num_consume: number
  @Consume("object") people_consume: People
  @Consume("numArray") numberArray_consume: number[]
  @Consume("peopleArray_provide") peopleArray_consume: People[]

  build() {
    Column() {
      RowBuilder({ text: `num_consume: ${this.num_consume}`, onClick: () => this.num_consume++ })
      RowBuilder({ text: `people_consume.age: ${this.people_consume.age}`, onClick: () => this.people_consume.age++ })
      RowBuilder({
        text: `[1, 2, 3, 4][0]_provide: ${this.numberArray_consume[0]}`,
        onClick: () => this.numberArray_consume[0]++
      })
      RowBuilder({
        text: `peopleArray[0].age_provide: ${this.peopleArray_consume[0].age}`,
        onClick: () => this.peopleArray_consume[0].age++
      })

    }
    .width('100%')
  }
}

@Builder function RowBuilder($$: {
  text: string,
  onClick: Function
}) {
  Column() {
    Row() {
      Text($$.text)
      Button("+1")
        .onClick(() => {
          $$.onClick()
        })
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
  }
  .padding({ bottom: 2 })

}

@Builder function titleBuilder(title: string) {
  Column({ space: 10 }) {
    Blank()
    Divider()
    Text(title)
      .fontWeight(FontWeight.Bold)
    Blank()
  }
  .width("90%")
}