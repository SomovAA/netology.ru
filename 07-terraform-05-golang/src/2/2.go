package main

import "fmt"

func Min(x []int) int {
	min := 0
	for i := range x {
		if min > x[i] {
			min = x[i]
			continue
		}

		if i == 0 {
			min = x[i]
		}
	}

	return min
}

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	fmt.Println(Min(x))
}
