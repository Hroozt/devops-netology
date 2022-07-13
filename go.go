// You can edit this code!
// Click here and start typing.
package main

import (
"fmt"
"math/rand"
)

func matic() {
    var tmp float64
    fmt.Print("Введите метры: ")
    fmt.Scan(&tmp)
    fmt.Print("В футах это будет: ", tmp * 0.3048, "\n")
    main ()
}

func matic2() {
    var len int
    fmt.Println ("Введите длину массива случайны числе : \n")
    fmt.Scan(&len)
    x := randomArray(len)
    current := 0
    fmt.Println ("Список значений : ", x)
    for i, value := range x {
        if (i == 0) {
           current = value
        } else {
            if (value < current){
                current = value
            }
        }
    }
    fmt.Println("Минимальное число : ", current)
    main()
}

func matic3() {
    for i := 1; i <= 100; i++ {
            if (i%3) == 0 {
                fmt.Print(i,", ")
                }
        }
    fmt.Print("\n")
    main ()
}

func randomArray(len int) []int {
    a := make([]int, len)
    for i := 0; i <= len-1; i++ {
        a[i] = rand.Intn(len)
    }
    return a
}

func main(){
    fmt.Print("Select prog: \n 1 - Перевод Метров в Футы \n 2 - Поиск минимального значения \n 3 - Числа от 1 до 100, которые делятся на 3 \n 0 - Выход \n Pls select: ")
    var input int
    fmt.Scan(&input)
    if input == 1 {
         matic()
    } else if input == 2 {
         matic2()
    } else if input == 3 {
         matic3()
    } else {
         fmt.Printf("Всего вам хорошего!")
    }
}