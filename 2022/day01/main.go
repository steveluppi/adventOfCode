package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"sort"
)
func checkError(e error){
	if e != nil {
		log.Fatalf("Error: %s", e)
	}
}

func readLinesToStringArray(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

func silver(lines []string) (int){
	var biggest,sum int = 0, 0

	for _, line := range lines {
		if line =="" {
			if sum > biggest {
				biggest = sum
			}
			sum = 0
			continue
		}
		intV, err := strconv.Atoi(line)
		checkError(err)
		sum += intV
	}
	return biggest
}

func gold(lines []string) (int){
	var sums []int 
	var sum int = 0
	for _, line := range lines {
		if line =="" {
			sums = append(sums, sum)
			sum=0
			continue
		}
		intV, err := strconv.Atoi(line)
		checkError(err)
		sum += intV
	}
	sums = append(sums, sum)

	sort.Sort(sort.Reverse(sort.IntSlice(sums)))

	sum=0
	for i, sumV := range sums {
		if i<3 {
			sum += sumV
		} else {
			break
		}
	}
	return sum
}


func main() {
	lines, err := readLinesToStringArray("./first.txt")
	checkError(err)

	var biggest int = silver(lines)
	fmt.Println(biggest)
	var goldV int = gold(lines)
	fmt.Println(goldV)
}

