package main

import (
	"fmt"
	"sort"
)

type Monkey struct {
	Items       []uint64
	Op          func(old uint64) uint64
	Test        func(uint64) bool
	TestMap     map[bool]uint64
	Inspections uint64
}

func main() {
	monkeys := parse()

	for i := 0; i < 10000; i++ {
		for j := range monkeys {
			m := &monkeys[j]
			for k := range m.Items {
				m.Inspections++

				new := m.Op(m.Items[k]) % (19 * 2 * 13 * 5 * 7 * 11 * 17 * 3)
				toMonkey := &monkeys[m.TestMap[m.Test(new)]]
				toMonkey.Items = append(toMonkey.Items, new)
			}
			m.Items = m.Items[0:0]
		}
	}

	inspections := make([]uint64, len(monkeys))
	for i, m := range monkeys {
		inspections[i] = m.Inspections
	}
	sort.Slice(inspections, func(i, j int) bool {
		return inspections[i] < inspections[j]
	})

	fmt.Print(inspections[len(inspections)-1] * inspections[len(inspections)-2])
}

func parse() []Monkey {
	return []Monkey{
		{
			Items:   []uint64{71, 86},
			Op:      func(old uint64) uint64 { return old * 13 },
			Test:    func(i uint64) bool { return i%19 == 0 },
			TestMap: map[bool]uint64{true: 6, false: 7},
		},
		{
			Items:   []uint64{66, 50, 90, 53, 88, 85},
			Op:      func(old uint64) uint64 { return old + 3 },
			Test:    func(i uint64) bool { return i%2 == 0 },
			TestMap: map[bool]uint64{true: 5, false: 4},
		},
		{
			Items:   []uint64{97, 54, 89, 62, 84, 80, 63},
			Op:      func(old uint64) uint64 { return old + 6 },
			Test:    func(i uint64) bool { return i%13 == 0 },
			TestMap: map[bool]uint64{true: 4, false: 1},
		},
		{
			Items:   []uint64{82, 97, 56, 92},
			Op:      func(old uint64) uint64 { return old + 2 },
			Test:    func(i uint64) bool { return i%5 == 0 },
			TestMap: map[bool]uint64{true: 6, false: 0},
		},
		{
			Items:   []uint64{50, 99, 67, 61, 86},
			Op:      func(old uint64) uint64 { return old * old },
			Test:    func(i uint64) bool { return i%7 == 0 },
			TestMap: map[bool]uint64{true: 5, false: 3},
		},
		{
			Items:   []uint64{61, 66, 72, 55, 64, 53, 72, 63},
			Op:      func(old uint64) uint64 { return old + 4 },
			Test:    func(i uint64) bool { return i%11 == 0 },
			TestMap: map[bool]uint64{true: 3, false: 0},
		},
		{
			Items:   []uint64{59, 79, 63},
			Op:      func(old uint64) uint64 { return old * 7 },
			Test:    func(i uint64) bool { return i%17 == 0 },
			TestMap: map[bool]uint64{true: 2, false: 7},
		},
		{
			Items:   []uint64{55},
			Op:      func(old uint64) uint64 { return old + 7 },
			Test:    func(i uint64) bool { return i%3 == 0 },
			TestMap: map[bool]uint64{true: 2, false: 1},
		},
	}
	// return []Monkey{
	// 	{
	// 		Items:   []uint64{79, 98},
	// 		Op:      func(old int) int { return old * 19 },
	// 		Test:    func(i int) bool { return i%23 == 0 },
	// 		TestMap: map[bool]int{true: 2, false: 3},
	// 	},
	// 	{
	// 		Items:   []int{54, 65, 75, 74},
	// 		Op:      func(old int) int { return old + 6 },
	// 		Test:    func(i int) bool { return i%19 == 0 },
	// 		TestMap: map[bool]int{true: 2, false: 0},
	// 	},
	// 	{
	// 		Items:   []int{79, 60, 97},
	// 		Op:      func(old int) int { return old * old },
	// 		Test:    func(i int) bool { return i%13 == 0 },
	// 		TestMap: map[bool]int{true: 1, false: 3},
	// 	},
	// 	{
	// 		Items:   []int{74},
	// 		Op:      func(old int) int { return old + 3 },
	// 		Test:    func(i int) bool { return i%17 == 0 },
	// 		TestMap: map[bool]int{true: 0, false: 1},
	// 	},
	// }
}
