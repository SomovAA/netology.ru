package main

import "testing"

func TestMin(t *testing.T) {
	var min int
	min = Min([]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17})

	if min != 9 {
		t.Error("Expected 9, got ", min)
	}
}
