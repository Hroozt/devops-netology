// You can edit this code!
// Click here and start typing.
package main

import "fmt"

func matic(fl float64) {
    output := fl * 0.3048
    fmt.Print(output)
}

func main(){
    fmt.Print("Select prog:")
    var input int
    fmt.Scanf("%d", &input)
    tmp := input
    fmt.Print("Was input ", tmp, "\n")
    if tmp == 1 {
         fmt.Print("Enter number:")
         var meters float64
         fmt.Scanf("%f", &meters)
         matic(meters)
    }  else {
         fmt.Printf("There is unknowun program. Good Bye")
    }
}