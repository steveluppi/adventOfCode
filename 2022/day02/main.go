package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
	// "strconv"
	// "sort"
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
	SCORE := map[string]int{
		"A X": 3 + 1,
		"A Y": 6 + 2,
		"A Z": 0 + 3,
		"B X": 0 + 1,
		"B Y": 3 + 2,
		"B Z": 6 + 3,
		"C X": 6 + 1,
		"C Y": 0 + 2,
		"C Z": 3 + 3,
	}
	var sum int = 0
	for _,line := range(lines){
		// fmt.Println(line, SCORE[line])
		// fmt.Println(SCORE[line])
		sum += SCORE[line]
	}

	return sum
}

func gold(lines []string) (int){
	STRAT := map[string]string{
		"A X": "Z",
		"A Y": "X",
		"A Z": "Y",
		"B X": "X",
		"B Y": "Y",
		"B Z": "Z",
		"C X": "Y",
		"C Y": "Z",
		"C Z": "X",
	}
	SCORE := map[string]int{
		"A X": 3 + 1,
		"A Y": 6 + 2,
		"A Z": 0 + 3,
		"B X": 0 + 1,
		"B Y": 3 + 2,
		"B Z": 6 + 3,
		"C X": 6 + 1,
		"C Y": 0 + 2,
		"C Z": 3 + 3,
	}
	var sum int = 0
	for _,line := range(lines){
		var round []string = strings.Split(line, " ")
		var move string = STRAT[line]
		var play = round[0] + " " + move
		sum += SCORE[play]
	}
	return sum
}


func main() {
	lines, err := readLinesToStringArray("./silver.txt")
	checkError(err)
	// for _,line := range(lines) {
	// 	fmt.Println(line)
	// }
	var score1 int = silver(lines)
	fmt.Println(score1)
	var score2 int = gold(lines)
	fmt.Println(score2)
}
